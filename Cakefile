util   = require "util"
fs     = require "fs"
path   = require "path"
muffin = require "muffin"
glob   = require "glob"
_      = require "underscore"

libdir = "lib"
tmpdir = ".build" #(require "temp").mkdirSync()
basepath = "#{libdir}/build/jumly"
dstpath  = "#{basepath}.js"
minpath  = "#{basepath}.min.js"
version  = fs.readFileSync("#{libdir}/version").toString().trim() #replace /\n/, ""
header   = """
// JUMLY v#{version}, 2011-#{new Date().getFullYear()} copyright(c), all rights reserved.\n
"""

#option "-w", "--watch", "How do I specify argument?"


task "watch", "watch all", ->
  invoke "css"

task "css", "compile *.styl and watch them", ->
  require("child_process").exec "stylus -w views -o views/static", (err,stdout,stderr)->
    console.log err, stdout, stderr

task "compile", "compile *.coffee", ->
  muffin.run
    files: ["#{libdir}/js/*.coffee"]
    options: {}
    map:
      "([^/]+).coffee": (matches)->
        src = "#{libdir}/js/#{matches[1]}.coffee"
        dst = "#{tmpdir}/#{matches[1]}.js"
        a = (fs.statSync src).mtime
        b = (fs.statSync dst).mtime if path.existsSync dst
        dirty = a > b or not(a and b)
        muffin.compileScript src, dst, bare:false if dirty


task "concat", "concatenate", ->
  bodies = _.map (glob.sync "#{tmpdir}/*.js"), (e)-> (fs.readFileSync e).toString()
  muffin.writeFile dstpath, [header].concat(bodies).join ""


task "minify", "minify", ->
  muffin.run
    files: [dstpath]
    options: {}
    map:
      ".*": (matches)-> muffin.minifyScript matches[0]
    after: ->
      body = (fs.readFileSync minpath).toString()
      muffin.writeFile minpath, header + body

#task "doc", "", (opts)-> muffin.doccoFile("#{libdir}/js/core.coffee", opts)

task "spec", "print command line to run spec", ->
  invoke "spec::struct"

cmd = "jasmine-node --coffee #{libdir}/js"
task "spec::struct", "print command line to run spec::struct", ->
  console.log "#{cmd}/spec/struct"

task "spec::position", "print command line to run spec::position", ->
  console.log "#{cmd}/spec/position"

task "spec::legacy", "print command line to run legacy spec::legacy", ->
  console.log "#{cmd}/legacy"
