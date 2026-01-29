# Map Iteration Guide

Tlang provides a convenient way to iterate over maps using varasa-based loops.

## Syntax

### Iterate with Key and Value

```tl
malli key, value := varasa map {
    // Use key and value here
    fmt.Printf("%s: %d\n", key, value);
}
```

### Iterate with Key Only

```tl
malli key := varasa map {
    // Use key here
    @value int = *(int*)map_get(map, &key);
    fmt.Printf("Key: %s\n", key);
}
```

## Examples

### Basic Iteration

```tl
@scores jatha[string]int = map_create(0, 0);
map_set(scores, &"Alice", &95);
map_set(scores, &"Bob", &87);

// Iterate over all entries
malli name, score := varasa scores {
    fmt.Printf("%s: %d\n", name, score);
}
```

### Filtering During Iteration

```tl
// Find all high scores
malli name, score := varasa scores {
    okavela score >= 90 {
        fmt.Printf("High achiever: %s\n", name);
    }
}
```

### Calculating Aggregates

```tl
@total int = 0;
@count int = 0;

malli name, score := varasa scores {
    total = total + score;
    count = count + 1;
}

@average int = total / count;
fmt.Printf("Average score: %d\n", average);
```

### Modifying Map During Iteration

```tl
// Add bonus points to all scores
malli name, score := varasa scores {
    @newScore int = score + 5;
    map_set(scores, &name, &newScore);
}
```

## How It Works

The varasa loop uses an iterator pattern internally:

1. **`map_iter(map)`** - Creates a `MapIterator` that points to the first entry
2. **`map_next(iterator, &key_ptr, &value_ptr)`** - Gets the next key-value pair
3. The loop continues until `map_next` returns 0 (no more entries)
4. The iterator is automatically freed after the loop

## Performance

- **Time Complexity**: O(n) where n is the number of entries
- **Space Complexity**: O(1) - iterator uses constant space
- Iteration order is not guaranteed (depends on hash table bucket order)

## Limitations

- Currently assumes string keys and int values (will be enhanced for generic types)
- Cannot modify map structure (add/delete keys) during iteration safely
- Iteration order is non-deterministic

## See Also

- [Map Operations](language-reference.md#maps) - Creating and using maps
- [Control Flow](language-reference.md#control-flow) - Other loop constructs
- [Examples](../examples/map_iteration_example.tl) - Working examples
