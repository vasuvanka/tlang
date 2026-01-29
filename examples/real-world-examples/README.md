# Real-World Examples

This directory contains practical, real-world examples demonstrating how to use Tlang for common programming tasks.

## Examples

### 1. REST API Server (`01_rest_api_server.tl`)

A complete REST API server with:
- JSON request/response handling
- HTTP routing (GET, POST)
- In-memory data storage
- Error handling
- Health check endpoint

**Features:**
- `GET /api/users` - List all users
- `POST /api/users` - Create new user
- `GET /health` - Health check

**Usage:**
```bash
tlang run 01_rest_api_server.tl
# Server starts on :8080
# Test with: curl http://localhost:8080/api/users
```

---

### 2. File Processing Tool (`02_file_processor.tl`)

Processes log files and generates statistics:
- Parses log file entries
- Extracts log levels (INFO, WARN, ERROR)
- Calculates statistics
- Generates text reports

**Features:**
- Log file parsing
- Statistics calculation (total, errors, warnings, info)
- Report generation
- Error rate calculation

**Usage:**
```bash
tlang run 02_file_processor.tl
# Creates app.log, processes it, generates report.txt
```

---

### 3. Data Processing Pipeline (`03_data_pipeline.tl`)

Reads CSV data, transforms it, and generates reports:
- CSV file reading and parsing
- Data transformation
- Statistics calculation
- JSON report generation

**Features:**
- CSV parsing
- Product inventory processing
- Sales report generation
- Low stock detection
- JSON output

**Usage:**
```bash
tlang run 03_data_pipeline.tl
# Creates products.csv, processes it, generates report.json
```

---

### 4. CLI Tool (`04_cli_tool.tl`)

A command-line utility with subcommands:
- File counting (lines, words, characters)
- Directory searching
- File information display
- Verbose mode support

**Commands:**
- `count <file>` - Count lines, words, characters
- `search <dir>` - List files in directory
- `info <file>` - Show file information
- `version` - Show version
- `help` - Show help

**Usage:**
```bash
tlang compile 04_cli_tool.tl
./04_cli_tool count README.md
./04_cli_tool search . --verbose
./04_cli_tool info config.json
```

---

### 5. Configuration Manager (`05_config_manager.tl`)

Manages application configuration:
- Load/save JSON configuration files
- Environment variable support
- Configuration merging (file + env)
- Secure API key handling

**Features:**
- JSON configuration file support
- Environment variable overrides
- Configuration validation
- Secure credential masking

**Usage:**
```bash
# Set environment variables
export APP_PORT=3000
export APP_DEBUG=true
export DATABASE_URL=postgresql://localhost:5432/mydb

tlang run 05_config_manager.tl
# Creates config.json, loads from file and environment
```

---

## Running the Examples

### Quick Run (Development)
```bash
tlang run examples/real-world-examples/01_rest_api_server.tl
```

### Compile to Binary
```bash
tlang compile examples/real-world-examples/01_rest_api_server.tl
./01_rest_api_server
```

### Using Build System
```bash
cd examples/real-world-examples
tlang init myapp
# Copy example to src/prarambham.tl
tlang build
```

## What These Examples Demonstrate

1. **Web Development**: REST APIs, JSON handling, HTTP servers
2. **File Processing**: Log analysis, CSV processing, report generation
3. **Data Pipelines**: ETL operations, data transformation
4. **CLI Tools**: Command-line interfaces, argument parsing
5. **Configuration Management**: Settings, environment variables, file I/O

## Key Tlang Features Used

- **Structs**: Data modeling (`nirmanam`)
- **JSON**: Automatic marshaling/unmarshaling
- **HTTP**: Server and client operations
- **File I/O**: Reading and writing files
- **String Processing**: Parsing and manipulation
- **Error Handling**: `okavela err != sunyam` and `errors.New()`
- **Maps**: Key-value storage (`jatha`)
- **Arrays/Slices**: Data collections

## Next Steps

- Modify examples to fit your needs
- Combine patterns from multiple examples
- Add error handling and validation
- Integrate with databases or external APIs
- Add logging and monitoring

## See Also

- [Language Reference](../../docs/language-reference.md)
- [Standard Library](../../docs/standard-library.md)
- [Examples Guide](../../docs/examples.md)
- [Build System](../../docs/build-system.md)
