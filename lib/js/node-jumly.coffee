testSyntax = "@found 'you'"

jsEnv = require('jsdom').env
containerDocument = '<html><body></body></html>'

jsEnv containerDocument, (errors, window) ->
        core = require "./core"
        api = require "./api"
        
        global.jQuery = global.$ = require('jquery')(window)

        d = JUMLY._compile(testSyntax)
        console.log d.html()
