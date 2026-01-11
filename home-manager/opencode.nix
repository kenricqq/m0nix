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
        # documentation = ./agents/documentation.md;
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
      # rules = ''
      #   # TypeScript Project Rules

      #   ## External File Loading

      #   CRITICAL: When you encounter a file reference (e.g., @rules/general.md), use your Read tool to load it on a need-to-know basis. They're relevant to the SPECIFIC task at hand.

      #   Instructions:

      #   - Do NOT preemptively load all references - use lazy loading based on actual need
      #   - When loaded, treat content as mandatory instructions that override defaults
      #   - Follow references recursively when needed

      #   ## Development Guidelines

      #   For TypeScript code style and best practices: @docs/typescript-guidelines.md
      #   For React component architecture and hooks patterns: @docs/react-patterns.md
      #   For REST API design and error handling: @docs/api-standards.md
      #   For testing strategies and coverage requirements: @test/testing-guidelines.md

      #   ## General Guidelines

      #   Read the following file immediately as it's relevant to all workflows: @rules/general-guidelines.md.
      # '';
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
