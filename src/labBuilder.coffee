# Core Class Where the Magic Happens

fs = require 'fs'

exports.build = (labjs, scriptsToLoad, outputFile) ->
  loadScriptsCode = "$LAB"
  loadScriptsCode += """.script("#{s['src']}")""" for s in scriptsToLoad
  completeScriptLoader = template.replace('LOAD_SCRIPTS', loadScriptsCode)
                                 .replace('PATH_TO_LABJS', labjs)
  fs.writeFile(outputFile, completeScriptLoader, encoding='utf8', (err) ->
    if err 
      throw err
    else 
      console.log "New Script Loader Created"
  )

template = """
(function (global, oDOC, handler) {
    var head = oDOC.head || oDOC.getElementsByTagName("head");

    function LABjsLoaded() {
        // do cool stuff with $LAB here
        LOAD_SCRIPTS
    }

    // loading code borrowed directly from LABjs itself
    setTimeout(function () {
        if ("item" in head) { // check if ref is still a live node list
            if (!head[0]) { // append_to node not yet ready
                setTimeout(arguments.callee, 25);
                return;
            }
            head = head[0]; // reassign from live node list ref to pure node ref -- avoids nasty IE bug where changes to DOM invalidate live node lists
        }
        var scriptElem = oDOC.createElement("script"),
            scriptdone = false;
        scriptElem.onload = scriptElem.onreadystatechange = function () {
            if ((scriptElem.readyState && scriptElem.readyState !== "complete" && scriptElem.readyState !== "loaded") || scriptdone) {
                return false;
            }
            scriptElem.onload = scriptElem.onreadystatechange = null;
            scriptdone = true;
            LABjsLoaded();
        };
        scriptElem.src = "PATH_TO_LABJS";
        head.insertBefore(scriptElem, head.firstChild);
    }, 0);

    // required: shim for FF <= 3.5 not having document.readyState
    if (oDOC.readyState == null && oDOC.addEventListener) {
        oDOC.readyState = "loading";
        oDOC.addEventListener("DOMContentLoaded", handler = function () {
            oDOC.removeEventListener("DOMContentLoaded", handler, false);
            oDOC.readyState = "complete";
        }, false);
"""
