# Tlang standard library (std)

Standard library packages live under `libs/std/<package>`. Import them with:

```tl
@fmt = #dhimpu("std/fmt");
@math = #dhimpu("std/math");
#dhimpu("std/json");   // alias inferred as "json"
```

## Packages

Implementation is in `src/libs/` (Rust-generated C). This directory is the canonical location for:

- Future `.tl` stubs or re-exports per package (e.g. `libs/std/fmt/mod.tl`)
- Package-level documentation

Available packages: `fmt`, `strings`, `strconv`, `math`, `os`, `io`, `filepath`, `time`, `regexp`, `rand`, `log`, `testing`, `args`, `flag`, `bytes`, `sort`, `json`, `unicode`, `csv`, `xml`, `url`, `neturl`, `bufio`, `benchmark`, `doc`, `reflect`, `crypto`, `hex`, `base64`, `http`, `errors`, `net`, `protobuf`.
