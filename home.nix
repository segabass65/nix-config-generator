{ lib }: rec {
  test = with lib; {
    config.xdg.configFile = {
      "config-generator/sxhkd/sxhkdrc".text = toSxhkd {
        keybindings = {
          "super + k" =
            "echo Hello, World!";
        };

        extraConfig = ''
          super + e
            echo Hello, World!
        '';
      };

      "config-generator/polybar/config.ini".text = toPolybar {
        config."module/config" = {
          type = "custom/text";
          label = "Hello, World!";
        };

        settings."module/settings" = {
          type = "custom/text";
          label = "Hello, World!";
        };

        extraConfig = ''
          [module/extraConfig]
          type=custom/text
          label=Hello, World!
        '';
      };

      "config-generator/bspwm/bspwmrc".text = toColoraddod {
        settings.border_colors = {
          locked = "#ff0000";
          marked = "#00ff00";
          private = "#ffff00";
          sticky = "#ffff00";
          urgent = "#0000ff";
        };

        extraConfig = ''
          echo Hello, World!
        '';
      };
    };
  };

  default = test;
}
