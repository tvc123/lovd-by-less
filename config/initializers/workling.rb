# sudo starling -d
# script/server
# script/workling_starling_client start

# if you comment out the following line all calls will be syncronous - useful for debugging
Workling::Remote.dispatcher = Workling::Remote::Runners::StarlingRunner.new

#this runner just executes everything normally
#Workling::Remote.dispatcher = Workling::Remote::Runners::NotRemoteRunner.new