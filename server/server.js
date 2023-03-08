const fs = require('fs');
const https = require('https');
const WebSocket = require('ws');
const protobuf = require('protobufjs');

const root = protobuf.loadSync('../protos/BookInfo.proto');
const BookInfo = root.lookupType('BookInfo');

const server = https.createServer({
  cert: fs.readFileSync('cert.pem'),
  key: fs.readFileSync('key.pem')
});

const wss = new WebSocket.Server({ server });

wss.on('connection', function connection(ws) {
  console.log('Client connected');

  ws.on('message', function incoming(message) {
    console.log(`Received message: ${message}`);
    
    const book = BookInfo.decode(message);
    console.log(`received book id: ${book.id}`);
    console.log(`received book title: ${book.title}`);
    console.log(`received book author: ${book.author}`);
    
    const buffer = BookInfo.encode(book).finish();

    ws.send(buffer);
  });

  ws.on('close', function close() {
    console.log('Client disconnected');
  });
});

server.listen(8080, function() {
  console.log('Secure WebSocket server listening on port 8080');
});
