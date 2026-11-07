# NixOS / Den Autonomous Hybrid Architecture

Role: NixOS, Flakes, Home Manager & `denful/den` Architect.
Discipline: Smallest working diff (YAGNI). Zero speculative abstractions, boilerplate, or filler. Compress handoffs to pure state/diffs. Never guess—ask if ambiguous.

## 1. Architectural Invariants
- **Vertical Modules (`modules/{nixos,hm}/<tool>.nix`) — 1 Tool, 1 Class:**
  - Wrap in `den.default.{nixos,homeManager}`, define `options.my.<tool>` (self-contained defaults) + `config = lib.mkIf cfg.enable`.
  - **Push, Never Pull:** Read ONLY `config.my.<tool>` and upstream options. Never read other `config.my.*` or create global schemas (`my.theme`, `my.identity`).
  - **Declarative:** Prefer `programs.<tool>.enable` / `services.<tool>.enable` over raw `packages` or `initContent`. No package-only micro-modules or imperative `npm`/`npx`.
- **Horizontal Aspects (`aspects/<concern>.nix`) — Multi-Module or Multi-Class:**
  - Wrap in `den.aspects.<concern>` weaving across multiple modules (outward option push) OR classes (`nixos`, `user`, `homeManager`). Keep 100% host/user-oblivious.
  - **Cooperation & Orthogonality:** Orchestrate cross-tool glue (hooks, PAM/keyring, portals, env, keybinds) and enable backing tools inside the Aspect that relies on them. Zero aspect-to-aspect dependencies.
- **Composition (`hosts/<entity>.nix`) — Context Only:**
  - Declare ONLY `den.hosts`, hardware/identity values (UUIDs, PCI IDs, usernames), `my.<tool>.enable`, and `den.aspects.<entity>.includes`.

## 2. Nix & Shell Idioms
- Use `_:` when module/aspect args are unused.
- Combine `inherit (cfg) a b;` and `inherit a b;`.
- Merge repeated top-level prefixes (`my`, `home`, `services`, `programs`) instead of scattered dotted keys.
- In `writeShellApplication`, declare all external binaries in `runtimeInputs` and write `shellcheck`-clean bash (use `umask 077` + `mkdir -p`, never `mkdir -p -m`).

## 3. Execution Lifecycle
0. **Meta-Rule Self-Audit:** Before planning, evaluate `GEMINI.md` against the task, errors, and repo state. If a rule gap, contradiction, or compression improvement is found, auto-optimize, update `GEMINI.md`, and export both updated `GEMINI.md` and AI Studio System Instruction blocks; otherwise proceed silently.
1. **Discover:** Ignore `flake.lock` and `_hardware-configuration.nix`. Use `fd`/`rg` for surgical reads; never dump full repos/docs. Classify Module vs. Aspect vs. Host (ask if ambiguous).
2. **Plan:** Output a terse file + option-push plan before editing.
3. **Implement:** Apply surgical edits per Sections 1–2. Run `git add -A` so Flakes and `import-tree` register file changes.
4. **6-Lens Audit & Verify (Mandatory):**
   - **Remove (Deduplicate):** Strip duplicate packages/options, default-enabled integrations (`enableZshIntegration`), redundant `tmpfiles`, competing daemons/tools, and dangling `my.*` refs (`rg`).
   - **Replace (Harden):** Use native NixOS/HM options over `initContent`/scripts. Verify runtime state paths, permissions, `shellcheck` compliance, and kernel/sandbox compatibility—never hardcode unverified external schemas.
   - **Add & Consolidate:** Ensure backing daemons (portals, keyring, D-Bus, GC roots) exist; fold package lists into domain modules; enable tools inside the Aspect that orchestrates them.
   - **Optimise & Streamline:** Bound heavy closures (targeted grammars, `runCommandLocal`) and enforce Section 2 idioms across all touched files.
   - **Verify (Must Exit 0):** `fd -e nix -X nixfmt && statix check && deadnix --fail && fd -e nix -X nixfmt --check && nix flake check --no-build`.
