testSyntax = "@found 'You', ->
  @message 'get', 'JUMLY'"

jsEnv = require('jsdom').env

containerDocument = "<html><body><script type='text/jumly+sequence'>#{testSyntax}</script></body></html>"
jsEnv containerDocument, (errors, window) ->
        
        # jQuery
        global.jQuery = global.$ = require('jquery')(window)
        global.document = window.document


        # require all
        require "./core"
        require "./jquery.g2d"
        require "./jquery.ext"
        require "./HTMLElement"
        require "./Diagram"
        require "./DiagramBuilder"
        require "./DiagramLayout"
        require "./HTMLElementLayout"
        require "./NoteElement"
        require "./Position"
        require "./Relationship"
        require "./SequenceLifeline"
        require "./SequenceMessage"
        require "./SequenceInteraction"
        require "./SequenceOccurrence"
        require "./SequenceParticipant"
        require "./SequenceFragment"
        require "./SequenceRef"
        require "./SequenceDiagram"
        require "./SequenceDiagramBuilder"
        require "./SequenceDiagramLayout"
        require "./IconElement"
        require "./RobustnessDiagram"
        require "./RobustnessDiagramBuilder"
        require "./RobustnessDiagramLayout"
        require "./api"

        JUMLY.scan()
        # jQuery hack to get outerHtml
        diagram = ($('<div/>').append $(".diagram"))

        jumlyInclude = "<link href='http://jumly.tmtk.net/release/jumly.min.css' rel='stylesheet'/>" +
                "<script src='http://code.jquery.com/jquery-2.1.0.min.js'></script>" +
                "<script src='http://coffeescript.org/extras/coffee-script.js'></script>" +
                "<script src='http://jumly.tmtk.net/release/jumly.min.js'></script>"
        console.log "<html><head>#{jumlyInclude}</head><body>#{diagram.html()}</body></html>"
