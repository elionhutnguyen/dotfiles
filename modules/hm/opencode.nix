# modules/hm/opencode.nix
# Vertical Module: OpenCode 2 terminal agent with token-conserving model tiering & compaction
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
      cfg = config.my.opencode;

      # Self-healing workaround for NixOS/nixpkgs#582673 (opencode 2.2.5 + bun 1.4.4 FOD mismatch).
      # Automatically deactivates once upstream nixpkgs updates `outputHash`.
      opencodePackage =
        if
          (pkgs.opencode ? node_modules)
          && (
            pkgs.opencode.node_modules.outputHash or "" == "sha256-xfOVcw1+waLVNhFDwzOtzxrUSQEogvn88YomydOlhwc="
          )
        then
          pkgs.opencode.overrideAttrs (oldAttrs: {
            node_modules = oldAttrs.node_modules.overrideAttrs {
              outputHash = "sha256-prx9dX7kUvs/E3zopkaPk5LXh3xJAy5sZeum/W8L7cA=";
            };
          })
        else
          pkgs.opencode;
    in
    {
      options.my.opencode = {
        enable = lib.mkEnableOption "OpenCode terminal coding agent";

        theme = lib.mkOption {
          type = lib.types.str;
          default = "tokyonight";
          description = "Terminal client color theme name (mapped to programs.opencode.cli.theme).";
        };

        primaryModel = lib.mkOption {
          type = lib.types.str;
          default = "google/gemini-3.1-pro";
          description = "Primary reasoning/coding model for main agent turns.";
        };

        smallModel = lib.mkOption {
          type = lib.types.str;
          default = "google/gemini-3.8-flash";
          description = "Lightweight Flash model for context summarization, title generation, and fast file searches.";
        };

        autoCompaction = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Automatically compact and prune stale tool outputs to minimize token consumption.";
        };

        enableMcpIntegration = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Integrate Home Manager declarative MCP servers into OpenCode.";
        };
      };

      config = lib.mkIf cfg.enable {
        programs.opencode = {
          enable = true;
          package = opencodePackage;
          enableMcpIntegration = cfg.enableMcpIntegration;
          mutableSettings = true;

          # OpenCode 2 uses `cli.json` via `programs.opencode.cli`
          cli = {
            theme = cfg.theme;
          };

          settings = {
            model = cfg.primaryModel;
            small_model = cfg.smallModel;
            autoupdate = false;
            share = "disabled";

            compaction = {
              auto = cfg.autoCompaction;
              prune = cfg.autoCompaction;
            };

            permission = {
              edit = "ask";
              bash = "ask";
              webfetch = "allow";
            };
          };
        };
      };
    };
}
