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
          type = lib.types.str;
          default = "Gemini 4 Argon (Medium)";
          description = "Balanced default model ID for daily coding and interactive sessions.";
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

        enableTerminalSandbox = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Run terminal commands inside Antigravity's OS containment sandbox.";
        };

        toolPermission = lib.mkOption {
          type = lib.types.enum [
            "proceed-in-sandbox"
            "request-review"
            "strict"
            "always-proceed"
          ];
          default = "request-review";
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
          package = pkgs.antigravity-cli;
          inherit (cfg) defaultModel enableMcpIntegration;

          # Merge declarative settings into a writable file on activation so
          # Google AI Pro OAuth sign-in can persist auth state in settings.json.
          mutableSettings = true;

          settings = {
            model = cfg.defaultModel;
            inherit (cfg) colorScheme enableTerminalSandbox toolPermission;
            altScreenMode = "always";
            artifactReviewPolicy = "agent-decides";
            showTips = false;
            showFeedbackSurvey = false;
          };
        };

        home.shellAliases = lib.mkIf cfg.enableShellAliases (
          {
            agy-high = "agy --model \"${cfg.highEffortModel}\"";
            agy-fast = "agy --model \"${cfg.fastModel}\"";
          }
          // lib.optionalAttrs cfg.enableAccountSwitcher {
            agy-1 = "agy-acct use acct1";
            agy-2 = "agy-acct use acct2";
          }
        );

        home.packages =
          lib.optional cfg.enableGui pkgs.antigravity
          ++ lib.optional cfg.enableAccountSwitcher (
            pkgs.writeShellApplication {
              name = "agy-acct";
              runtimeInputs = [
                pkgs.libsecret
                pkgs.procps
              ];
              text = ''
                usage() {
                  echo "Usage: agy-acct <save|use|list|current> [slot-name]"
                  exit 1
                }
                cmd="''${1:-}"
                slot="''${2:-}"
                case "$cmd" in
                  save)
                    [ -z "$slot" ] && usage
                    token="$(secret-tool lookup service gemini account antigravity || true)"
                    if [ -z "$token" ]; then
                      echo "Error: No active Antigravity token found in keyring (service=gemini account=antigravity)." >&2
                      exit 1
                    fi
                    printf '%s' "$token" | secret-tool store --label="Antigravity Slot ($slot)" service gemini-slot account "$slot"
                    printf '%s' "$slot" | secret-tool store --label="Antigravity Active Slot" service gemini-slot account __active__
                    echo "Saved current Google AI Pro token to keyring slot '$slot'."
                    ;;
                  use)
                    [ -z "$slot" ] && usage
                    if pgrep -x agy >/dev/null 2>&1; then
                      echo "Error: Close all running 'agy' instances before switching accounts." >&2
                      exit 1
                    fi
                    token="$(secret-tool lookup service gemini-slot account "$slot" || true)"
                    if [ -z "$token" ]; then
                      echo "Error: Keyring slot '$slot' not found. Run 'agy-acct save $slot' first." >&2
                      exit 1
                    fi
                    printf '%s' "$token" | secret-tool store --label="gemini (antigravity)" service gemini account antigravity
                    printf '%s' "$slot" | secret-tool store --label="Antigravity Active Slot" service gemini-slot account __active__
                    echo "Switched active Antigravity account to keyring slot '$slot'."
                    ;;
                  current)
                    active="$(secret-tool lookup service gemini-slot account __active__ || true)"
                    echo "Active slot: ''${active:-unknown}"
                    ;;
                  list)
                    secret-tool search --all service gemini-slot 2>&1 | grep -E '^attribute\.account = ' | sed 's/attribute\.account = //' | grep -v '^__active__$' || true
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
}
