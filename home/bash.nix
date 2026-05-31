{ configName, dotfiles, ... }:

{
  programs.bash = {
    enable = true;

    shellAliases = {
      sw = "nh os switch -H ${configName}";
      upd = "nh os switch -H ${configName} --update";
      nrs = "sudo nixos-rebuild switch --flake ${dotfiles}#${configName}";

      ".." = "cd ..";
    };

    initExtra = ''
      export PS1="\[\e[38;5;75m\]\u@\h \[\e[38;5;113m\]\w \[\e[38;5;189m\]\$ \[\e[0m\]"
    '';
  };
}
