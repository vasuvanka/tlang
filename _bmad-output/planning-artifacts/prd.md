---
stepsCompleted: ['step-01-init', 'step-02-discovery', 'step-03-success', 'step-04-journeys', 'step-05-domain', 'step-06-innovation', 'step-07-project-type', 'step-08-scoping', 'step-09-functional', 'step-10-nonfunctional', 'step-11-polish']
classification:
  projectType: developer_tool
  domain: general
  complexity: medium
  projectContext: brownfield
inputDocuments:
  - docs/README.md
  - docs/language-reference.md
  - docs/getting-started.md
  - docs/REVIEW_AND_ROADMAP.md
  - docs/manifest.md
  - docs/build-system.md
  - examples/args_example.tl
  - examples/arithmetic.tl
  - examples/array_example.tl
  - examples/assignment_error.tl
  - examples/base64_example.tl
  - examples/benchmark_example.tl
  - examples/borrow_checker_example.tl
  - examples/bufio_example.tl
  - examples/comments.tl
  - examples/const_example.tl
  - examples/crypto_advanced_example.tl
  - examples/crypto_encryption_example.tl
  - examples/crypto_phase3_example.tl
  - examples/crypto_publickey_example.tl
  - examples/csv_example.tl
  - examples/default_values_example.tl
  - examples/doc_example.tl
  - examples/error_example.tl
  - examples/error_handling_comprehensive.tl
  - examples/error_helpers_example.tl
  - examples/factorial.tl
  - examples/filepath_example.tl
  - examples/flag_example.tl
  - examples/hello.tl
  - examples/hex_example.tl
  - examples/http_advanced_example.tl
  - examples/http_client_example.tl
  - examples/http_server_advanced_example.tl
  - examples/http_server_example.tl
  - examples/http_server_routing_example.tl
  - examples/https_client_example.tl
  - examples/immutable_example.tl
  - examples/interface_example.tl
  - examples/interface_polymorphism_example.tl
  - examples/io_example.tl
  - examples/json_advanced_example.tl
  - examples/json_auto_example.tl
  - examples/json_map_example.tl
  - examples/json_map_unmarshal_example.tl
  - examples/json_struct_tags_example.tl
  - examples/json_struct_unmarshal_example.tl
  - examples/json_unmarshal_example.tl
  - examples/json_validation_example.tl
  - examples/log_example.tl
  - examples/loops.tl
  - examples/main_example.tl
  - examples/map_example.tl
  - examples/map_iteration_example.tl
  - examples/map_loop_guide.tl
  - examples/map_operations_example.tl
  - examples/mutable_comprehensive_example.tl
  - examples/mutable_example.tl
  - examples/multiple_return_values_example.tl
  - examples/net_example.tl
  - examples/neturl_example.tl
  - examples/package_alias_example.tl
  - examples/package_example.tl
  - examples/package_import_example.tl
  - examples/package_visibility_example.tl
  - examples/protobuf_example.tl
  - examples/protobuf_struct_example.tl
  - examples/rand_example.tl
  - examples/real-world-examples/01_rest_api_server.tl
  - examples/real-world-examples/02_file_processor.tl
  - examples/real-world-examples/03_data_pipeline.tl
  - examples/real-world-examples/04_cli_tool.tl
  - examples/real-world-examples/05_config_manager.tl
  - examples/real-world-examples/json_serialization_demo.tl
  - examples/real-world-examples/README.md
  - examples/redeclaration_error.tl
  - examples/reflect_example.tl
  - examples/regexp_example.tl
  - examples/slice_example.tl
  - examples/stdlib_example.tl
  - examples/struct_example.tl
  - examples/test_all_libs.tl
  - examples/test_comments.tl
  - examples/test_example.tl
  - examples/test_filepath.tl
  - examples/test_fmt.tl
  - examples/test_io.tl
  - examples/test_json.tl
  - examples/test_math.tl
  - examples/test_os.tl
  - examples/test_strconv.tl
  - examples/test_strings.tl
  - examples/test_time.tl
  - examples/type_conversion_example.tl
  - examples/type_inference.tl
  - examples/unicode_example.tl
  - examples/url_example.tl
  - examples/utils.tl
  - examples/xml_example.tl
briefCount: 0
researchCount: 0
brainstormingCount: 0
projectDocsCount: 6
examplesCount: 92
workflowType: 'prd'
---

# Product Requirements Document - tlang

**Author:** Vasu  
**Date:** 2026-01-29

## Executive Summary

Tlang is a general-purpose programming language that compiles to C, uses Telugu keywords, and targets Telugu-speaking learners and developers building servers and system tools. Differentiators: Telugu-first accessibility for first-time programmers; small binaries and fast compilation for servers and a future path to IoT/drones; strong documentation and 90+ examples. Success = adoption, ease of building real tools, and "easy to write" plus "good docs."

