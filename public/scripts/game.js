var wsUri = "ws://" + window.location.host + "/game";
var output;
var input

function init() {
    output = document.getElementById("output");
    input = document.getElementById("message");
    input.addEventListener("keydown", sendMessage, false);
    testWebSocket();
}

function testWebSocket() {
    websocket = new WebSocket(wsUri);
    websocket.onopen = onOpen;
    websocket.onclose = onClose;
    websocket.onmessage = onMessage;
    websocket.onerror = onError;
}

function onOpen(evt) {
    writeToScreen("CONNECTED");
}

function onClose(evt) {
    writeToScreen("DISCONNECTED");
}

function onMessage(evt) {
    writeToScreen('<p style="color: blue;">RESPONSE:</p>');
    evt.data.split('\n').forEach(writeToScreen);
    window.scrollTo(0, document.body.scrollHeight);
}

function onError(evt) {
    writeToScreen('<span style="color: red;">ERROR:</span> ' + evt.data);
}

function sendMessage(event) {
    if (event.keyCode != 13) { return; }
    
    writeToScreen("SENT: " + input.value);
    websocket.send(input.value);
    
    input.value = "";
}

function writeToScreen(message) {
    var pre = document.createElement("p");
    pre.style.wordWrap = "break-word";
    pre.innerHTML = message;
    output.appendChild(pre);
}

window.addEventListener("load", init, false);
