# modules/hm/antigravity.nix
# Vertical Module: Google Antigravity CLI (`agy`) tuned for Google AI Pro efficiency
_: {
  den.default.homeManager =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.my.antigravity;
    in
    {
      options.my.antigravity = {
        enable = lib.mkEnableOption "Google Antigravity CLI (agy) tuned for Google AI Pro";

        defaultModel = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Balanced default model ID for daily coding and interactive sessions (`null` uses upstream default without exporting GEMINI_MODEL).";
        };

        highEffortModel = lib.mkOption {
          type = lib.types.str;
          default = "Gemini 4 Argon (High)";
          description = "High-reasoning model ID reserved for complex multi-file architecture (`agy-high`).";
        };

        fastModel = lib.mkOption {
          type = lib.types.str;
          default = "Gemini 4 Argon (Low)";
          description = "Low-latency, low-token model ID for quick general Q&A and one-liners (`agy-fast`).";
        };

        enableShellAliases = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Install tiered shell aliases (`agy-high`, `agy-fast`) for quota-aware model switching.";
        };

        enableAccountSwitcher = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Install agy-acct helper to switch Google AI Pro OAuth tokens in gnome-keyring.";
        };

        colorScheme = lib.mkOption {
          type = lib.types.str;
          default = "tokyo night";
          description = "TUI color scheme written to Antigravity CLI settings.json.";
        };

        agentMode = lib.mkOption {
          type = lib.types.enum [
            "default"
            "accept-edits"
            "auto"
            "plan"
          ];
          default = "auto";
          description = "Default execution mode for Antigravity CLI (`auto` enables Auto mode: edits & safe commands auto-approved).";
        };

        enableTerminalSandbox = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Run terminal commands inside Antigravity's OS containment sandbox.";
        };

        toolPermission = lib.mkOption {
          type = lib.types.enum [
            "proceed-in-sandbox"
            "request-review"
            "strict"
            "always-proceed"
          ];
          default = "proceed-in-sandbox";
          description = "Global tool-approval preset for local commands and edits.";
        };

        enableMcpIntegration = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Integrate Home Manager `programs.mcp.servers` into Antigravity CLI.";
        };

        enableGui = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Install the Google Antigravity GUI application (`pkgs.antigravity`).";
        };
      };

      config = lib.mkIf cfg.enable {
        programs.antigravity-cli = {
          enable = true;
          inherit (cfg) defaultModel enableMcpIntegration;

          # Merge declarative settings into a writable file on activation so
          # Google AI Pro OAuth sign-in can persist auth state in settings.json.
          mutableSettings = true;

          permissions.allow = [
            "read_file(/nix)"
            "read_file(/run)"
            "read_file(/etc)"
            "read_file(${config.home.homeDirectory}/workspace)"
            "write_file(/tmp)"
            "command(nix)"
            "command(nh)"
            "command(nixos-rebuild)"
            "command(git)"
            "command(jj)"
            "command(gh)"
            "command(fd)"
            "command(rg)"
            "command(nixfmt)"
            "command(statix)"
            "command(deadnix)"
            "command(shellcheck)"
            "command(shfmt)"
            "command(trash-put)"
            "command(python3)"
            "command(pytest)"
            "command(uv)"
            "command(ruff)"
          ];

          settings = {
            inherit (cfg)
              agentMode
              colorScheme
              enableTerminalSandbox
              toolPermission
              ;
            allowNonWorkspaceAccess = false;
            altScreenMode = "always";
            artifactReviewPolicy = "always-proceed";
            showTips = false;
            showFeedbackSurvey = false;
          };
        };

        home = {
          shellAliases = lib.mkIf cfg.enableShellAliases (
            {
              agy-high = "agy --model \"${cfg.highEffortModel}\"";
              agy-fast = "agy --model \"${cfg.fastModel}\"";
            }
            // lib.optionalAttrs cfg.enableAccountSwitcher {
              agy-1 = "agy-acct use acct1";
              agy-2 = "agy-acct use acct2";
            }
          );

          packages =
            lib.optional cfg.enableGui pkgs.antigravity
            ++ lib.optional cfg.enableAccountSwitcher (
              pkgs.writeShellApplication {
                name = "agy-acct";
                runtimeInputs = [
                  pkgs.libsecret
                  pkgs.procps
                  pkgs.coreutils
                  pkgs.findutils
                ];
                text = ''
                  umask 077

                  usage() {
                    echo "Usage: agy-acct <save|use|list|current> [slot-name]" >&2
                    exit 1
                  }

                  slots_root="''${XDG_DATA_HOME:-$HOME/.local/share}/antigravity-cli/slots"
                  auth_files=(
                    "antigravity-oauth-token"
                    "oauth_creds.json"
                    "google_accounts.json"
                    "mcp-oauth-tokens.json"
                    "credentials.json"
                  )

                  cmd="''${1:-}"
                  slot="''${2:-}"

                  case "$cmd" in
                    save)
                      [ -z "$slot" ] && usage
                      slot_dir="$slots_root/$slot"
                      rm -rf "$slot_dir/files"
                      mkdir -p "$slots_root" "$slot_dir/files/gemini" "$slot_dir/files/antigravity-cli"

                      token="$(
                        secret-tool lookup service gemini username antigravity 2>/dev/null \
                          || secret-tool lookup service gemini account antigravity 2>/dev/null \
                          || secret-tool lookup service antigravity-cli username default 2>/dev/null \
                          || secret-tool lookup service antigravity-cli account default 2>/dev/null \
                          || true
                      )"

                      found_any=0
                      if [ -n "$token" ]; then
                        printf '%s' "$token" > "$slot_dir/keyring.token"
                        found_any=1
                      else
                        rm -f "$slot_dir/keyring.token"
                      fi

                      for f in "''${auth_files[@]}"; do
                        if [ -f "$HOME/.gemini/$f" ]; then
                          install -m 600 "$HOME/.gemini/$f" "$slot_dir/files/gemini/$f"
                          found_any=1
                        fi
                        if [ -f "$HOME/.gemini/antigravity-cli/$f" ]; then
                          install -m 600 "$HOME/.gemini/antigravity-cli/$f" "$slot_dir/files/antigravity-cli/$f"
                          found_any=1
                        fi
                      done

                      if [ "$found_any" -eq 0 ]; then
                        rm -rf "$slot_dir"
                        echo "Error: No Antigravity keyring token or credential files found (~/.gemini or ~/.gemini/antigravity-cli). Sign in with 'agy' first." >&2
                        exit 1
                      fi

                      printf '%s\n' "$slot" > "$slots_root/.active"
                      echo "Saved Antigravity credentials to slot '$slot'."
                      ;;
                    use)
                      [ -z "$slot" ] && usage
                      if pgrep -x agy >/dev/null 2>&1; then
                        echo "Error: Close all running 'agy' instances before switching accounts." >&2
                        exit 1
                      fi

                      slot_dir="$slots_root/$slot"
                      if [ ! -d "$slot_dir" ]; then
                        echo "Error: Slot '$slot' not found. Run 'agy-acct save $slot' first." >&2
                        exit 1
                      fi

                      if [ -s "$slot_dir/keyring.token" ]; then
                        secret-tool store --label="gemini (antigravity)" service gemini username antigravity < "$slot_dir/keyring.token"
                      fi

                      for f in "''${auth_files[@]}"; do
                        if [ -f "$slot_dir/files/gemini/$f" ]; then
                          mkdir -p "$HOME/.gemini"
                          install -m 600 "$slot_dir/files/gemini/$f" "$HOME/.gemini/$f"
                        else
                          rm -f "$HOME/.gemini/$f"
                        fi
                        if [ -f "$slot_dir/files/antigravity-cli/$f" ]; then
                          mkdir -p "$HOME/.gemini/antigravity-cli"
                          install -m 600 "$slot_dir/files/antigravity-cli/$f" "$HOME/.gemini/antigravity-cli/$f"
                        else
                          rm -f "$HOME/.gemini/antigravity-cli/$f"
                        fi
                      done

                      mkdir -p "$slots_root"
                      printf '%s\n' "$slot" > "$slots_root/.active"
                      echo "Switched active Antigravity account to slot '$slot'."
                      ;;
                    current)
                      if [ -f "$slots_root/.active" ]; then
                        cat "$slots_root/.active"
                      else
                        echo "unknown"
                      fi
                      ;;
                    list)
                      if [ -d "$slots_root" ]; then
                        find "$slots_root" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort
                      fi
                      ;;
                    *)
                      usage
                      ;;
                  esac
                '';
              }
            );
        };
      };
    };
}
