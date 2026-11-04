# modules/hm/antigravity.nix
# Vertical Module: Google Antigravity CLI (`agy`) via native HM module & optional GUI
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
          default = "gemini-3.8-flash";
          description = ''
            Default model for Antigravity CLI sessions.
            Use "gemini-3.8-flash" as the daily baseline to conserve Google AI Pro
            rolling/weekly quota, and escalate in-session to "gemini-3.1-pro" or
            "gemini-4-argon" when needed.
          '';
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

        home.packages = lib.optional cfg.enableGui pkgs.antigravity;
      };
    };
}
