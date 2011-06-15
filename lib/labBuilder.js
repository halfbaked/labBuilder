(function() {
  var fs, template;
  fs = require('fs');
  exports.build = function(labjs, scriptsToLoad, outputFile) {
    var completeScriptLoader, encoding, loadScriptsCode, s, _i, _len;
    loadScriptsCode = "$LAB";
    for (_i = 0, _len = scriptsToLoad.length; _i < _len; _i++) {
      s = scriptsToLoad[_i];
      loadScriptsCode += ".script(\"" + s['src'] + "\")";
    }
    completeScriptLoader = template.replace('LOAD_SCRIPTS', loadScriptsCode).replace('PATH_TO_LABJS', labjs);
    return fs.writeFile(outputFile, completeScriptLoader, encoding = 'utf8', function(err) {
      if (err) {
        throw err;
      } else {
        return console.log("New Script Loader Created");
      }
    });
  };
  template = "(function (global, oDOC, handler) {\n    var head = oDOC.head || oDOC.getElementsByTagName(\"head\");\n\n    function LABjsLoaded() {\n        // do cool stuff with $LAB here\n        LOAD_SCRIPTS\n    }\n\n    // loading code borrowed directly from LABjs itself\n    setTimeout(function () {\n        if (\"item\" in head) { // check if ref is still a live node list\n            if (!head[0]) { // append_to node not yet ready\n                setTimeout(arguments.callee, 25);\n                return;\n            }\n            head = head[0]; // reassign from live node list ref to pure node ref -- avoids nasty IE bug where changes to DOM invalidate live node lists\n        }\n        var scriptElem = oDOC.createElement(\"script\"),\n            scriptdone = false;\n        scriptElem.onload = scriptElem.onreadystatechange = function () {\n            if ((scriptElem.readyState && scriptElem.readyState !== \"complete\" && scriptElem.readyState !== \"loaded\") || scriptdone) {\n                return false;\n            }\n            scriptElem.onload = scriptElem.onreadystatechange = null;\n            scriptdone = true;\n            LABjsLoaded();\n        };\n        scriptElem.src = \"PATH_TO_LABJS\";\n        head.insertBefore(scriptElem, head.firstChild);\n    }, 0);\n\n    // required: shim for FF <= 3.5 not having document.readyState\n    if (oDOC.readyState == null && oDOC.addEventListener) {\n        oDOC.readyState = \"loading\";\n        oDOC.addEventListener(\"DOMContentLoaded\", handler = function () {\n            oDOC.removeEventListener(\"DOMContentLoaded\", handler, false);\n            oDOC.readyState = \"complete\";\n        }, false);\n    }\n})(window, document);";
}).call(this);
