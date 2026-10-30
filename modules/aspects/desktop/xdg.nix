{ ... }:
{
  den.aspects.xdg.homeManager = { config, ... }: {
    xdg.userDirs = {
      enable = true;
      createDirectories = false;
      download = "${config.home.homeDirectory}/Downloads";  
      setSessionVariables = false;
    };
  };
}
