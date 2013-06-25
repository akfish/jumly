self = require: if (typeof module != 'undefined' and typeof module.exports != 'undefined') then require else JUMLY.require
###
<div class="class icon">
  <span class="stereotype">abstract</span>
  <span class="name">UMLObject</span>
  <ul class="attrs">
    <li>name</li>
    <li>stereotypes</li>
  </ul>
  <ul class="methods">
    <li>activate</li>
    <li>isLeftAt(a)</li>
    <li>isRightAt(a)</li>
    <li>iconify(fixture, styles)</li>
    <li>lost</li>
  </ul>
</div>
###

HTMLElement = self.require "HTMLElement"

class ClassElement extends HTMLElement
  constructor: (args, opts)->
    super args, (me)->
      icon = $("<div>")
               .addClass("icon")
               .append($("<div>").addClass "stereotype")
               .append($("<div>").addClass "name")
               .append($("<ul>").addClass "attrs")
               .append($("<ul>").addClass "methods")
      me.append(icon)

core = self.require "core"
if typeof module != 'undefined' and module.exports
  module.exports = ClassElement
else
  core.exports ClassElement
