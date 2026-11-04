# modules/hm/cli-tools.nix
# Vertical Module: CLI search utilities, Python runtime, and hardware diagnostic tools
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
      cfg = config.my.cli-tools;
    in
    {
      options.my.cli-tools = {
        enable = lib.mkEnableOption "CLI search utilities, btop, uv/python3, and hardware inspection tools";
      };

      config = lib.mkIf cfg.enable {
        programs.ripgrep.enable = true;
        programs.fd.enable = true;
        programs.btop.enable = true;

        home.packages = with pkgs; [
          uv
          python3
          trash-cli

          libva-utils
          vdpauinfo
          pciutils
          usbutils
          nvtopPackages.full
        ];
      };
    };
}
