# encoding/csv - CSV Processing Library

The `encoding/csv` library provides CSV file reading and writing functions.

## Functions

### Reading CSV

**`csv.Read(filename)`** - Read CSV file

- `filename`: Path to CSV file
- Returns: Newline-separated records, fields separated by `|`
- Format: `field1|field2|field3\nfield1|field2|field3`

**Example:**
```tl
@csvData string = csv.Read("data.csv");
// csvData format: "name|age|city\nJohn|30|NY\nJane|25|LA"
```

### Writing CSV

**`csv.Write(filename, data)`** - Write CSV file

- `filename`: Path to CSV file
- `data`: Newline-separated records, fields separated by `|`
- Returns: Number of bytes written

**Example:**
```tl
@data string = "name|age|city\nJohn|30|NY";
@written int = csv.Write("output.csv", data);
```

### Parsing

**`csv.ParseLine(line)`** - Parse single CSV line

- `line`: CSV line string
- Returns: Fields separated by `|`

**Example:**
```tl
@parsed string = csv.ParseLine("name,age,city");
// Returns: "name|age|city"
```

## CSV Format

- Fields are separated by commas (`,`)
- Records are separated by newlines (`\n`)
- Fields containing commas or quotes should be quoted
- Quoted fields can contain newlines

## Common Patterns

### Read and Process CSV

```tl
@csvData string = csv.Read("data.csv");
// Process records (split by \n)
// Process fields (split by |)
```

### Write CSV Data

```tl
@header string = "name|age|city";
@row1 string = "John|30|NY";
@row2 string = "Jane|25|LA";
@data string = fmt.Sprintf("%s\n%s\n%s", header, row1, row2);
csv.Write("output.csv", data);
```

### Parse CSV Line

```tl
@line string = "John,30,\"New York, NY\"";
@parsed string = csv.ParseLine(line);
// parsed: "John|30|New York, NY"
```

## Notes

- Fields are returned separated by `|` (pipe) for easy parsing
- Records are separated by `\n` (newline)
- Handles quoted fields with commas and newlines
- Maximum 100 fields per line
- Maximum 64KB file size

## See Also

- [io Library](io.md) - File I/O operations
- [Examples](../examples.md) - Code examples
- [Language Reference](../language-reference.md)
