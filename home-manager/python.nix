let
  python-packages =
    ps: with ps; [
      # LIB
      polars # dataframes api (rust)
      # matplotlib
      ipython
      # toml
      # pymilvus # milvus vector db
      transformers

      uv-build

      # TOOLS
      openai
      # ipykernel
      # langchain
      # gradio
      # howdoi # coding answers

      httpx
      # rich
      # questionary
      ollama # ollama-python, different from ollama

      # SERVER

      # (
      #   buildPythonPackage rec {
      #     pname = "deserialize";
      #     version = "1.8.3";
      #     src = fetchPypi {
      #       inherit pname version;
      #       sha256 = "sha256-0aozmQ4Eb5zL4rtNHSFjEynfObUkYlid1PgMDVmRkwY=";
      #     };
      #     doCheck = false;
      #     propagatedBuildInputs = [
      #       pkgs.python311Packages.numpy
      #     ];
      #   }
      # )
    ];
in
python-packages
