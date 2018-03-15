# https://chatbotslife.com/creating-a-nodejs-based-webhook-for-intelligent-bots-a91ecbe33402

express = require 'express'
bodyParser = require 'body-parser'
MongoClient = require('mongodb').MongoClient
_ = require 'lodash'

server = express()
server.use bodyParser.json()

db_url = "mongodb://#{process.env.mongoatlas_user}:#{process.env.mongoatlas_password}@rentbot-shard-00-00-dw7r3.mongodb.net:27017,rentbot-shard-00-01-dw7r3.mongodb.net:27017,rentbot-shard-00-02-dw7r3.mongodb.net:27017/test?ssl=true&replicaSet=rentbot-shard-0&authSource=admin"
 
MongoClient.connect db_url, (err, client) ->
  if err then throw Error err
  console.log "Connected successfully to MongoAtlas server"

  db = client.db('test')

  db.collection 'users', (err, collection) ->
    server.post '/get_fb_profile', (req, res) ->
      if req.body.originalRequest.data.user_profile?.first_name?
        res.json
          contextOut: [
            name: 'generic'
            parameters:
              fb_first_name: req.body.originalRequest.data.user_profile.first_name
          ]
      
      # generic_context = _.find req.body.result.contexts, name: 'generic'
      # if generic_context? and generic_context.parameters? and generic_context.parameters.fb_user_id?
      #   collection
      #     .findOne
      #       id: generic_context.parameters.fb_user_id
      #       , (err, doc) ->
      #         res.json
      #           contextOut: [
      #             name: 'generic'
      #             parameters:
      #               fb_first_name: doc.first_name
      #           ]
              # client.close()



port = process.env.PORT || 8000
server.listen port, () ->
  console.log "Server up and running on #{port}"
