require 'digest/sha1'
require 'mime/types'

class User < ActiveRecord::Base

    # prevents a user from submitting a crafted form that bypasses activation
    # anything else you want your user to change should be added here.
    attr_accessor :password
    attr_protected :crypted_password, :salt, :remember_token, :remember_token_expires_at, :activation_code, :activated_at,
                   :password_reset_code, :enabled, :can_send_messages, :is_active, :created_at, :updated_at, :plone_password

    validates_presence_of     :password,                   :if => :password_required?
    validates_presence_of     :password_confirmation,      :if => :password_required? && Proc.new { |u| !u.password.blank? }
    validates_length_of       :password, :within => 4..40, :if => :password_required? && Proc.new { |u| !u.password.blank? }
    validates_confirmation_of :password,                   :if => :password_required? && Proc.new { |u| !u.password.blank? }

    validates_presence_of     :login, :email
    validates_uniqueness_of   :login, :email, :case_sensitive => false
    
    validates_length_of       :login, :within => 3..40, :if => Proc.new { |u| !u.login.blank? }    
    validates_format_of       :login, :with => /^[a-z0-9-]+$/i, :on => :create, :message => 'may only contain letters, numbers or a hyphen.'
    
    validates_length_of       :email, :within => 6..100,:if => Proc.new { |u| !u.email.blank? }
    validates_format_of       :email, :with => /(^([^@\s]+)@((?:[-_a-z0-9]+\.)+[a-z]{2,})$)|(^$)/i, :message => 'does not look like a valid email address.'
    validates_uniqueness_of   :email, :case_sensitive => false

    #validates_acceptance_of :terms_of_service, :allow_nil => false, :accept => true
    #validates_acceptance_of :terms_of_service, :on => :create

    composed_of :tz, :class_name => 'TZInfo::Timezone', :mapping => %w( time_zone time_zone )

    has_many :permissions
    has_many :roles, :through => :permissions

    # Feeds
    has_many :feeds
    has_many :feed_items, :through => :feeds, :order => 'created_at desc'
    has_many :private_feed_items, :through => :feeds, :source => :feed_item, :conditions => {:is_public => false}, :order => 'created_at desc'
    has_many :public_feed_items, :through => :feeds, :source => :feed_item, :conditions => {:is_public => true}, :order => 'created_at desc'

    # Messages
    has_many :sent_messages,     :class_name => 'Message', :order => 'created_at desc', :foreign_key => 'sender_id'
    has_many :received_messages, :class_name => 'Message', :order => 'created_at desc', :foreign_key => 'receiver_id'
    has_many :unread_messages,   :class_name => 'Message', :conditions => ["read=?",false] 

    # Friends
    has_many :friendships, :class_name  => "Friend", :foreign_key => 'inviter_id', :conditions => "status = #{Friend::ACCEPTED}"
    has_many :follower_friends, :class_name => "Friend", :foreign_key => "invited_id", :conditions => "status = #{Friend::PENDING}"
    has_many :following_friends, :class_name => "Friend", :foreign_key => "inviter_id", :conditions => "status = #{Friend::PENDING}"

    has_many :friends,   :through => :friendships, :source => :invited
    has_many :followers, :through => :follower_friends, :source => :inviter
    has_many :followings, :through => :following_friends, :source => :invited

    # Comments and Blogs
    has_many :comments, :as => :commentable, :order => 'created_at desc'
    has_many :blogs, :order => 'created_at desc'

    # Photos
    has_many :photos, :order => 'created_at DESC'
    
    # Skills
    has_and_belongs_to_many :grade_level_experiences
    has_and_belongs_to_many :languages
    
    # Search
    acts_as_ferret :fields => [ :location, :f, :about_me ], :remote=>true

    file_column :icon, :magick => {
        :versions => { 
            :big => {:crop => "1:1", :size => "150x150", :name => "big"},
            :medium => {:crop => "1:1", :size => "100x100", :name => "medium"},
            :small => {:crop => "1:1", :size => "50x50", :name => "small"}
        }
    }

    before_save :encrypt_password, :lower_login
    before_create :make_activation_code

    class ActivationCodeNotFound < StandardError; end
    class AlreadyActivated < StandardError
        attr_reader :user, :message;
        def initialize(user, message=nil)
            @message, @user = message, user
        end
    end

    def validate
        unless terms_of_service == true
            errors.add(nil, "You must accept the terms of service" )
        end
    end

    def can_mail? user
        can_send_messages? && profile.is_active?
    end

    # Finds the user with the corresponding activation code, activates their account and returns the user.
    #
    # Raises:
    #  +User::ActivationCodeNotFound+ if there is no user with the corresponding activation code
    #  +User::AlreadyActivated+ if the user with the corresponding activation code has already activated their account
    def self.find_and_activate!(activation_code)
        raise ArgumentError if activation_code.nil?
        user = find_by_activation_code(activation_code)
        raise ActivationCodeNotFound if !user
        raise AlreadyActivated.new(user) if user.active?
        user.send(:activate!)
        user
    end

    def active?
        # the presence of an activation date means they have activated
        !activated_at.nil?
    end

    # Returns true if the user has just been activated.
    def pending?
        @activated
    end

    # checks to see if a given login is already in the database
    def self.login_exists?(login)
        if User.find_by_login(login).nil?
            false
        else
            true
        end
    end

    # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
    # Updated 2/20/08
    def self.authenticate(login, password)    
        u = find :first, :conditions => ['login = ? and activated_at IS NOT NULL', login] # need to get the salt
        u && u.authenticated?(password) ? u : nil
        # implement to add last logged in date
        #return nil if u.nil?                
        #u.logged_in_at = Time.now.utc
        #u.save(false) # don't validate.
        #u 
    end

    #lowercase all logins
    def lower_login
        self.login = self.login.downcase 
    end
    
    # Encrypts some data with the salt.
    def self.encrypt(password, salt)
        Digest::SHA1.hexdigest("--#{salt}--#{password}--")
    end

    # Encrypts the password with the user salt
    def encrypt(password)
        self.class.encrypt(password, salt)
    end

    def authenticated?(password)
        crypted_password == encrypt(password)
    end

    def remember_token?
        remember_token_expires_at && Time.now.utc < remember_token_expires_at
    end

    # These create and unset the fields required for remembering users between browser closes
    def remember_me
        remember_me_for 2.weeks
    end

    def remember_me_for(time)
        remember_me_until time.from_now.utc
    end

    def remember_me_until(time)
        self.remember_token_expires_at = time
        self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
        save(false)
    end

    def forget_me
        self.remember_token_expires_at = nil
        self.remember_token            = nil
        save(false)
    end

    def forgot_password
        @forgotten_password = true
        self.make_password_reset_code
    end

    def reset_password
        # First update the password_reset_code before setting the
        # reset_password flag to avoid duplicate email notifications.
        update_attribute(:password_reset_code, nil)
        @reset_password = true
    end  

    #used in user_observer
    def recently_forgot_password?
        @forgotten_password
    end

    def recently_reset_password?
        @reset_password
    end

    def self.find_for_forget(email)
        find :first, :conditions => ['email = ? and activated_at IS NOT NULL', email]
    end

    def has_role?(rolename)
        self.roles.find_by_rolename(rolename) ? true : false
    end

    def force_activate!
        @activated = true
        self.update_attribute(:activated_at, Time.now.utc)
    end

    def to_param
        "#{login.to_safe_uri}"
    end

    def has_network?
        !Friend.find(:first, :conditions => ["invited_id = ? or inviter_id = ?", id, id]).blank?
    end

    def f
        if self.first_name.blank? && self.last_name.blank?
            self.login rescue 'Deleted user'
        else
            ((self.first_name || '') + ' ' + (self.last_name || '')).strip
        end
    end

    def location
        return 'No where' if attributes['location'].blank?
        attributes['location']
    end

    def full_name
        f
    end

    def self.featured
        find_options = {
            :include => :user,
            :conditions => ["is_active = ? and about_me IS NOT NULL and user_id is not null", true],
        }
        find(:first, find_options.merge(:offset => rand( count(find_options) - 1)))
    end  

    def no_data?
        (created_at <=> updated_at) == 0
    end

    def has_wall_with profile
        return false if profile.blank?
        !Comment.between_users(self, profile).empty?
    end

    def website= val
        write_attribute(:website, fix_http(val))
    end
    def blog= val
        write_attribute(:blog, fix_http(val))
    end
    def flickr= val
        write_attribute(:flickr, fix_http(val))
    end

    # Friend Methods
    def friend_of? user
        user.in? friends
    end

    def followed_by? user
        user.in? followers
    end

    def following? user
        user.in? followings
    end
    
    def self.search query = '', options = {}
        query ||= ''
        q = '*' + query.gsub(/[^\w\s-]/, '').gsub(' ', '* *') + '*'
        options.each {|key, value| q += " #{key}:#{value}"}
        arr = find_by_contents q, :limit=>:all
        logger.debug arr.inspect
        arr
    end

    protected

    # before filter
    def encrypt_password
        return if password.blank?
        self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
        self.crypted_password = encrypt(password)
    end

    def password_required?
        not_openid? && (crypted_password.blank? || !password.blank?)
    end

    def not_openid?
        identity_url.blank?
    end

    def make_activation_code
        self.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
    end

    def make_password_reset_code
        self.password_reset_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
    end

    private

    def activate!
        @activated = true
        self.update_attribute(:activated_at, Time.now.utc)
    end    

    def fix_http str
        return '' if str.blank?
        str.starts_with?('http') ? str : "http://#{str}"
    end

end

