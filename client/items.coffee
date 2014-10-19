Session.setDefault('choices', [])
Session.setDefault('started', false)

Template.items.test = ->
  tests.findOne(_id:Session.get('test'))

Template.items.manager = (test) ->
  Meteor.userId() in groups.findOne(test.group).managers

Template.items.items = ->
  items.find(test:Session.get('test'))
  
Template.items.choices = ->
  Session.get('choices')

Template.items.started = (test) ->
  test._id is Session.get('started')

Template.items.started_another = (test) ->
  unless test._id is Session.get('started')
    Session.get('started')
    
Template.items.total_questions = ->
  items.find(test:Session.get('test')).count()

Template.items.percent_right = ->
  percent = (Number(tries.findOne(Session.get('current_try')).points) / items.find(test:Session.get('test')).count()) * 100
  "#{percent}%"
  
Template.items.current_try = ->
  tries.findOne(Session.get('current_try'))

Template.items.answered = (question)->
  if Session.get('current_try')
    question._id in tries.findOne(Session.get('current_try')).answered

Template.items.answer_for = (question)->
  answer_for(question)

Template.items.answered_correctly = (question) ->
  answer_for(question) is question.answer
  
Template.items.total_tries = (test) ->
  tries.find(test:test._id, userId:Meteor.userId()).count()

Template.items.all_user_tries = (test) ->
  tries.find(test:test._id, userId:{$not:Meteor.userId()}).count()

Template.items.get_sender = (chat) ->
  chat.username
    
Template.items.chats = (question_id) ->
  chats.find(question:question_id)

Template.items.new_match = (category) ->
  if Meteor.userId()
    true if matches.findOne(userId:Meteor.userId(), category:category, watched:false)
  else
    true if chats.find(question:category).count()
      
answer_for = (question) ->
  if Session.get('current_try')
    tried = tries.findOne(Session.get('current_try'))
    if question._id in tried.answered
      answers = _.object(tried.answered, tried.answers)
      answers[question._id]


Template.items.events = 
  'click .start': (e,t) ->
    Session.set('started', e.target.id)
    test = tests.findOne(Session.get('test'))
    current_try = tries.insert
      test: Session.get('test')
      userId: Meteor.userId()
      time: test.time
      answered: []
      answers: []
      points: 0
      result: ''
    Session.set('current_try', current_try)
    ###
    Meteor.setInterval(
      -> tries.update(current_try, {$inc: {time:-1}}), 
      60000
    )
    ###
  
  'click .stop': (e,t) ->
    Session.set('current_try', null)
    Session.set('started', null)

  'click #add_item': (e,t) ->
    e.preventDefault()
    if t.find("#item_title").value
      id = items.insert
        title: t.find("#item_title").value
        test:  Session.get('test')
        choices: Session.get('choices')
        answer: t.find("#answer").value
      t.find("#item_title").value = ''
      $('#add_item').click()
      $("[href='##{id}']").click()
      Session.set('choices', [])
  
  'click #add_choice': (e,t) ->
    Session.set('choices', _.union(Session.get('choices'), [t.find("#new_choice").value]))
    t.find("#new_choice").value = ''
  
  'click .choose_answer': (e,t) ->
    chosen = t.find("#chosen#{e.target.id}").value
    item = items.findOne(e.target.id)
    point = if chosen is item.answer then 1 else 0
    tries.update(
      Session.get('current_try'),
      $addToSet:
        answered: e.target.id
        answers: chosen
      $inc:
        points:
          point
    )
  
  'click .undo_answer': (e,t) ->
    question = items.findOne(e.target.id)
    answer = answer_for(question)
    tries.update(
      Session.get('current_try'),
      $pull:
        answered:
          question._id
        answers:
          answer
    )
    
  'click .send_chat': (e, t) ->
    question_id = e.target.id.split('_')[1]
    e.preventDefault()
    if content = t.find("#content_#{question_id}").value
      chats.insert
        sender: Meteor.userId() 
        username: Meteor.user().username 
        content: content
        time: new Date().getTime()
        question: question_id
      t.find("#content_#{question_id}").value = ''
  
  'click .view_question': (e,t) ->
    target = e.target.hash[1...]
    match = matches.find(category:target, userId:Meteor.userId(), watched:false)
    match.forEach (match) ->
      matches.update(match._id, 
        $set:
          watched:true)