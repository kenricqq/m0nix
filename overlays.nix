{ inputs }:

[
  # inputs.jujutsu.overlays.default
  inputs.zig.overlays.default
  inputs.helix.overlays.default
  inputs.devenv.overlays.default
  # inputs.fenix.overlays.defaults

  (final: prev: rec {
    #   # gh CLI on stable has bugs.
    #   gh = inputs.nixpkgs-unstable.legacyPackages.${prev.system}.gh;

    #   # Want the latest version of these
    #   claude-code = inputs.nixpkgs-unstable.legacyPackages.${prev.system}.claude-code;
    # nushell = inputs.nixpkgs.legacyPackages.${prev.stdenv.hostPlatform.system}.nushell;

    # zellij = prev.zellij.overrideAttrs (
    #   _old:
    #   let
    #     src = inputs.zellij-src;
    #   in
    #   {
    #     inherit src;
    #     version = "main-${src.shortRev or "dirty"}";

    #     cargoDeps = prev.rustPlatform.fetchCargoVendor {
    #       inherit src;
    #       hash = "sha256-4aKcQX4+9zoT4bFJzV6rqqw+aaj0ZUJ65xwVnIcrx18=";
    #     };

    #     doInstallCheck = false;
    #     nativeInstallCheckInputs = [ ];
    #   }
    # );
    # helix-master = helix.overlays.default;

    svelte-language-server = prev.svelte-language-server.overrideAttrs (old: rec {
      version = "0.17.29";

      src = prev.fetchFromGitHub {
        owner = "sveltejs";
        repo = "language-tools";
        tag = "svelte-language-server@${version}";
        hash = "sha256-pS+QTfk6GWVBZlAOaY0Gg67zCrEAwxfyalt+MgWxYEQ=";
      };

      pnpmDeps = prev.fetchPnpmDeps {
        inherit (old) pname pnpmWorkspaces;
        inherit version src;
        fetcherVersion = 2;
        hash = "sha256-v2X2WOEdrDwGO2q9IEjONpHeDFqVp3jGFYYjZ5uFLSE=";
      };
    });

    codex = inputs.codex.packages.${prev.stdenv.hostPlatform.system}.default;

    zjstatus = inputs.zjstatus-src.packages.${prev.stdenv.hostPlatform.system}.default;
  })
]
