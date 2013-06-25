self = require: if (typeof module != 'undefined' and typeof module.exports != 'undefined') then require else JUMLY.require
DiagramBuilder = self.require "DiagramBuilder"
ClassDiagram = self.require "ClassDiagram"
core = self.require "core"

class ClassDiagramBuilder extends DiagramBuilder
  constructor: (@_diagram) ->
    super()
    @_diagram ?= new ClassDiagram

ClassDiagramBuilder::def = (props)->
  @diagram.declare core._normalize props

if typeof module != 'undefined' and module.exports
  module.exports = ClassDiagramBuilder
else
  core.exports ClassDiagramBuilder

