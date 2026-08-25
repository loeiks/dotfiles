{
  pkgs,
  ...
}:

{
  home.packages = [
    pkgs.go
    pkgs.php
    pkgs.python3
    pkgs.nodejs_24
    pkgs.bun
  ];
}
