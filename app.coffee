if Meteor.isClient
    Template.registerHelper "hasLoaded", (argument) ->
        Session.get "hasLoaded"

    Template.tags.helpers
      tag: ->
          myEntries = Entries.find()

    Template.userCard.helpers
      user: ->
        this.data()

    Template.entries.helpers
      entry: ->
          myEntries = Entries.find().fetch()
      totalEntries: ->
          Entries.find().count()

    Template.entries.rendered = ->
      # Load Entries
      Session.set "viewingUser", this.data._id
      entries = Meteor.call "loadEntriesByTag", this.data.services.feedly.accessToken, (error, result) ->
        Session.set "hasLoaded", false

        #Entries.remove({})
        if error
          console.log "error", error
        if result
          allEntries = []
          allTags = []
          for tag, entries of result.data.taggedEntries
              splittag = tag.split "/"
              #console.log "tagged:", splittag.slice(-1), v
              allTags.push splittag.slice(-1)
              for entry in entries
                # console.log("entry: " + entry)
                # Build composite entries array
                allEntries.push entry

          console.log("entries: " + allEntries)
          console.log("tags: " + allTags)

          updateUserTags = Meteor.call "updateUserTags", {"user":Session.get("viewingUser"), "tags":allTags}, (error, result) ->
            if error
              console.log "Failed to update user tags!", error
            if result
              console.log "Updated user tags."

          writeAllEntries = Meteor.call "loadEntries", (allEntries), (err,res) ->
              if(err)
                console.log("Not written all entries, call failed")
              if (res)
                console.log "loaded all entries, ready to rock the layout: ", res.data
              # Call POST method with composite array to write full entries
                # Write array of entries
                Entries.insert article for article in res.data
                Session.set "hasLoaded", true
