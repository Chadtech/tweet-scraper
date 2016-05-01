req     = require 'request'
cheerio = require 'cheerio'
_       = require 'lodash'

tweeter = process.argv[2]

req 'https://www.twitter.com/' + tweeter, 
  (error, res, html) ->
    if not error and res.statusCode is 200
      
      tweets = []
      
      $ = cheerio.load html
      $ '.tweet'
        .children '.content'
        .each ->
          header = {}
          $ this
            .children '.stream-item-header'
            .children '.js-user-profile-link'
            .each ->
              header.username = $ this
                .children '.username'
                .text()
              header.fullname = $ this
                .children '.fullname'
                .text()
              header.avatar = $ this
                .children '.avatar'
                .attr 'src'
          header.time = $ this
            .children '.stream-item-header'
            .children '.time'
            .children '.tweet-timestamp'
            .attr 'title'

          body = {}
          body.text = $ this
            .children '.js-tweet-text-container'
            .children '.tweet-text'
            .text()
          body.media = []
          $ this
            .children '.js-tweet-text-container'
            .children '.tweet-text'
            .children '.twitter-timeline-link'
            .each ->
              body.media.push ($ this).text()

          tweets.push { body, header }

      console.log tweets

    else
      console.log error