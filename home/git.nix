{ ... }:

{
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings.user = {
      name = "repen7ant";
      email = "ilyarepentant@icloud.com";
    };
  };
}
