class IOSTransport {
    send(event, data) {
        window.webkit.messageHandlers.game.postMessage({
            event,
            data
        });
    }
}

class AndroidTransport {
    send(event, data) {
        AndroidBridge.postMessage(
            JSON.stringify({ event, data })
        );
    }
}

class WebTransport {
    send(event, data) {
        console.log(event, " : ", data);
    }
}