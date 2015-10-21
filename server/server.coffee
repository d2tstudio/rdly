Meteor.methods
  loadEntriesByTag: (token) ->
    @unblock()
    Meteor.http.call "GET", "https://sandbox.feedly.com/v3/markers/tags",
      headers:
        'Authorization': 'Bearer ' + token

  loadEntries: (arr) ->
    @unblock()
    Meteor.http.call "POST", "https://sandbox.feedly.com/v3/entries/.mget",
      headers:
        'Content-type': 'application/json',
      data:
        arr

  updateUserTags: (obj) ->
    Meteor.users.update obj.user,
      $set: {'profile.tags': obj.tags}
