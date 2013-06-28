#!/usr/bin/env phantomjs
page = new WebPage

page.onConsoleMessage = (a)->
  console.log a

page.open "index.html", ->
  page.evaluate ->
    #a = (e for e of jasmine).map (e)-> e
    #console.log a.join("\n")
    f = ->
      a = $("#HTMLReporter .alert").html()
      if a.match /\//
        setTimeout f, 1000
        console.log a
      else
        console.log a
    f()

  page.evaluate ->
    console.log "hi"

  #phantom.exit()
