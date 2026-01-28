{ pkgs, opencode, ... }:

{
  programs = {
    mcp = {
      enable = true;
      servers = {
        context7 = {
          command = "bunx";
          args = [
            "-y"
            "@upstash/context7-mcp"
          ];
        };
        svelte = {
          command = "bunx";
          args = [
            "-y"
            "@sveltejs/mcp"
          ];
        };
      };
    };
    opencode = {
      enable = true;
      enableMcpIntegration = true;
      commands = {
        changelog = ''
          # Update Changelog Command

          Update CHANGELOG.md with a new entry for the specified version.
          Usage: /changelog [version] [change-type] [message]
        '';
        # fix-issue = ./commands/fix-issue.md;
        commit = ''
          # Commit Command

          Create a git commit with proper message formatting.
          Usage: /commit [message]
        '';
      };
      # think of this as global AGENTS.md
      # rules = ./ai/AGENTS.md;
      # rules = symlinked...
      settings = {
        theme = "opencode";
        autoshare = false;
        autoupdate = true;
        permission = {
          "edit" = {
            # "*" = "deny";
            "packages/web/src/content/docs/*.mdx" = "allow";
          };
          "bash" = {
            "*" = "ask";
            "git *" = "allow";
            "jj *" = "allow";
            "bun *" = "allow";
            "rm *" = "deny";
            "npm *" = "deny";
          };
          # "skill" = {
          #   "*" = "allow";
          #   "pr-review" = "allow";
          #   "internal-*" = "deny";
          #   "experimental-*" = "ask";
          # };
          "webfetch" = "allow";
        };
        # built-in agents
        agent = {
          plan = {
            permission = {
              skill = {
                "internal-*" = "allow";
              };
            };
            tools = {
              skill = false;
            };
          };
        };
      };
      tools = {
        # database-query = ''
        #   import { tool } from "@opencode-ai/plugin"

        #   export default tool({
        #     description: "Query the project database",
        #     args: {
        #       query: tool.schema.string().describe("SQL query to execute"),
        #     },
        #     async execute(args) {
        #       // Your database logic here
        #       return "Executed query: " + args.query
        #     },
        #   })
        # '';

        # Or reference an existing file
        # api-client = ./tools/api-client.ts;
      };
    };
  };
}
