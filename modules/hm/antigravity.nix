# modules/hm/antigravity.nix
# Vertical Module: Google Antigravity CLI (`agy`) tuned for Google AI Pro efficiency
{ ... }:
{
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
          default = "gemini-4-argon-medium";
          description = "Balanced default model ID for daily coding and interactive sessions.";
        };

        highEffortModel = lib.mkOption {
          type = lib.types.str;
          default = "gemini-4-argon-high";
          description = "High-reasoning model ID reserved for complex multi-file architecture (`agy-high`).";
        };

        fastModel = lib.mkOption {
          type = lib.types.str;
          default = "gemini-4-argon-low";
          description = "Low-latency, low-token model ID for quick general Q&A and one-liners (`agy-fast`).";
        };

        enableShellAliases = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Install tiered shell aliases (`agy-high`, `agy-fast`) for quota-aware model switching.";
        };

        colorScheme = lib.mkOption {
          type = lib.types.str;
          default = "tokyo night";
          description = "TUI color scheme written to Antigravity CLI settings.json.";
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
          package = pkgs.antigravity-cli;
          defaultModel = cfg.defaultModel;
          enableMcpIntegration = cfg.enableMcpIntegration;

          # Merge declarative settings into a writable file on activation so
          # Google AI Pro OAuth sign-in can persist auth state in settings.json.
          mutableSettings = true;

          settings = {
            model = cfg.defaultModel;
            colorScheme = cfg.colorScheme;
            altScreenMode = "always";
            enableTerminalSandbox = cfg.enableTerminalSandbox;
            toolPermission = cfg.toolPermission;
            artifactReviewPolicy = "agent-decides";
            showTips = false;
            showFeedbackSurvey = false;
          };
        };

        home.shellAliases = lib.mkIf cfg.enableShellAliases {
          agy-high = "agy --model ${cfg.highEffortModel}";
          agy-fast = "agy --model ${cfg.fastModel}";
        };

        home.packages = lib.optional cfg.enableGui pkgs.antigravity;
      };
    };
}
