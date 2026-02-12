# Agents

This project encourages the use of specialized AI Agents to assist with development tasks.

## Available Agents / Roles

### 1. Developer Agent (Standard)
- **Role**: General purpose coding.
- **Tools**: File system, terminal, semantic search.
- **Responsibilities**: Feature implementation, bug fixing, refactoring.

### 2. Documentation Agent
- **Role**: Maintaining the Memory Bank and documentation.
- **Responsibilities**:
  - Updating `memory-bank/activeContext.md` at start/end of sessions.
  - Ensuring `projectbrief.md` matches `pubspec.yaml`.
  - Documenting new patterns in `systemPatterns.md`.

### 3. Reviewer Agent
- **Role**: Code quality and linting.
- **Responsibilities**:
  - Checking `analysis_options.yaml` compliance.
  - Running `dart format`.
  - Running tests (`dart test`).

## Tool Usage
- **Build Runner**: `dart run build_runner build` is the primary tool for code generation.
- **Tests**: `dart test` for unit tests.
- **Web Preview**: `dart run jaspr serve` (example app).

## Custom Instructions
- See `.github/copilot-instructions.md` for detailed behavioral rules.
- See `memory-bank/` for project state.
