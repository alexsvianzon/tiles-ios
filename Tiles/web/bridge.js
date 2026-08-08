class Bridge {
    constructor(transport) {
        this.transport = transport;
        this.handlers = new Map();
    }

    on(type, callback) {
        this.handlers.set(type, callback);
    }

    receive(type, data) {
        const handler = this.handlers.get(type);
        if (handler) {
            console.log(type, " : ", data)
            handler(data);
        } else {
            console.warn("The message: ", message, "could not be processed.");
            this.transport.send("no");
        }
    }

    emit(event, data) {
        this.transport.send(event, data);
    }
}
