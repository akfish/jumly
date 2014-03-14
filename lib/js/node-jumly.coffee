core = require "./core"
api = require "./api"

console.log JUMLY

testSyntax = "@found 'you'"

html = JUMLY._compile testSyntax
console.log html
