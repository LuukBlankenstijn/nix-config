{ pkgs, ... }: { environment.systemPackages = with pkgs; [ git vim bind jq ]; }
