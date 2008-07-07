require File.dirname(__FILE__) + '/../test_helper'

class CommentTest < ActiveSupport::TestCase

  context 'A Comment instance' do
    should_belong_to :commentable
    should_belong_to :user
  end

  should "show me the wall between us" do
    comments = Comment.between_users users(:quentin), users(:aaron)
    assert_equal 1, comments.size
    assert_equal [comments(:third).id], comments.map(&:id).sort

    assert users(:quentin).comments.create(:comment => 'yo', :profile => users(:aaron))
    assert_equal 2, Comment.between_users( users(:quentin), users(:aaron)).size
  end

  should "show me the wall between me" do
    comments = Comment.between_users users(:quentin), users(:quentin)
    assert_equal 1, comments.size
    assert_equal [comments(:seven).id], comments.map(&:id).sort
  end

  should 'create new feed_item and feeds after someone else creates a comment' do
    assert_difference "FeedItem.count", 1 do
      assert_difference "Feed.count", 2 do
        p = users(:quentin)
        assert p.comments.create(:comment => 'omg yay test!', :profile_id => users(:aaron).id)
      end
    end
  end

  def test_associations
    _test_associations
  end
end