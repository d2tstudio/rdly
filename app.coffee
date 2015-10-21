if Meteor.isClient

    Template.tags.helpers
      tag: ->
          myEntries = Entries.find()

    Template.userCard.helpers
      user: ->
        Meteor.user()

    Template.entries.helpers
      entry: ->
          myEntries = Entries.find().fetch()
      totalEntries: ->
          Entries.find().count()

    Template.entries.rendered = ->
      # Load Entries
      entries = Meteor.call "loadEntriesByTag", (error, result) ->
        #Entries.remove({})
        if error
          console.log "error", error
        if result
          allEntries = []
          for tag, entries of result.data.taggedEntries
              splittag = tag.split "/"
              #console.log "tagged:", splittag.slice(-1), v
              for entry in entries
                console.log("entry: " + entry)
                # Build composite entries array
                allEntries.push entry

          console.log("entries: " + allEntries)
          writeAllEntries = Meteor.call "loadEntries", (allEntries), (err,res) ->
              if(err)
                console.log("Not written all entries, call failed")
              if (res)
                console.log "loaded all entries, ready to rock the layout: ", res.data
              # Call POST method with composite array to write full entries
                # Write array of entries
                Entries.insert article for article in res.data
