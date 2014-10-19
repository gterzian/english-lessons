groups = new Meteor.Collection('Groups')
groups.allow({
  insert: function (userId, doc) {
    return (userId && _.contains(doc.managers, userId));
  },
  update: function (userId, doc, fields, modifier) {
    return (userId && _.contains(doc.managers, userId));
  },
  remove: function (userId, doc) {
    return (userId && _.contains(doc.managers, userId));
  },
  fetch: ['managers']
})

activities = new Meteor.Collection('Activities')
activities.allow({
  insert: function (userId, doc) {
    group = groups.findOne({_id:doc.group})
    return (userId && _.contains(group.managers, userId));
  },
  update: function (userId, doc, fields, modifier) {
    group = groups.findOne({_id:doc.group})
    return (userId && _.contains(group.managers, userId));
  },
  remove: function (userId, doc) {
    group = groups.findOne({_id:doc.group})
    return (userId && _.contains(group.managers, userId));
  },
  fetch: ['group']
})

tests = new Meteor.Collection('Tests')
tests.allow({
  insert: function (userId, doc) {
    group = groups.findOne({_id:doc.group})
    return (userId && _.contains(group.managers, userId));
  },
  update: function (userId, doc, fields, modifier) {
    group = groups.findOne({_id:doc.group})
    return (userId && _.contains(group.managers, userId));
  },
  remove: function (userId, doc) {
    group = groups.findOne({_id:doc.group})
    return (userId && _.contains(group.managers, userId));
  },
  fetch: ['group']
})

items = new Meteor.Collection('Items')
items.allow({
  insert: function (userId, doc) {
    test = tests.findOne({_id:doc.test})
    group = groups.findOne({_id:test.group})
    return (userId && _.contains(group.managers, userId));
  },
  update: function (userId, doc, fields, modifier) {
    test = tests.findOne({_id:doc.test})
    group = groups.findOne({_id:test.group})
    return (userId && _.contains(group.managers, userId));
  },
  remove: function (userId, doc) {
    test = tests.findOne({_id:doc.test})
    group = groups.findOne({_id:test.group})
    return (userId && _.contains(group.managers, userId));
  },
  fetch: ['test']
})

tries = new Meteor.Collection('Tries')
tries.allow({
  insert: function (userId, doc) {
    return (userId && doc.userId == userId);
  },
  update: function (userId, doc, fields, modifier) {
    return (userId && doc.userId == userId);
  },
  remove: function (userId, doc) {
    return (userId && doc.userId == userId);
  },
  fetch: ['userId']
})

chats = new Meteor.Collection('Chats')
chats.allow({
  insert: function (userId, doc) {
    return (userId && doc.sender == userId);
  },
  update: function (userId, doc, fields, modifier) {
    return (userId && doc.sender == userId);
  },
  remove: function (userId, doc) {
    return (userId && doc.sender == userId);
  },
  fetch: ['sender']
})

matches = new Meteor.Collection('Matches')
matches.allow({
  insert: function (userId, doc) {
    return (userId && doc.userId == userId);
  },
  update: function (userId, doc, fields, modifier) {
    return (userId && doc.userId == userId);
  },
  remove: function (userId, doc) {
    return (userId && doc.userId == userId);
  },
  fetch: ['userId']
})