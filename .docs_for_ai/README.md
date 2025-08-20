# AI Coding Agent Documentation Library

This directory, `.docs_for_ai/`, serves as a local documentation library for the AI coding agent.

## Purpose

The primary purpose of this directory is to store documentation pages that are fetched for reference by the AI agent. This allows the agent to have quick, local access to relevant documentation, improving its performance and accuracy when making code changes.

## Structure

To maintain clarity and ease of access, please adhere to the following structure:

- Create a subdirectory for each tool, library, or framework. For example:
  - `./.docs_for_ai/rust/`
  - `./.docs_for_ai/datafusion/`
  - `./.docs_for_ai/duckdb/`

- Inside each subdirectory, store the relevant documentation pages as markdown files (`.md`) or text files (`.txt`).

- Use descriptive filenames for the documentation pages.

## Versioning and Maintenance

- **Single Version:** Only one version of the documentation for a specific tool should be present at any given time.
- **Keep Current:** The documentation stored here should be kept up-to-date. It should correspond to the version of the tool being used in the project, or the latest stable version if a specific version isn't required.
- **Updating Docs:** When a tool's version is updated in the project, the corresponding documentation in this directory should be refreshed to match.

By following these guidelines, we can ensure that the AI agent has access to accurate and well-organized documentation.