## Success Criteria

### User Success

- **Primary users:** Students and developers who know Telugu; low barrier to entry.
- **"Aha" moment:** Writing code feels easy and documentation answers their questions.
- **Measurable:** New users can write and run a first program quickly; common tasks are doable using docs alone (no prior Tlang experience).

### Business Success

- **Focus:** Adoption and ease of building real tools (servers, system tools, scripts).
- **"This is working":** Developers adopt Tlang and use it to build tools; no specific numeric targets—success is adoption and tool-building in practice.

### Technical Success

- **Deployment:** Light enough to run on IoT, drones, and other microcontrollers.
- **Runtime:** Small binary size and fast execution.
- **MVP must-haves:** Fast compilation, small binaries, core language features, and strong documentation.
- **Later:** Generics, concurrency, advanced optimizations (as in current roadmap).

### Measurable Outcomes

- Fast compilation (relative to today; target TBD).
- Small output binaries suitable for constrained devices.
- Documentation supports "easy to write" and "good docs" (coverage, clarity, examples).
- Language and tooling sufficient for servers and system tools (MVP).

## Product Scope

### MVP - Minimum Viable Product

- Developer adoption: people can and do choose Tlang for real work.
- Ability to build **servers** and **system tools** with current or near-term features.
- Fast compilation, low binary size, basic language features, good documentation (as above).

### Growth (Post-MVP)

- **Competitive position:** Directly comparable to Go and Rust for relevant use cases (e.g. servers, tools, small services).
- Features and ecosystem that justify "serious" use, not "toy" language.

### Vision (2–3 years)

- **Ecosystem:** "Local-made" IoT, drones, and servers—Tlang as a practical choice in regional/local and embedded contexts.
- **Use cases:** Embedded (IoT, drones), servers, system tools, and developer tooling.

## User Journeys

### User type 1: Student (Telugu-speaking, learning to code)

**Opening:** Meera is in high school, knows Telugu and some English. She wants to learn programming but finds English-heavy languages and docs intimidating. She hears about Tlang.

**Rising action:** She installs Tlang (install guide in Telugu or simple English), opens the getting-started doc, and writes her first `#prarambham()` with `fmt.Printf`. She gets "Hello, World!" quickly. She tries loops and variables; the Telugu keywords (`okavela`, `malli`, `@`) make the logic easier to read. When stuck, she finds examples and doc sections that match what she's trying to do.

**Climax:** She completes a small script (e.g. arithmetic or a list) and runs it. She feels she "can actually program" without fighting the language.

**Resolution:** She uses Tlang for assignments and small projects. She recommends it to friends. **Reveals:** onboarding, first-run experience, docs + examples for learners, Telugu-friendly content.

---

### User type 2: Developer building a server or system tool

**Opening:** Ravi needs to build a small REST API or a CLI for his team. He knows Go/Rust but wants something that compiles to a small binary and is easy to deploy. He discovers Tlang.

**Rising action:** He reads the language reference and the HTTP/server examples. He gets a minimal server running, then adds routes and JSON. He uses `dhimpu` and packages. Build is fast; binary size is small. He hits a bug or missing feature and checks docs/examples or the repo.

**Climax:** He deploys the service (or ships the CLI) and it runs reliably with low resource use. His team adopts it.

**Resolution:** He keeps using Tlang for internal tools and small services. **Reveals:** server/CLI workflow, package system, build size/speed, docs for "building real things."

---

### User type 3: IoT / embedded developer (drones, microcontrollers)

**Opening:** Priya is building a drone controller or an IoT device. She needs a language that can target constrained devices: small binaries, predictable performance, and a toolchain that fits embedded workflows.

**Rising action:** She evaluates Tlang for "light enough for IoT." She checks binary size and compile speed, tries a minimal program, and looks for (or imagines) cross-compilation and target support. She cares about no heavy runtime and clear control over memory/execution.

**Climax:** She successfully compiles a small Tlang program and sees it fit and run on her target (or a close proxy). She sees a path to "local-made" IoT/drone software in Tlang.

**Resolution:** She plans to use Tlang for firmware or companion tools. **Reveals:** binary size, compile speed, future embedded/IoT support, documentation for constrained targets.

---

### User type 4: Educator introducing Tlang

**Opening:** A teacher wants to introduce programming in a Telugu-friendly way. They need something students can install easily, with clear steps and materials they can hand out.

**Rising action:** They use the install guide and "Getting started" to prepare a one-hour session. They use official examples and docs so students can continue at home. They might add 1–2 of their own examples.

