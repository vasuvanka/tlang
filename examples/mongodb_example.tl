// MongoDB client example - uses libs/x/mongodb (Tlang-only, std/net + wire protocol)

@fmt = #dhimpu("std/fmt");
@mongodb = #dhimpu("libs/x/mongodb");

#prarambham() {
    fmt.Printf("=== MongoDB client example (libs/x/mongodb) ===\n\n");
    mongodb.Init();
    @sockfd int = mongodb.Connect("127.0.0.1", mongodb.DefaultMongoPort());
    okavela sockfd >= 0 {
        okavela mongodb.Ping(sockfd) == 1 {
            fmt.Printf("Ping OK\n");
        } lekapothe {
            fmt.Printf("Ping failed\n");
        }
        okavela mongodb.IsMaster(sockfd) == 1 {
            fmt.Printf("IsMaster OK\n");
        } lekapothe {
            fmt.Printf("IsMaster failed\n");
        }
        mongodb.Close(sockfd);
    } lekapothe {
        fmt.Printf("Could not connect to MongoDB at 127.0.0.1:27017 (is mongod running?)\n");
    }
    mongodb.Cleanup();
    fmt.Printf("\nDone.\n");
}
