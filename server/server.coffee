Meteor.methods
  loadEntriesByTag: ->
    @unblock()
    Meteor.http.call "GET", "https://sandbox.feedly.com/v3/markers/tags",
      headers:
        'Authorization': 'Bearer ' + Meteor.user().services.feedly.accessToken

  loadEntries: (arr) ->
    @unblock()
    Meteor.http.call "POST", "https://sandbox.feedly.com/v3/entries/.mget",
      headers:
        'Content-type': 'application/json',
      data:
        arr
