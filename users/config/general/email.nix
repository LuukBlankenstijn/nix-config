{ pkgs, ... }:
let
  gmailAuth = id: {
    "mail.server.server_${id}.authMethod" = 10;
    "mail.smtpserver.smtp_${id}.authMethod" = 10;
  };
  outlookAuth = id: {
    "mail.server.server_${id}.authMethod" = 10;
    "mail.smtpserver.smtp_${id}.authMethod" = 10;
    "mail.server.server_${id}.use_integrated_auth" = true;
  };

  protonAuth = id: {
    "mail.server.server_${id}.authMethod" = 3;
    "mail.smtpserver.smtp_${id}.authMethod" = 3;
  };
in
{
  accounts.email.accounts = {
    "luukblankenstijn" = {
      primary = true;
      address = "luukblankenstijn@gmail.com";
      realName = "Luuk Blankenstijn";
      userName = "luukblankenstijn@gmail.com";
      flavor = "gmail.com";
      thunderbird = {
        enable = true;
        profiles = [ "default" ];
        settings = gmailAuth;
      };
    };
    "uni" = {
      address = "l.c.m.blankenstijn@student.tue.nl";
      realName = "Luuk Blankenstijn";
      userName = "l.c.m.blankenstijn@student.tue.nl";
      flavor = "outlook.office365.com";
      thunderbird = {
        enable = true;
        profiles = [ "default" ];
        settings = outlookAuth;
      };
    };
    "vetpot" = {
      primary = false;
      address = "vetpot0@gmail.com";
      realName = "Vet Pot";
      userName = "vetpot0@gmail.com";
      flavor = "gmail.com";
      thunderbird = {
        enable = true;
        profiles = [ "default" ];
        settings = gmailAuth;
      };
    };
    "proton" = {
      address = "me@luukblankenstijn.nl";
      realName = "Luuk Blankenstijn";
      userName = "me@luukblankenstijn.nl";

      imap = {
        host = "127.0.0.1";
        port = 1143;
        tls.enable = false;
        tls.useStartTls = true;
      };
      smtp = {
        host = "127.0.0.1";
        port = 1025;
        tls.enable = false;
        tls.useStartTls = true;
      };

      thunderbird = {
        enable = true;
        profiles = [ "default" ];
        settings = protonAuth;
      };
    };
  };

  services.protonmail-bridge.enable = true;
  home.packages = [
    pkgs.protonmail-bridge-gui
  ];
}
