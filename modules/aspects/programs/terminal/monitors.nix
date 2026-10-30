{ ... }:
{
  den.aspects.monitors.homeManager = { pkgs, ... }: {
    # System CPU/Memory/Process monitor
    programs.btop.enable = true;

    # GPU accelerator monitor
    home.packages = [ pkgs.nvtopPackages.full ];
  };
}
