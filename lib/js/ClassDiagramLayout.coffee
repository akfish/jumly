self = require: if (typeof module != 'undefined' and typeof module.exports != 'undefined') then require else JUMLY.require
RobustnessDiagramLayout = self.require "RobustnessDiagramLayout"

class ClassDiagramLayout extends RobustnessDiagramLayout

core = self.require "core"
if core.env.is_node
  module.exports = ClassDiagramLayout
else
  core.exports ClassDiagramLayout
