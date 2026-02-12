# GitHub Copilot Instructions

You are an expert AI programming assistant working on the `jaspr_localizations` project.

## Memory Bank
This project uses a **Memory Bank** system to maintain context across sessions. 
- **CRITICAL**: You MUST read the files in the `memory-bank/` directory at the start of every session to understand the project state.
- **Structure**:
  - `projectbrief.md`: Core requirements and goals.
  - `productContext.md`: User experience and problem domain.
  - `systemPatterns.md`: Architecture and design patterns.
  - `techContext.md`: Technologies and constraints.
  - `activeContext.md`: Current focus and recent changes. (Update this file frequently!)
  - `progress.md`: What works and what's left.

## Project specifics
- **Framework**: This is a **Jaspr** project (Dart web framework), NOT Flutter. avoid using `package:flutter` widgets (like `StatelessWidget`, `MaterialApp`) unless explicitly working on a bridge or compat layer. Use `Component`, `StatelessComponent`, `InheritedComponent` from `package:jaspr`.
- **Localization**:
  - We use `.arb` files for translations.
  - We use `build_runner` to generate code.
  - Generated code usually resides in `lib/generated/`.
  - The main entry point is typically `JasprLocalizations`.

## Coding Standards
- **Dart**: Follow strict linting rules (verify with `analysis_options.yaml`).
- **Async**: Use `Future` and `async/await` properly.
- **Files**: Prefer absolute paths or workspace-relative paths in documentation.

## Workflow
1.  **Read Context**: Check `activeContext.md` and `active_task.md` (if exists).
2.  **Plan**: If a task is complex, outline your plan first.
3.  **Update Memory Bank**: If you make significant architecture changes or complete a major task, update the relevant Memory Bank files (especially `activeContext.md` and `progress.md`).

## Tools
- Use the available MCP tools for file operations and searches.
- Use `dart_format` to format code if needed.
