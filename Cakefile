{spawn, exec} = require 'child_process'

# ANSI Terminal Colors.
bold  = "\033[0;1m"
red   = "\033[0;31m"
green = "\033[0;32m"
reset = "\033[0m"

# default handler for exec commands
onExec = (error, stdout, stderr) ->
  console.log stdout if stdout
  console.log stderr if stderr
  # print the error message and kill the process
  if error
    process.stdout.write "#{red}#{error.stack}#{reset}\n"
    process.exit -1

task "build", "Compile CoffeeScript to JavaScript", ->
  console.log "Compiling CoffeeScript in src directory to JavaScript in lib directory ..."
  exec "rm -rf lib && coffee --compile --lint --output lib src", (error, stdout, stderr) ->
    onExec error, stdout, stderr
 
