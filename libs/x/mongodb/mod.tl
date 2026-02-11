// MongoDB client - Tlang-only using std/net. Speaks MongoDB Wire Protocol (OP_MSG + BSON).
// No C bindings (no libmongoc). Import: @mongodb = #dhimpu("libs/x/mongodb");
// Depends: std/net

@net = #dhimpu("std/net");

// DefaultMongoPort is the default MongoDB server port.
#DefaultMongoPort() int {
    mallinchu 27017;
}

// Init initializes the network layer (call once before Connect).
#Init() {
    net.Init();
}

// Cleanup shuts down the network layer.
#Cleanup() {
    net.Cleanup();
}

// Connect opens a TCP connection to MongoDB at host:port. Returns socket fd or -1 on error.
#Connect(host string, port int) int {
    mallinchu net.Dial(host, port);
}

// Close closes the connection.
#Close(sockfd int) {
    net.Close(sockfd);
}

// BuildPingMessage writes an OP_MSG ping ({"ping":1}) into buf. Returns number of bytes to send.
// Header 16: length=40, requestID=1, responseTo=0, opcode=2013. Payload: flags=0, kind=0, size=15, BSON 15 bytes.
#BuildPingMessage(buf [256] char) int {
    buf[0] = 40;
    buf[1] = 0;
    buf[2] = 0;
    buf[3] = 0;
    buf[4] = 1;
    buf[5] = 0;
    buf[6] = 0;
    buf[7] = 0;
    buf[8] = 0;
    buf[9] = 0;
    buf[10] = 0;
    buf[11] = 0;
    buf[12] = 221;
    buf[13] = 7;
    buf[14] = 0;
    buf[15] = 0;
    buf[16] = 0;
    buf[17] = 0;
    buf[18] = 0;
    buf[19] = 0;
    buf[20] = 0;
    buf[21] = 15;
    buf[22] = 0;
    buf[23] = 0;
    buf[24] = 0;
    buf[25] = 15;
    buf[26] = 0;
    buf[27] = 0;
    buf[28] = 0;
    buf[29] = 16;
    buf[30] = 112;
    buf[31] = 105;
    buf[32] = 110;
    buf[33] = 103;
    buf[34] = 0;
    buf[35] = 1;
    buf[36] = 0;
    buf[37] = 0;
    buf[38] = 0;
    buf[39] = 0;
    mallinchu 40;
}

// ParsePingReply returns 1 if the reply contains ok:1, else 0. buf should be the received message.
#ParsePingReply(buf [65536] char, n int) int {
    okavela n < 37 {
        mallinchu 0;
    }
    @msgLen int = (buf[0] & 255) + ((buf[1] & 255) << 8) + ((buf[2] & 255) << 16) + ((buf[3] & 255) << 24);
    okavela msgLen < 16 || msgLen > n {
        mallinchu 0;
    }
    @opcode int = (buf[12] & 255) + ((buf[13] & 255) << 8) + ((buf[14] & 255) << 16) + ((buf[15] & 255) << 24);
    okavela opcode != 2013 {
        mallinchu 0;
    }
    @off int = 29;
    okavela off + 8 > n {
        mallinchu 0;
    }
    okavela (buf[off] & 255) != 16 {
        mallinchu 0;
    }
    okavela buf[off + 1] != 111 || buf[off + 2] != 107 || buf[off + 3] != 0 {
        mallinchu 0;
    }
    okavela (buf[off + 4] & 255) != 1 {
        mallinchu 0;
    }
    mallinchu 1;
}

// Ping sends a ping command and returns 1 if server replied ok, else 0.
#Ping(sockfd int) int {
    @sendBuf [256] char;
    @msgLen int = BuildPingMessage(sendBuf);
    @sent int = net.Send(sockfd, sendBuf, msgLen);
    okavela sent != msgLen {
        mallinchu 0;
    }
    @recvBuf [65536] char;
    @n int = net.Recv(sockfd, recvBuf, 65536);
    okavela n <= 0 {
        mallinchu 0;
    }
    mallinchu ParsePingReply(recvBuf, n);
}

// IsMaster sends the isMaster command (MongoDB server info). Returns 1 if ok, 0 otherwise.
#IsMaster(sockfd int) int {
    @sendBuf [512] char;
    @msgLen int = BuildIsMasterMessage(sendBuf);
    okavela msgLen <= 0 {
        mallinchu 0;
    }
    @sent int = net.Send(sockfd, sendBuf, msgLen);
    okavela sent != msgLen {
        mallinchu 0;
    }
    @recvBuf [65536] char;
    @n int = net.Recv(sockfd, recvBuf, 65536);
    okavela n <= 0 {
        mallinchu 0;
    }
    mallinchu ParsePingReply(recvBuf, n);
}

// BuildIsMasterMessage writes OP_MSG with { isMaster: 1 }. Returns 45 bytes.
#BuildIsMasterMessage(buf [512] char) int {
    buf[0] = 45;
    buf[1] = 0;
    buf[2] = 0;
    buf[3] = 0;
    buf[4] = 1;
    buf[5] = 0;
    buf[6] = 0;
    buf[7] = 0;
    buf[8] = 0;
    buf[9] = 0;
    buf[10] = 0;
    buf[11] = 0;
    buf[12] = 221;
    buf[13] = 7;
    buf[14] = 0;
    buf[15] = 0;
    buf[16] = 0;
    buf[17] = 0;
    buf[18] = 0;
    buf[19] = 0;
    buf[20] = 0;
    buf[21] = 20;
    buf[22] = 0;
    buf[23] = 0;
    buf[24] = 0;
    buf[25] = 20;
    buf[26] = 0;
    buf[27] = 0;
    buf[28] = 0;
    buf[29] = 16;
    buf[30] = 105;
    buf[31] = 115;
    buf[32] = 77;
    buf[33] = 97;
    buf[34] = 115;
    buf[35] = 116;
    buf[36] = 101;
    buf[37] = 114;
    buf[38] = 0;
    buf[39] = 1;
    buf[40] = 0;
    buf[41] = 0;
    buf[42] = 0;
    buf[43] = 0;
    mallinchu 45;
}
