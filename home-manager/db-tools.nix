{ pkgs, ... }:

{
  programs = {
    lazysql = {
      enable = true;
    };
  };

  home.packages = with pkgs; [
    duckdb # embeddable analytics db
    tigerbeetle # high performance transactional db
    sqlfluff
    sqlite
    # pgcli # for postgres
    sqlc
    litecli # for sqlite
    # turso-cli
  ];
}
