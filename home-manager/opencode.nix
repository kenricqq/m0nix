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
      package = opencode.packages.${pkgs.stdenv.hostPlatform.system}.default;
      agents = {
        animation = ./ai/agents/animation.md;
        btca = ./ai/agents/btca.md;
        quality_control = ./ai/agents/quality_control.md;

        code-reviewer = ''
          # Code Reviewer Agent

          You are a senior software engineer specializing in code reviews.
          Focus on code quality, security, and maintainability.

          ## Guidelines
          - Review for potential bugs and edge cases
          - Check for security vulnerabilities
          - Ensure code follows best practices
          - Suggest improvements for readability and performance
        '';
      };
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
      rules = ./ai/AGENTS.md;
      settings = {
        theme = "opencode";
        autoshare = false;
        autoupdate = true;
        permission = {
          "edit" = {
            "*" = "deny";
            "packages/web/src/content/docs/*.mdx" = "allow";
          };
          "bash" = {
            "*" = "ask";
            "git *" = "allow";
            "bun *" = "allow";
            "rm *" = "deny";
          };
          "webfetch" = "allow";
        };
      };
      skills = {
        git-release = ''
          ---
          name: git-release
          description: Create consistent releases and changelogs
          ---

          ## What I do

          - Draft release notes from merged PRs
          - Propose a version bump
          - Provide a copy-pasteable `gh release create` command
        '';

        # A skill can also be a directory containing SKILL.md and other files.
        # data-analysis = ./skills/data-analysis;
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
