express = require 'express'
#proxy = require 'express-http-proxy'
url = require 'url'
httpProxy = require 'http-proxy'
config = require './config'

app = express()

#app.use '/api', 
  #proxy 'localhost:28888', {} 
    #forwardPath: (req, res) -> url.parse(req.url).path
    
apiProxy = httpProxy.createProxyServer()

app.all '/api/*', (req,res)->
  apiProxy.web req, res, { target: 'http://localhost:28888' }

app.use express.static config.generated
app.use express.static __dirname + "/public"

app.listen process.env.PORT, () -> console.log 'listening...'

#express = require 'express'
#
#app = express()
#
#app.use express.static __dirname + "/generated"
#app.use express.static __dirname + "/public"
#
#app.listen process.env.PORT, () -> console.log 'listening...'
