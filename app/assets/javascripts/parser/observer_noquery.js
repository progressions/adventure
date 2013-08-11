(function() {
  window.Ajax = {
    xhr: function() {
      var xhr = null,
          ieXMLHttpVersions,
          i;
      if (typeof(XMLHttpRequest) !== undefined) {
        xhr = new XMLHttpRequest();
      } else if (window.ActiveXObject) {
        ieXMLHttpVersions = ['MSXML2.XMLHttp.5.0', 'MSXML2.XMLHttp.4.0', 'MSXML2.XMLHttp.3.0', 'MSXML2.XMLHttp', 'Microsoft.XMLHttp'];
        for (i = 0; i < ieXMLHttpVersions.length; i++) {
          try {
            xhr = new ActiveXObject(ieXMLHttpVersions[i]);
          } catch(e) {
            console.error(e);
          }
        }
      }
      return xhr;
    },

    post: function(url, parameters, callback) {
      Ajax.request("post", url, parameters, callback);
    },
    get: function(url, parameters, callback) {
      Ajax.request("get", url, parameters, callback);
    },

    request: function(method_type, url, parameters, callback) {
      var xhr = Ajax.xhr();

      console.log("Ajax.request", method_type);
      console.log("url", url);
      method_type = method_type || "get";

      // the last boolean parameter means 'asynchronous request'
      xhr.open(method_type, url + "?" + parameters, true);
      if (method_type.toLowerCase == "post") {
        xhr.setRequestHeader("Content-type","application/x-www-form-urlencoded");
      }
      xhr.send(null);
      xhr.onreadystatechange = function() {
        if (xhr.readyState === 4) {
          if (xhr.status === 200) {
            console.log("Success", xhr.responseText);
            if (typeof callback === "function") {
              callback(JSON.parse(xhr.responseText));
            }
          } else {
            // console.log("Error", xhr.responseText);
          }
        } else {
          console.log("still loading")
        }
      };
    }
  };

  window.NewObserver = {
    init: function() {
      NewObserver.show();
    },

    show: function() {
      Ajax.get("/game/show", {}, NewObserver.update);
    },

    submit: function(parser) {
      data = "command=" + encodeURIComponent(parser.json());
      Ajax.post("/game/command", data, NewObserver.update);
    },

    update: function(json) {
      try {
        if (json["error"]) {
          return;
        }

        console.log("NewObserver.update", json);

        var elements,
          i,
          className,
          output,
          output_container;

        // we only want one "latest" entry at a time
        // so remove the class "latest" from any that
        // have it now
        //
        elements = document.getElementsByClassName("latest");

        for (i = 0; i < elements.length; i++) {
          console.log(element.innerHTML);
          if (element.className) {
            className = element.className;
            className = className.replace("latest", "");
          }
        }

        // create new div for "latest" entry
        //
        output = document.createElement("DIV");

        output.innerHTML = "<h3>" + json["name"] + "</h3";
        output.innerHTML = output.innerHTML + "<p>" + json["description"] + "</p>";
        output.innerHTML = output.innerHTML + "<p>Exits: " + json["exits"].join(", ") + "</p>";
        output.innerHTML = output.innerHTML + "<p>Objects: " + json["objects"].join(", ") + "</p>";

        output_container = document.getElementById("output");
        if (output_container) {
          output_container.insertBefore(output, output_container.childNodes[0]);
        }

      } catch(e) {
        console.error(e.message);
      }
    }
  };
})();
