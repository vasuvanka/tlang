# sort - Sorting Library

The `sort` library provides array sorting functions.

## Functions

**`sort.Ints(arr, len)`** - Sort integer array in place

- `arr`: Integer array (pointer)
- `len`: Array length
- Sorts array in ascending order

**Example:**
```tl
@arr[5] int = {3, 1, 4, 1, 5};
sort.Ints(arr, 5);
// arr is now {1, 1, 3, 4, 5}
```

**`sort.Float64s(arr, len)`** - Sort float array in place

- `arr`: Float array (pointer)
- `len`: Array length
- Sorts array in ascending order

**Example:**
```tl
@arr[5] float = {3.1, 1.5, 4.2, 1.1, 5.0};
sort.Float64s(arr, 5);
// arr is now {1.1, 1.5, 3.1, 4.2, 5.0}
```

**`sort.Strings(arr, len)`** - Sort string array in place

- `arr`: String array (pointer)
- `len`: Array length
- Sorts array in ascending order (lexicographic)

**Example:**
```tl
@arr[3] string = {"cherry", "apple", "banana"};
sort.Strings(arr, 3);
// arr is now {"apple", "banana", "cherry"}
```

## Notes

- Arrays are sorted in place (modified directly)
- Sorting is in ascending order
- Works with Tlang arrays

## See Also

- [Language Reference](../language-reference.md)
