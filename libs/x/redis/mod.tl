// Redis client - Tlang-only implementation using std/net and std/strings.
// Speaks Redis RESP over TCP. No C bindings; use from apps via #dhimpu("libs/x/redis").
//
// Import: @redis = #dhimpu("libs/x/redis");
// Depends: std/net, std/strings, std/fmt, std/strconv

@net = #dhimpu("std/net");
@strings = #dhimpu("std/strings");
@fmt = #dhimpu("std/fmt");
@strconv = #dhimpu("std/strconv");

// DefaultRedisPort is the default Redis server port.
#DefaultRedisPort() int {
    mallinchu 6379;
}

// Init initializes the network layer (call once before Connect). Call Cleanup when done.
#Init() {
    net.Init();
}

// Cleanup shuts down the network layer.
#Cleanup() {
    net.Cleanup();
}

// Connect opens a TCP connection to Redis at host:port. Returns socket fd or -1 on error.
#Connect(host string, port int) int {
    mallinchu net.Dial(host, port);
}

// Close closes the Redis connection socket.
#Close(sockfd int) {
    net.Close(sockfd);
}

// BuildCommand builds a RESP array from command name and arguments (e.g. ["PING"], ["GET", "key"]).
#BuildCommand(args []string) string {
    @n int = len(args);
    @head string = fmt.Sprintf("*%d\r\n", n);
    @!out string = head;
    @!i int = 0;
    malli i < n {
        @arg string = args[i];
        @part string = fmt.Sprintf("$%d\r\n%s\r\n", len(arg), arg);
        out = out + part;
        i = i + 1;
    }
    mallinchu out;
}

// SendCommand sends a RESP command (from BuildCommand) over the connection.
#SendCommand(sockfd int, cmd string) int {
    mallinchu net.Send(sockfd, cmd, len(cmd));
}

// ParseReply interprets a RESP reply (null-terminated string). Returns payload for +, -, $, : or empty on error.
#ParseReply(resp string) string {
    okavela resp == sunyam || len(resp) == 0 {
        mallinchu "";
    }
    @first int = strings.Index(resp, "\r\n");
    okavela first < 0 {
        mallinchu "";
    }
    okavela strings.HasPrefix(resp, "+") {
        mallinchu strings.Substring(resp, 1, first);
    }
    okavela strings.HasPrefix(resp, "-") {
        mallinchu strings.Substring(resp, 1, first);
    }
    okavela strings.HasPrefix(resp, ":") {
        mallinchu strings.Substring(resp, 1, first);
    }
    okavela strings.HasPrefix(resp, "$") {
        @lenStr string = strings.Substring(resp, 1, first);
        @bulkLen int = strconv.Atoi(lenStr);
        okavela bulkLen < 0 {
            mallinchu "";
        }
        @start int = first + 2;
        @end int = start + bulkLen;
        okavela end > len(resp) {
            end = len(resp);
        }
        mallinchu strings.Substring(resp, start, end);
    }
    mallinchu "";
}

// Command sends a command, reads the reply into an internal buffer, parses and returns the payload.
#Command(sockfd int, args []string) string {
    @cmd string = BuildCommand(args);
    @sent int = SendCommand(sockfd, cmd);
    okavela sent < 0 {
        mallinchu "";
    }
    @buf [4096] char;
    @n int = net.Recv(sockfd, buf, 4096);
    okavela n <= 0 {
        mallinchu "";
    }
    okavela n >= 4096 {
        n = 4095;
    }
    buf[n] = '\0';
    mallinchu ParseReply(buf);
}
