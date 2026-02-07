// Test concurrency syntax: channels, spawn, WaitGroup
// Channels: ch <- value (send), @x = <- ch (receive), sunyam(ch) (close)
// Spawn: tlang #name(args);
// WaitGroup: @wg WaitGroup; wg.Add(n); wg.Done(); wg.Wait();

@fmt = #dhimpu("std/fmt");

#worker(n int) {
    fmt.Printf("worker got %d\n", n);
}

#workerWithDone(n int, wg WaitGroup) {
    fmt.Printf("worker %d\n", n);
    wg.Done();
}

#prarambham() {
    // Unbuffered channel
    @ch channel[int];
    ch <- 42;
    @x int = <- ch;
    fmt.Printf("received %d\n", x);
    sunyam(ch);

    // Buffered channel
    @ch2 channel[int] = 10;
    ch2 <- 1;
    ch2 <- 2;
    @a int = <- ch2;
    @b int = <- ch2;
    fmt.Printf("received %d %d\n", a, b);
    sunyam(ch2);

    // Spawn
    tlang #worker(99);

    // WaitGroup: wait until N tasks finish
    @wg WaitGroup;
    wg.Add(2);
    tlang #workerWithDone(1, wg);
    tlang #workerWithDone(2, wg);
    wg.Wait();
    fmt.Printf("done\n");
}
