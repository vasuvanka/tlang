// Example: test fixtures (setup/teardown) and shared test data
// Run with: tlang compile test_fixtures_example.tl && gcc -o out output.c -lm -lssl -lcrypto && ./out

@fmt = #dhimpu("std/fmt");
@testing = #dhimpu("std/testing");

// Shared fixture state (simulated - use globals or a struct in real tests)
@!fixture_counter int = 0;

#setupFixture() {
    fixture_counter = 0;
    fmt.Printf("    [setup] counter reset\n");
}

#teardownFixture() {
    fmt.Printf("    [teardown] counter was %d\n", fixture_counter);
}

#testWithFixture() {
    testing.Assert(fixture_counter == 0, "setup should have reset counter");
    fixture_counter = fixture_counter + 1;
    testing.AssertEqual(1, fixture_counter, "increment in test");
}

#testWithFixtureAgain() {
    testing.Assert(fixture_counter == 0, "setup runs before each test");
    fixture_counter = 99;
    testing.AssertEqual(99, fixture_counter, "test can use fixture state");
}

#prarambham() {
    fmt.Printf("=== Test fixtures example ===\n\n");
    testing.RegisterSetup(setupFixture);
    testing.RegisterTeardown(teardownFixture);
    testing.Run("testWithFixture", testWithFixture);
    testing.Run("testWithFixtureAgain", testWithFixtureAgain);
    testing.Summary();
}
