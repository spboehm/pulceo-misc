#!/usr/bin/python 
 
import websocket
import stomper

if __name__ == "__main__":
    websocket.enableTrace(True)
    
    def on_open(ws):
        ws.send("CONNECT\naccept-version:1.0,1.1,2.0\n\n\x00\n")
        sub = stomper.subscribe("/metrics/asdf", "username", ack="auto")
        ws.send(sub)

    def on_message(wsapp, message):
        print(message)

    wsapp = websocket.WebSocketApp("ws://localhost:7777/ws", on_open=on_open, on_message=on_message)
    wsapp.run_forever()