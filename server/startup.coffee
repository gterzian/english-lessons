Meteor.startup ->
  Meteor.publish "Groups", -> 
    groups.find()
  
  Meteor.publish "Activities", -> 
    activities.find()
  
  Meteor.publish "Tests", -> 
    tests.find()
  
  Meteor.publish "Items", -> 
    items.find()
  
  Meteor.publish "Tries", ->
    tries.find()
  
  Meteor.publish "Chats", ->
    chats.find()
  
  Meteor.publish "Matches", ->
    matches.find()