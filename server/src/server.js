const app = require('express')();
const { Server } = require('socket.io');
const http = require('http');

async function server() {
  const server = http.createServer(app);
  const io = new Server(server, { transports: ['websocket'] });
  let socketMap = {};
  // 네이티브에서 최초 연결 진행
  io.on('connection', (socket) => {
    // 신규 멤버 입장
    socket.on('join', (data) => {
      console.log(`==[Connected ${data['userName']}(${data['userKey']}) to Join ${data['roomKey']}]==`);
      socketMap[socket.id] = {
        'userKey': data['userKey'],
        'roomKey': data['roomKey'],
        'userName': data['userName']
      }
      socket.join(data['roomKey']);
      console.log(socketMap);
      socket.to(socketMap[socket.id]['roomKey']).emit('userJoin', { 'userKey': data['userKey'], 'userName': data['userName'] });
    });
    socket.on('offer', (data) => {
      console.log('=========')
      console.log('offer');
      socket.to(socketMap[socket.id]['roomKey']).emit('offer', data);
    });
    socket.on('answer', (data) => {
      console.log('=========')
      console.log('answer');
      console.log(data);
      socket.to(socketMap[socket.id]['roomKey']).emit('answer', data);
    });
    socket.on('ice', (data) => {
      console.log('=========')
      console.log('ice');
      console.log(data);
      socket.to(socketMap[socket.id]['roomKey']).emit('ice', data);
    });
    // 오디오 on / off
    socket.on('audio', (data) => {
      socket.to(socketMap[socket.id]['roomKey']).emit('audio', data);
    });
    // 비디오 on / off
    socket.on('video', (data) => {
      socket.to(socketMap[socket.id]['roomKey']).emit('video', data);
    });
    socket.on('disconnect', (data) => {
      if (socketMap[socket.id] != null) {
        console.log(`==== ${socketMap[socket.id]['userKey']} disconnected ====`);
        socket.to(socketMap[socket.id]['roomKey']).emit('exitUser', socketMap[socket.id]['userKey']);
      }
      delete socketMap[socket.id];
    });

  });
  server.listen(3000,
    '192.168.0.9',
    () => console.log('server open!!\n 192.168.0.9:3000'));
}

server();