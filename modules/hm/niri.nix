# modules/hm/niri.nix
# Vertical Module: User-level Niri configuration (build-validated KDL & Noctalia IPC)
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
      cfg = config.my.niri;

      startupCommands = lib.concatMapStringsSep "\n" (
        argv: "spawn-at-startup ${lib.concatMapStringsSep " " (arg: ''"${arg}"'') argv}"
      ) cfg.spawnAtStartup;

      niriKdl = pkgs.writeText "niri-raw.kdl" ''
        ${startupCommands}

        debug {
            honor-xdg-activation-with-invalid-serial
        }

        input {
            keyboard {
                xkb {
                    layout "us"
                }
                repeat-delay 300
                repeat-rate 40
                numlock
            }

            touchpad {
                tap
                natural-scroll
                scroll-factor 0.5
                accel-speed 0.2
                accel-profile "flat"
            }

            mouse {
                accel-speed 0.0
                accel-profile "flat"
            }
        }

        prefer-no-csd

        layout {
            gaps 10
            center-focused-column "never"

            preset-column-widths {
                proportion 0.33333
                proportion 0.5
                proportion 0.66667
            }

            default-column-width { proportion 0.5; }

            focus-ring {
                width 2
                active-color "${cfg.activeBorderColor}"
                inactive-color "${cfg.inactiveBorderColor}"
            }

            border {
                off
            }
        }

        window-rule {
            geometry-corner-radius 8
            clip-to-geometry true
        }

        window-rule {
            match app-id="dev.noctalia.Noctalia"
            open-floating true
        }

        // Dialogs and Authentication Prompts
        window-rule {
            match app-id=r#"^org\.gnome\.Polkit.*"#
            match app-id="polkit-gnome-authentication-agent-1"
            match app-id=r#"^xdg-desktop-portal.*"#
            match app-id=r#"^org\.fcitx\..*"#
            match app-id="fcitx5-config-qt"
            match title=r#"^Picture-in-Picture$"#
            match title=r#"^Open File.*"#
            match title=r#"^Save File.*"#
            open-floating true
        }

        // Chromium & Browser subsurfaces (exempt from geometry clipping)
        window-rule {
            match app-id=r#"^brave-browser.*"#
            match app-id=r#"^brave-origin.*"#
            clip-to-geometry false
        }

        // Screencast Privacy: Prevents credential dialogs from appearing in presentations
        window-rule {
            match app-id=r#"^org\.gnome\.Polkit.*"#
            match app-id="polkit-gnome-authentication-agent-1"
            match app-id=r#"^xdg-desktop-portal.*"#
            block-out-from "screencast"
        }

        binds {
            Mod+Shift+Slash { show-hotkey-overlay; }

            Mod+T hotkey-overlay-title="Open a Terminal" { spawn "${cfg.terminal}"; }
            Mod+D hotkey-overlay-title="Application Launcher" { spawn "${cfg.shell}" "msg" "panel-toggle" "launcher"; }
            Mod+S hotkey-overlay-title="Control Center" { spawn "${cfg.shell}" "msg" "panel-toggle" "control-center"; }
            Mod+E hotkey-overlay-title="File Manager" { spawn "${cfg.terminal}" "-e" "${cfg.fileManager}"; }
            Mod+Alt+L hotkey-overlay-title="Lock the Screen" { spawn "${cfg.shell}" "msg" "session" "lock"; }

            XF86AudioRaiseVolume allow-when-locked=true { spawn "${cfg.shell}" "msg" "volume-up"; }
            XF86AudioLowerVolume allow-when-locked=true { spawn "${cfg.shell}" "msg" "volume-down"; }
            XF86AudioMute        allow-when-locked=true { spawn "${cfg.shell}" "msg" "volume-mute"; }
            XF86AudioMicMute     allow-when-locked=true { spawn "${cfg.shell}" "msg" "mic-mute"; }

            XF86AudioPlay        allow-when-locked=true { spawn "playerctl" "play-pause"; }
            XF86AudioPause       allow-when-locked=true { spawn "playerctl" "play-pause"; }
            XF86AudioStop        allow-when-locked=true { spawn "playerctl" "stop"; }
            XF86AudioPrev        allow-when-locked=true { spawn "playerctl" "previous"; }
            XF86AudioNext        allow-when-locked=true { spawn "playerctl" "next"; }

            XF86MonBrightnessUp   allow-when-locked=true { spawn "${cfg.shell}" "msg" "brightness-up"; }
            XF86MonBrightnessDown allow-when-locked=true { spawn "${cfg.shell}" "msg" "brightness-down"; }

            // Dynamic Cast Controls
            Mod+Shift+C { set-dynamic-cast-window; }
            Mod+Alt+C   { clear-dynamic-cast-target; }

            Mod+O repeat=false { toggle-overview; }
            Mod+Q repeat=false { close-window; }

            Mod+H     { focus-column-left; }
            Mod+J     { focus-window-down; }
            Mod+K     { focus-window-up; }
            Mod+L     { focus-column-right; }

            Mod+Ctrl+H     { move-column-left; }
            Mod+Ctrl+J     { move-window-down; }
            Mod+Ctrl+K     { move-window-up; }
            Mod+Ctrl+L     { move-column-right; }

            Mod+Home { focus-column-first; }
            Mod+End  { focus-column-last; }
            Mod+Ctrl+Home { move-column-to-first; }
            Mod+Ctrl+End  { move-column-to-last; }

            Mod+Page_Down      { focus-workspace-down; }
            Mod+Page_Up        { focus-workspace-up; }
            Mod+U              { focus-workspace-down; }
            Mod+I              { focus-workspace-up; }
            Mod+Ctrl+Page_Down { move-column-to-workspace-down; }
            Mod+Ctrl+Page_Up   { move-column-to-workspace-up; }
            Mod+Ctrl+U         { move-column-to-workspace-down; }
            Mod+Ctrl+I         { move-column-to-workspace-up; }

            Mod+Shift+Page_Down { move-workspace-down; }
            Mod+Shift+Page_Up   { move-workspace-up; }
            Mod+Shift+U         { move-workspace-down; }
            Mod+Shift+I         { move-workspace-up; }

            Mod+1 { focus-workspace 1; }
            Mod+2 { focus-workspace 2; }
            Mod+3 { focus-workspace 3; }
            Mod+4 { focus-workspace 4; }
            Mod+5 { focus-workspace 5; }
            Mod+6 { focus-workspace 6; }
            Mod+7 { focus-workspace 7; }
            Mod+8 { focus-workspace 8; }
            Mod+9 { focus-workspace 9; }
            Mod+Ctrl+1 { move-column-to-workspace 1; }
            Mod+Ctrl+2 { move-column-to-workspace 2; }
            Mod+Ctrl+3 { move-column-to-workspace 3; }
            Mod+Ctrl+4 { move-column-to-workspace 4; }
            Mod+Ctrl+5 { move-column-to-workspace 5; }
            Mod+Ctrl+6 { move-column-to-workspace 6; }
            Mod+Ctrl+7 { move-column-to-workspace 7; }
            Mod+Ctrl+8 { move-column-to-workspace 8; }
            Mod+Ctrl+9 { move-column-to-workspace 9; }

            Mod+BracketLeft  { consume-or-expel-window-left; }
            Mod+BracketRight { consume-or-expel-window-right; }

            Mod+Comma  { consume-window-into-column; }
            Mod+Period { expel-window-from-column; }

            Mod+R { switch-preset-column-width; }
            Mod+Shift+R { switch-preset-column-width-back; }

            Mod+Ctrl+Shift+R { switch-preset-window-height; }
            Mod+Ctrl+R { reset-window-height; }

            Mod+F { maximize-column; }
            Mod+Shift+F { fullscreen-window; }
            Mod+M { maximize-window-to-edges; }
            Mod+Ctrl+F { expand-column-to-available-width; }

            Mod+C { center-column; }
            Mod+Ctrl+C { center-visible-columns; }

            Mod+Minus { set-column-width "-10%"; }
            Mod+Equal { set-column-width "+10%"; }

            Mod+Shift+Minus { set-window-height "-10%"; }
            Mod+Shift+Equal { set-window-height "+10%"; }

            Mod+V       { toggle-window-floating; }
            Mod+Shift+V { switch-focus-between-floating-and-tiling; }

            Mod+W { toggle-column-tabbed-display; }

            Print { screenshot; }
            Ctrl+Print { screenshot-screen; }
            Alt+Print { screenshot-window; }

            Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }

            Mod+Shift+E { quit; }
            Ctrl+Alt+Delete { quit; }

            Mod+Shift+P { power-off-monitors; }
        }
      '';

      validatedNiriConfig =
        pkgs.runCommand "niri-config.kdl"
          {
            nativeBuildInputs = [ pkgs.niri ];
          }
          ''
            niri validate -c ${niriKdl}
            cp ${niriKdl} $out
          '';
    in
    {
      options.my.niri = {
        enable = lib.mkEnableOption "user-level Niri compositor configuration";

        activeBorderColor = lib.mkOption {
          type = lib.types.str;
          default = "#7aa2f7";
          description = "Hex color for active window focus ring.";
        };

        inactiveBorderColor = lib.mkOption {
          type = lib.types.str;
          default = "#24283b";
          description = "Hex color for inactive window focus ring.";
        };

        shell = lib.mkOption {
          type = lib.types.str;
          default = "noctalia";
          description = "Desktop shell IPC binary used for launcher, session lock, and OSD controls.";
        };

        terminal = lib.mkOption {
          type = lib.types.str;
          default = "ghostty";
          description = "Terminal emulator binary spawned by Mod+T and Mod+E.";
        };

        fileManager = lib.mkOption {
          type = lib.types.str;
          default = "yazi";
          description = "TUI file manager binary spawned inside the terminal by Mod+E.";
        };

        spawnAtStartup = lib.mkOption {
          type = lib.types.listOf (lib.types.listOf lib.types.str);
          default = [ ];
          description = "Commands spawned at Niri startup (each entry is an argv list).";
        };
      };

      config = lib.mkIf cfg.enable {
        xdg.configFile."niri/config.kdl".source = validatedNiriConfig;
      };
    };
}
