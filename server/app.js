const express = require('express');
const bodyParser = require('body-parser');


const socketio = require('socket.io');
const e = require('express');
var app = express();

const router = require('./router');
app.use(router);

app.use(bodyParser.urlencoded({ extended: true }));

app.use(bodyParser.json());


var server = app.listen(3000,()=>{
    console.log('O servidor está em execução')
})


var io = socketio.listen(server)

io.on('connection',function(socket) {

    console.log(`Conexão : SocketId = ${socket.id}`)
    var userName = '';
    
    socket.on('subscribe', function(data) {
        console.log('inscrição acionada')
        var room_data = data
        userName = room_data.userName;
        const roomName = room_data.roomName;
    
        socket.join(`${roomName}`)
        console.log(`Username : ${userName} joined Room Name : ${roomName}`)
        
        io.to(`${roomName}`).emit('newUserToChatRoom', { userName });

    })

    socket.on('unsubscribe',function(data) {
        console.log('cancelamento de inscrição acionado')
        const room_data = data
        const userName = room_data.userName;
        const roomName = room_data.roomName;
    
        console.log(`Username : ${userName} leaved Room Name : ${roomName}`)
        io.to(`${roomName}`).emit('userLeftChatRoom', { userName });
        socket.leave(`${roomName}`)
    })

    socket.on('newMessage',function(data) {
        console.log('nova mensagem acionada')

        const messageData = data
        const messageContent = messageData.messageContent
        const roomName = messageData.roomName

        console.log(`[Room Number ${roomName}] ${userName} : ${messageContent}`)

        const chatData = {
            userName : userName,
            messageContent : messageContent,
            roomName : roomName
        }
        socket.broadcast.to(`${roomName}`).emit('updateChat',JSON.stringify(chatData))
    })

    socket.on('typing',function(roomNumber){
        console.log('digitação acionada')
        socket.broadcast.to(`${roomNumber}`).emit('typing')
    })

    socket.on('stopTyping',function(roomNumber){
        console.log('parar de digitar acionado')
        socket.broadcast.to(`${roomNumber}`).emit('stopTyping')
    })

    socket.on('disconnect', function () {
        console.log("Um dos soquetes desconectado do nosso servidor.")
    });
})

module.exports = server;