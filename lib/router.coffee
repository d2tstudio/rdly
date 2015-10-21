Router.configure
  layoutTemplate:   'layout',
  loadingTemplate:  'loading'
  waitOn: ->
    Meteor.subscribe 'users'

Router.route '/',
  name: 'home'
  data: ->
    user: ->
      Meteor.users.find()
  onBeforeAction: ->
    if user = Meteor.user()
      Router.go 'profile', {username: user.services.feedly.givenName}
    else
      this.next()

Router.route '/:username',
  name: 'profile'
  data: ->
    Meteor.users.findOne({"services.feedly.givenName": this.params.username})

Router.route '/directory',
  name: 'directory'
  data: ->
    user: ->
        Meteor.users.find()
