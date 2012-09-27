JUMLY = {}
core = JUMLY

_factories = (name, fact)-> _factories[name] = factory:fact

JUMLY.def = (name, type)-> _factories name, (_, opts)-> new type _, opts


jumly = (arg, opts) ->
  if (typeof arg is "object" && !arg.type)
    mapJqToJy = (arg) ->
      if (typeof arg is "object" && !(typeof arg.length is "number" && typeof arg.data is "function"))
        arg = $(arg)  # regard as a DOM node
      for i in [0..arg.length-1]
        a = $(arg[i]).self()
        arg[i] = if !a then null else a
      arg
    return mapJqToJy arg
  
  arg = $.extend({}, if typeof arg is "string" then {type:arg} else arg)
  meta = _factories[arg.type]
  throw "unknown type '" + arg.type + "'" if meta is undefined
  
  opts = $.extend arg, {name:null}, if typeof opts is "object" then opts else {name:opts}
  a = meta.factory opts
  a.find(".name:eq(0)").html(opts.name)
  a.name(opts.name) if opts.name
  a.attr id:opts.id if opts.id
  
  # Common methods
  a.gives = jumly.lang._gives(a, opts)
  a.data "uml:property", _self:a, type:arg.type, name: opts.name, stereotypes: -> []
  a

$.jumly = jumly

$.fn.jprops = -> @data("uml:property")
$.fn.self = -> @jprops()?._self
$.fn.selfEach = (f)-> @each (i, e)->
  e = $(e).self()
  throw new Error("self() returned undefined.", e) unless e?
  f e
  this

##
prefs_ = {}
preferences_ = (a, b)->
  if !b and typeof a is "string"
    return prefs_[a]
  prefs_[a] = $.extend prefs_[a], b

jumly.preferences = preferences_

$.fn.name = (n)->
  return @jprops()?.name if arguments.length is 0 or n is undefined
  @find(".name:eq(0)").html n
  @jprops()?.name = n
  this
$.fn.stereotype = (n)->
  return @jprops()?.stereotype if arguments.length is 0 or n is undefined
  @find(".stereotype:eq(0)").html n
  @jprops()?.stereotype = n
  switch @jprops().type
    when ".interaction" then @find(".message:eq(0)").self().stereotype n
    when ".message" then @addClass n
  this

## v0.1.1a
JUMLY.Naming =
  toID: (that)->
    return that.attr("id") if that.constructor is jQuery
    that.toLowerCase().replace /[^a-zA-Z0-9_]/g, "-"
  toRef: (s)->
    if s.match /^[0-9].*/
      '_' + s
    else
      s.replace(/^[0-9]|-/g, '_')
  toCSSClass: (s)->s.replace(/^JUMLY/, "").replace(/Diagram$/, "-Diagram").toLowerCase()
  
JUMLY.Identity =
  normalize: (that)->
    toID = JUMLY.Naming.toID
    switch $.kindof that
      when "String" then return id:toID(that), name:that
      when "Object" then ## Through down
      else
        if that and that.constructor is jQuery
          id = toID(that)
          name = that.find(".name")
          if id? or (name.length > 0)
            return id:id, name: (if name.html() then name.html() else undefined)
          else
            return undefined
        console.error "Cannot recognize kind:", that
        throw new Error "Cannot recognize kind: '#{$.kindof that}'"
    keys = (p for p of that)
    return that if keys.length > 1

    id = keys[0]
    it = that[keys[0]]
    return {id:id, name:it} if $.kindof(it) is "String"

    keys = (p for p of it)
    return $.extend {}, it, {id:toID(id), name:id} if keys.length > 1

    name = keys[0]
    mods = it[keys[0]]
    switch $.kindof(mods)
      when "Object" then $.extend {id:id, name:name}, mods
      when "Array", "Function"
        a = {id:toID(id), name:id}
        a[name] = mods
        a

class JUMLYDiagramLayout
JUMLYDiagramLayout::_q = (sel)-> $ sel, @diagram
JUMLYDiagramLayout::layout = (diagram)->
  @diagram = diagram
  @prefs = diagram.preferences()
  @_layout_?()

JUMLY.DiagramLayout = JUMLYDiagramLayout


class JUMLYError extends Error
  constructor: (@type, @message, @arguments, @cause, @jumlipt)->
    if typeof @type is "object"
      @type = p.type
      @message = p.message
      @arguments = p.arguments
JUMLY.Error = JUMLYError


class JUMLYPreferences
  @put = (a, b)-> JUMLYPreferences.values[a] = b
  @get = (a)->
    e = JUMLYPreferences.values[a]
    if typeof e is "function" then e() else e

JUMLY.Preferences = (a)->
  if typeof a is "string"
    JUMLYPreferences.get a
  else
    k = (e for e of a)[0]
    JUMLYPreferences.put k, a[k]

JUMLYPreferences.values =
  "document.id.validation.enable": false

core.env =
  is_node: typeof module != 'undefined' and module.exports

if core.env.is_node
  module.exports = core
else
  window.JUMLY = core
  window.require = (name)->
    core[name] or core