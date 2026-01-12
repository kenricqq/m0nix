# AGENTS.md

## Critical Rules

- **ONLY use `bun`** - never npm/yarn
- **NEVER run dev/build commands** (`bun dev`, `bun build`)
- **Quality Control**: After implementing new code (or changing existing behavior), call the `quality_control` subagent to perform quality checks. If it returns **FAIL**, address the required fixes and re-run until **PASS**.

## Commands

### Root Commands

- Type check all: `bun run check:all`
- Format all: `bun run format:all`

### Package-Specific Commands

After making changes in a specific package, run its check script:

| Package           | Check Command          | Format Command          |
| ----------------- | ---------------------- | ----------------------- |
| `apps/cli`        | `bun run check:cli`    | `bun run format:cli`    |
| `apps/web`        | `bun run check:web`    | `bun run format:web`    |
| `packages/shared` | `bun run check:shared` | `bun run format:shared` |

## Code Style

- **Runtime**: Bun only. No Node.js, npm, pnpm, vite, dotenv.
- **TypeScript**: Strict mode enabled. ESNext target.
- **NeverThrow**: Model recoverable failures with `Result<T, E>` / `ResultAsync<T, E>`. Prefer chaining (`map`, `mapErr`, `andThen`) and consuming results explicitly (`match` or `unwrapOr`). Avoid “expected” throws.
- **Imports**: External packages first, then local. Use `.ts` extensions for local imports.
- **Bun APIs**: Prefer `Bun.file`, `Bun.serve`, `bun:sqlite`, `Bun.$` over Node equivalents.
- **Testing**: Use `bun:test` with `import { test, expect } from "bun:test"`.

## Error Handling (NeverThrow)

- **No exceptions for expected errors**: represent recoverable failure as `Err` (typed domain error), success as `Ok`.
- **Localize exceptions**: when calling 3rd-party code that throws, wrap it and convert to `Result` / `ResultAsync` so exceptions don’t leak across the codebase.
- **Sync**: return `Result<T, E>` and use `ok(...)` / `err(...)`.
- **Async**: return `ResultAsync<T, E>` for async workflows so you can keep chaining without `await` in the middle.
- **Composition**:
  - Use `andThen` for sequencing steps that can fail.
  - Use `map` for pure transforms on success values.
  - Use `mapErr` to normalize error types.
- **Consumption is required**: every `Result` must be handled with `match(...)`, `unwrapOr(...)`, or an equivalent explicit consumption point (avoid “floating” results).
- **Only throw for truly unexpected/irrecoverable conditions** (programmer errors, invariants) — not for validation, IO, or business-rule failures.

## btca

When the user says "use btca", use btca before you answer the question. It will give you up to date information about the technology.

Run:

- bun cli ask -t <tech> -q "<question>"

Available <tech>: svelte, tailwindcss, runed, neverthrow, motion 
