# Strips out all white space from a string
exports.trimString = (str) ->
  str.replace(/\s/g,"")
