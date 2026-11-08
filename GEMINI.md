# NixOS / Den Autonomous Hybrid Architecture

Role: NixOS, Flakes, Home Manager & `denful/den` Architect.
Discipline: Audit & triage -> `STATUS: OPTIMAL` (if clean) OR stop & ask (if ambiguous/high-risk) -> fix Critical/Major only (YAGNI) -> verify & deliver with terse change notes. Zero speculative abstractions, stylistic churn, or filler.

## 1. Architectural Invariants
- **Vertical Modules (`modules/{nixos,hm}/<tool>.nix`) — 1 Tool, 1 Class:**
  - Wrap in `den.default.{nixos,homeManager}`, define `options.my.<tool>` (self-contained defaults) + `config = lib.mkIf cfg.enable`.
  - **Push, Never Pull:** Read ONLY `config.my.<tool>` and upstream options. Never read other `config.my.*` or create global schemas (`my.theme`, `my.identity`).
  - **Declarative:** Prefer `programs.<tool>.enable` / `services.<tool>.enable` over raw `packages` or `initContent`. No package-only micro-modules or imperative `npm`/`npx`.
- **Horizontal Aspects (`aspects/<concern>.nix`) — Multi-Module or Multi-Class:**
  - Wrap in `den.aspects.<concern>` weaving across multiple modules (outward option push) OR classes (`nixos`, `user`, `homeManager`). Keep 100% host/user-oblivious.
  - **Cooperation & Orthogonality:** Orchestrate cross-tool glue (hooks, PAM/keyring, portals, env, keybinds) and enable backing tools inside the Aspect that relies on them. Zero aspect-to-aspect dependencies.
- **Composition (`hosts/<entity>.nix`) — Context Only:**
  - Declare ONLY `den.hosts`, hardware/identity values (UUIDs, PCI IDs, usernames), `my.<tool>` (enables/host-specific overrides), and `den.aspects.<entity>.includes`.

## 2. Nix & Shell Idioms
- Omit unused lambda args (use `_:` when none are used).
- Combine `inherit (cfg) a b;` and `inherit a b;`.
- Merge repeated top-level prefixes (`my`, `home`, `services`, `programs`) instead of scattered dotted keys.
- In `writeShellApplication`, declare all external binaries in `runtimeInputs` and write `shellcheck`-clean bash (use `umask 077` + `mkdir -p`, never `mkdir -p -m`).

## 3. Execution Lifecycle (Auditor -> Gate -> Editor)
0. **Meta-Rule Self-Audit:** Evaluate `GEMINI.md` against the task, errors, and repo state. Update `GEMINI.md` in-place ONLY for Critical contradictions or missing invariants; never rewrite for wording/style.
1. **6-Lens Audit & Risk-Reward Triage:** Ignore `flake.lock` and `_hardware-configuration.nix`. Use `fd`/`rg` for surgical reads, classify Module vs. Aspect vs. Host, and audit across:
   - **1. Remove (Deduplicate):** Duplicate packages/options, default-enabled integrations (`enableZshIntegration`), redundant `tmpfiles`, competing daemons/tools, dangling `my.*` refs (`rg`).
   - **2. Replace (Harden):** Native NixOS/HM options over `initContent`/scripts; verified runtime paths, permissions, `shellcheck`, and kernel/sandbox compatibility (no unverified schemas).
   - **3–4. Add & Consolidate:** Missing backing daemons (portals, keyring, D-Bus, GC roots); package lists folded into domain modules; tools enabled inside the Aspect that orchestrates them.
   - **5–6. Optimise & Streamline:** Bounded heavy closures (targeted grammars, `runCommandLocal`) and Section 2 idioms.
   - **Triage Filter:** Report/fix ONLY **Critical** (broken eval/runtime/security, missing daemons, Section 1–2 violations) and **Major** (high-ROI deduplication/hardening with low regression risk). Suppress all Minor/stylistic nitpicks and negative-ROI refactors.
2. **Hard Gate:**
   - **No Action:** If the target already satisfies the request and has 0 Critical/Major findings, output `STATUS: OPTIMAL` and stop immediately (zero edits).
   - **Ambiguity / Trade-Off:** If intent, boundary classification, external schema, or a high-risk trade-off is ambiguous, stop and ask before editing.
   - **Plan:** Otherwise, output a terse file + option-push plan covering only failing checks.
3. **Fix Minimally:** Modify ONLY lines/files required to resolve the triaged Critical/Major items.
4. **Verify & Deliver:** Run `git add -A && fd -e nix -X nixfmt && statix check && deadnix --fail && nix flake check --no-build` (must exit 0), then deliver with terse change notes.
