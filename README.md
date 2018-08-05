# SwiftWebRTCSignaling

In this example, I have implemented a demo Signaling server for WebRTC.

This demo is implemented based on the nodejs reference https://www.tutorialspoint.com/webrtc/webrtc_signaling.htm

## Compatibility with Swift

The master branch of this project currently compiles with **Xcode 9.2** or the **Swift 4.1** toolchain on Ubuntu.


## Building & Running

The following will clone and build an empty starter project and launch the server on port 8181.

```
git clone https://github.com/kamleshkatios/Swift-WebRTC-Signaling.git
cd Swift-WebRTC-Signaling
swift build
.build/debug/Swift-WebRTC-Signaling
```

You should see the following output:

```
[INFO] Starting HTTP server Chat on 0.0.0.0:8181
```
This means the server is running and waiting for connections. Access the API routes at [http://0.0.0.0:8181/](http://0.0.0.0:8181/). Hit control-c to terminate the server.

To Generate Xcode Project

```
swift package generate-xcodeproj
```

### IMPORTANT NOTE ABOUT XCODE

If you choose to generate an Xcode Project, you **MUST** change to the executable target **AND** setup a custom working directory wherever you cloned the project.

![Proper Xcode Setup](https://github.com/kamleshkatios/Swift-WebRTC-Signaling/raw/master/supporting/xcode_screenshot.png)

## Testing

To test the app run
- http:localhost:8181 on a chrome browser
- now run http:localhost:8181 on another chrome window
- Register user in both the window (UserA in first client and UserB in second client)
- Type UserA in the second client
- Signaling server will allow one user to call another. Once a user has called another, the server passes the offer, answer, ICE candidates between them and setup a WebRTC connection

Now if you notice, Both the clients are connected with each other. Once the connection is establised, the clients can still be able to communicate when the server is turned off.

## Webroot

Sample html and javacript files are in webroot directory.

If you want to test on intranet change the ip of the server in client.js file.

```
var conn = new WebSocket('ws://localhost:8181/chat', 'chat');
```
to

```
var conn = new WebSocket('ws://server_ip:8181/chat', 'chat');
```

## Further Information
For more information on the Perfect project, please visit [perfect.org](http://perfect.org).
