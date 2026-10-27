# Requirements Specification: Command-Line Interface (`whatnow_cli`)

## 1. Scope of the System

This document establishes the functional and non-functional requirements for the `whatnow` command-line interface (`packages/cli`), which consumes `whatnow_core` and compiles to native AOT executables.

## 2. Functional Requirements

### 2.1 CLI Invocation & Standard Flags

* REQ-CLI-1: Running `whatnow --help` or `whatnow -h` shall print usage instructions to `stdout` and exit with code `0`.
* REQ-CLI-2: Running `whatnow --version` or `whatnow -v` shall print the current CLI version to `stdout` and exit with code `0`.
* REQ-CLI-3: Running `whatnow` with an unrecognised option or malformed flag shall print an error message and usage summary to `stderr` and exit with `EX_USAGE` (`64`).
* REQ-CLI-4: The CLI runner (`runCli`) shall accept injectable `out` and `err` `StringSink` streams to support deterministic in-memory unit and BDD testing.
