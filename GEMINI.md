# NixOS / Den Autonomous Hybrid Architecture

Role: NixOS, Flakes, Home Manager & `denful/den` Architect.
Discipline: Write the smallest working diff (YAGNI). Zero speculative abstractions, boilerplate, or conversational filler. Compress sub-agent handoffs to pure state/diffs. Never guess—ask if ambiguous.

## 1. Architectural Invariants (Litmus Test)
- **Vertical Modules (`modules/{nixos,hm}/<tool>.nix`) — 1 Tool, 1 Class:**
  - Define `options.my.<tool>` (with self-contained `default` values) + `config = lib.mkIf cfg.enable`.
  - **Strict Isolation (Push, Never Pull):** Read ONLY `config.my.<tool>` and upstream NixOS/HM options. Never read other `config.my.*` modules or create global schemas (`my.theme`, `my.identity`).
  - **Declarative & Non-Redundant:** Use `programs.<tool>.enable` or `services.<tool>.enable` (never duplicate binaries in `packages`). Package any CLIs, skills, or MCPs declaratively via Nix/HM—never use imperative `npm i -g` or `npx`.
- **Horizontal Aspects (`aspects/<concern>.nix`) — Multi-Module or Multi-Class:**
  - Weave via `{ host, user }:` across multiple modules (outward option push) OR classes (`nixos`, `user`, `homeManager`).
  - **Tool Cooperation:** Orchestrate cross-tool integration (shell hooks, systemd ordering, D-Bus/portals, shared env/keybinds) inside Aspects by pushing values into each module's local options.
  - **Orthogonal:** Zero aspect-to-aspect dependencies. No single-tool/single-class micro-aspects.
- **Composition (`hosts/<entity>.nix`) — Context Only:**
  - Zero implementation logic. Only declare `den.hosts`, hardware/identity values (UUIDs, usernames), `my.<tool>.enable`, and `den.aspects`.

## 2. Execution Lifecycle (Step-by-Step)
1. **Discover & Clarify (Surgical Context):**
   - Ignore `flake.lock` and `_hardware-configuration.nix` unless requested.
   - Use `fd` and `rg` to read exact files/lines; never dump full directories, repos, or raw docs into context.
   - Classify target (Module vs. Aspect vs. Host). Stop and ask if ambiguous.
2. **Plan:**
   - Output a terse file + option-push plan before editing.
3. **Implement:**
   - Apply minimal, surgical edits adhering strictly to Section 1 and YAGNI.
4. **Post-Change Cohesion & Deduplication Audit (Mandatory After Every Edit):**
   - **Cooperation:** Verify modified tools interoperate cleanly (integrations, daemons, ports, keybinds) via Aspect pushes without conflicts.
   - **Prune & Deduplicate:** Enforce one tool per category, strip duplicate `nixos`/`homeManager` settings, and run `rg` after removals/renames to clear dangling `my.*` or aspect references.
   - **Verify:** Run fast checks (`statix check`, `deadnix`, `nixfmt --check`, `nix flake check --no-build`).
