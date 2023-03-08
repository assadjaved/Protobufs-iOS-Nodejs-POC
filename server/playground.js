const protobuf = require('protobufjs');

const root = protobuf.loadSync('../protos/BookInfo.proto');

const BookInfo = root.lookupType('BookInfo');

const info1 = BookInfo.create({
    id: 1,
    title: "protobufs 101",
    author: "Asad Javed"
});

const buffer = BookInfo.encode(info1).finish();

const decoded = BookInfo.decode(buffer);

console.log(`decoded id: ${decoded.id}`);
console.log(`decoded title: ${decoded.title}`);
console.log(`decoded author: ${decoded.author}`);