**Climax:** The class writes and runs their first program; most succeed. Students leave with a link to docs and examples.

**Resolution:** Tlang becomes an option for "first language" in their curriculum. **Reveals:** install experience, single-session lesson path, printable/sharable docs and examples.

---

### Journey Requirements Summary

| Journey | Capabilities / requirements |
|--------|-----------------------------|
| Student (Meera) | Easy install; first program in minutes; Telugu keywords; docs + examples for learners; "easy to write" feel. |
| Developer (Ravi) | Servers and CLIs; packages; fast build; small binary; docs for real-world apps. |
| IoT/embedded (Priya) | Small binary; fast compile; path to IoT/drones; docs (and later toolchain) for constrained targets. |
| Educator | Clear install; lesson-ready getting started; stable docs and examples for classroom use. |

## Domain-Specific Requirements

- **Compliance & regulatory:** None beyond standard OSS (licenses, attribution). No HIPAA, PCI, or domain-specific certifications.
- **Technical constraints:** Correctness and security of generated C; build reproducibility; binary size and speed (per success criteria); compatibility with common C toolchains and future embedded/IoT targets.
- **Integration:** C compiler (gcc/clang), standard environments; later: IDEs, debuggers, cross-compilation.
- **Risk mitigations:** Incorrect codegen or poor docs undermine "easy to write" and "good docs"; mitigated by tests, examples, and clear documentation.

## Innovation & Novel Patterns

### Detected Innovation Areas

- **Telugu-first general-purpose language** — Accessibility and first-language programming for Telugu-speaking learners; distinct from English-dominant mainstream languages.
- **"Local-made" ecosystem** — Positioning for regional IoT, drones, and servers; small binary and C backend as enabler for embedded and constrained devices.
- **Language and toolchain design** — Full language plus compiler/tooling (DSL / new paradigm for audience and deployment targets).

### Market Context & Competitive Landscape

- No mainstream general-purpose language with Telugu keywords; differentiation = audience (learners, regional) and deployment (small binaries, path to embedded).
- Competes with Go/Rust on servers/tools and with C/embedded toolchains on IoT; strength = language design + who it serves + where it runs.

### Validation Approach

- Adoption by students and developers; ability to build real servers and system tools; eventual use on IoT/drones; docs and examples that support "easy to write" and "good docs."

### Risk Mitigation

- If Telugu-first adoption is slow, small binaries and tooling still support servers and embedded use.
- If embedded lags, servers and CLIs remain the core value.

## Developer Tool Specific Requirements

### Project-Type Overview

Tlang is a developer tool (programming language, compiler, tooling). It compiles to C, uses Telugu keywords, and targets learners (Telugu-speaking), server/CLI developers, and (later) IoT/embedded. Delivered as compiler, build system, standard library, docs, and examples.

### Technical Architecture Considerations

- **Language matrix:** Single language (Tlang); output is C. Targets: today desktop/server (Linux, Windows, macOS via C compiler); vision includes embedded/IoT/drones (same C backend, future cross-compilation).
- **Installation methods:** Install scripts (install.sh, install.ps1), cargo build from source; optional global install. Prerequisites: Rust (to build compiler), C compiler (gcc/clang/MinGW).
- **API surface:** Language syntax and standard library (fmt, strings, json, http, io, crypto, etc.). Package surface: dhimpu imports, public functions/types; config.toml for projects and dependencies.
- **Code examples:** 90+ examples (language features, libraries, 5 real-world-style apps). Examples are the primary "API documentation" for many features.
- **Migration guide:** Porting from Go documented (tlang port, porting guide); keywords and patterns mapped. No formal migration from other languages yet.

### Implementation Considerations

- **IDE integration:** LSP server for editor support; formatter and linter in-tree. Future: deeper IDE/debugger integration.
- **Package management:** config.toml, local and remote deps, incremental builds; no external package registry yet.
- **Documentation:** Central for "easy to write" and "good docs"; must stay accurate and example-driven (per success criteria).

## Project Scoping & Phased Development

### MVP Strategy & Philosophy

- **MVP approach:** Experience MVP — smallest set that makes Tlang "useful": developers can adopt it and build real servers and system tools; students can write and run a first program with good docs.
- **Resource context:** Single maintainer / small team; scope stays within "fast compilation, small binaries, core language features, good documentation."

### MVP Feature Set (Phase 1)

**Core user journeys supported:** Student (first program, docs, examples); Developer (servers, CLIs, packages, build, docs).

