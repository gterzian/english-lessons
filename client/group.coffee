Template.group.manager = (group) ->
  Meteor.userId() in groups.findOne(group).managers

Template.group.group = ->
  groups.findOne(_id:Session.get('group'))

Template.group.activities = ->
  activities.find(
    group:Session.get('group'), 
    {sort:{'date': "asc"}}
  )

Template.group.tests = ->
  tests.find(
    group:Session.get('group'), 
    {sort:{'date': "asc"}}
  )
  
Template.group.participant_count = (activity) ->
  "#{_.size(activity.participants)}"
  
Template.group.events = 
  
  'click .choose_activity': (e,t) ->
    e.preventDefault()
    target = e.target.hash[1...]
    Session.set('activity', target)
  
  'click .choose_test': (e,t) ->
    e.preventDefault()
    target = e.target.hash[1...]
    Session.set('test', target)
    
  'click #add_activity': (e,t) ->
    e.preventDefault()
    if t.find("#activity_title").value
      id = activities.insert
        description: t.find("#activity_description").value
        title: t.find("#activity_title").value
        group:  Session.get('group')
        date: Date.now()
        participants: []
        max: t.find("#activity_max").value
      t.find("#activity_max").value = ''
      t.find("#activity_title").value = ''
      t.find("#activity_description").value = ''
      $('#add_activity').click()
      $("[href='##{id}']").click()
    
  'click .participate': (e,t) ->
    e.preventDefault()
    activity = activities.findOne(e.target.id)
    unless "#{_.size(activity.participants)}" is activity.max
      unless Meteor.userId() in activity.participants
        activities.update(
          e.target.id,
          $addToSet:
            participants: Meteor.userId()
        )
        
  'click #add_test': (e,t) ->
    e.preventDefault()
    if t.find("#test_title").value
      _id = tests.insert
        description: t.find("#test_description").value
        title: t.find("#test_title").value
        group:  Session.get('group')
      
      t.find("#test_title").value = ''
      t.find("#test_description").value = ''
      $('#add_test').click()
     
      
   