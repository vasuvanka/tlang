// Redis client example - uses libs/x/redis (Tlang-only, std/net + std/strings)

@fmt = #dhimpu("std/fmt");
@redis = #dhimpu("libs/x/redis");

#prarambham() {
    fmt.Printf("=== Redis client example (libs/x/redis) ===\n\n");
    redis.Init();
    @sockfd int = redis.Connect("127.0.0.1", redis.DefaultRedisPort());
    okavela sockfd >= 0 {
        @args []string = {"PING"};
        @reply string = redis.Command(sockfd, args);
        fmt.Printf("PING -> %s\n", reply);
        redis.Close(sockfd);
    } lekapothe {
        fmt.Printf("Could not connect to Redis at 127.0.0.1:6379 (is Redis running?)\n");
    }
    redis.Cleanup();
    fmt.Printf("\nDone.\n");
}