**Must-have capabilities:** Core language (types, control flow, functions, structs, maps, interfaces, error type); fast compilation and small output binaries; standard library sufficient for servers and system tools (fmt, strings, json, http, io, etc.); package system (dhimpu, config.toml, dependency resolution); documentation and 90+ examples; install and run (install scripts, tlang run/compile, build system); LSP, formatter, linter.

**Out of MVP (or minimal first):** Generics, concurrency (roadmap); official embedded/IoT toolchain (vision); competing feature-for-feature with Go/Rust (growth goal).

### Post-MVP Features

**Phase 2 (Growth):** Generics, concurrency; deeper IDE/debugger integration; binary size and compile-speed improvements; more real-world examples and migration guides.

**Phase 3 (Expansion / Vision):** Embedded/IoT/drones (cross-compilation, targets, docs); "local-made" ecosystem; optional package registry and broader ecosystem.

### Risk Mitigation Strategy

- **Technical:** Correctness and codegen quality; mitigated by tests and examples. Small binary/speed: measure and iterate; C backend keeps options open for embedded.
- **Market:** Adoption risk; mitigated by "easy to write" and "good docs," student and developer journeys, and examples.
- **Resource:** If capacity is limited, keep MVP to current core + docs/examples; defer generics/concurrency and embedded toolchain to Phase 2/3.

## Functional Requirements

### Language & Compilation

- FR1: A developer can write Tlang source (Telugu keywords, types, control flow, functions, structs, maps, interfaces).
- FR2: A developer can compile Tlang source to C and then to a binary (single command or toolchain).
- FR3: A developer can get compilation errors that point to source location and message.
- FR4: A developer can produce binaries that run on the target platform (desktop/server today; embedded/IoT in vision).
- FR5: A developer can use the language to express servers, CLIs, and system tools (per MVP scope).

### Package & Build

- FR6: A developer can declare dependencies and entry point via config (e.g. config.toml).
- FR7: A developer can import packages with dhimpu (with optional alias).
- FR8: A developer can build a project with dependency resolution and incremental build behavior.
- FR9: A developer can produce a single static binary for distribution (per build system).

### Documentation & Learning

- FR10: A new user can find getting-started documentation (install, first program, run/compile).
- FR11: A user can find language reference documentation (syntax, types, keywords).
- FR12: A user can find library/API documentation for standard library packages.
- FR13: A user can discover and use code examples for language features and libraries.
- FR14: A student or educator can use docs and examples to teach or learn Tlang without prior Tlang experience.

### Tooling

- FR15: A developer can use editor support (e.g. LSP) for editing Tlang source.
- FR16: A developer can format Tlang source with a standard formatter.
- FR17: A developer can run a linter to get code-quality and correctness feedback.

### Standard Library & Runtime

- FR18: A developer can use standard library packages (e.g. fmt, strings, json, http, io, crypto, etc.) as specified in docs.
- FR19: A developer can build HTTP servers and clients using the standard library.
- FR20: A developer can handle errors using the error type and patterns documented (e.g. errors.New, checks).

### Installation & Onboarding

- FR21: A user can install the Tlang compiler/toolchain via documented method (e.g. install scripts, build from source).
- FR22: A user can run a Tlang program (e.g. tlang run or compile-then-run).
- FR23: A user can compile a Tlang program to a named executable (e.g. tlang compile).

### Porting & Migration

- FR24: A developer can use tooling or docs to port Go code toward Tlang (e.g. keyword/concept mapping, port workflow).
- FR25: A developer can find migration/porting guidance (e.g. porting guide, examples) for common patterns.

### Examples & Validation

- FR26: A user can run a set of example programs that demonstrate language and library features.
- FR27: A user can use examples as a reference for building servers, CLIs, or system tools (per MVP).

## Non-Functional Requirements

### Performance

- Compilation of typical single-file and multi-file projects completes in a reasonable time (targets to be set; improve over time).
- Generated binaries remain small enough to support deployment on constrained devices and servers (targets to be set; smaller is better for IoT/embedded path).
- Execution speed of generated binaries is acceptable for servers and system tools (no specific latency SLA; optimize where it blocks adoption).

### Security & Correctness

- Generated C code is correct and does not introduce security vulnerabilities that are not present in the source (mitigated by tests and examples).
- Build and dependency resolution do not introduce malicious or unintended code (trust in config and dependencies; no formal threat model for MVP).

### Usability & Accessibility

- Documentation and examples enable a new user (student or developer) to write and run a first program and to complete common tasks without prior Tlang experience.
- Documentation and tooling are usable by Telugu-speaking users (language and terminology support "easy to write" and learning).

### Integration

- The compiler integrates with standard C toolchains (gcc/clang/MinGW) on supported platforms.
- Installation and execution work in standard desktop/server environments (Linux, Windows, macOS) per documented methods.
