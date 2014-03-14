testSyntax = "@found 'You', ->
  @message 'get', 'JUMLY'"

jsEnv = require('jsdom').env

containerDocument = "<html><body><script type='text/jumly+sequence'>#{testSyntax}</script></body></html>"
jsEnv containerDocument, (errors, window) ->
        core = require "./core"
        api = require "./api"

        # Fix Math.sign undefined
        relationshipt = require "./Relationship"
        
        global.jQuery = global.$ = require('jquery')(window)
        global.document = window.document

        JUMLY.scan()
        # jQuery hack to get outerHtml
        diagram = ($('<div/>').append $(".diagram"))

        jumlyInclude = "<link href='http://jumly.tmtk.net/release/jumly.min.css' rel='stylesheet'/>" +
                "<script src='http://code.jquery.com/jquery-2.1.0.min.js'></script>" +
                "<script src='http://coffeescript.org/extras/coffee-script.js'></script>" +
                "<script src='http://jumly.tmtk.net/release/jumly.min.js'></script>"
        console.log "<html><head>#{jumlyInclude}</head><body>#{diagram.html()}</body></html>"
