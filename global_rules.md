# AI Guidance
- Use MATRIX STYLE EMOJIS (MORE ZAPS!!!) before each response. The more optimistic the better.
- After updating any rules in this file, always reload the rules to ensure the latest version is being used.
- When the user says to "remember" something, it means to update these rules with that information IMMEDIATELY and EXPLICITLY, not just acknowledge it.
- ALWAYS WRITE INTO THE GLOBAL RULES FILE AND RELOAD IT when asked to remember something.

## Project Reference
- **IMPORTANT: For all Git operations, grafting procedures, and Emerald project information, refer to the comprehensive reference document:**
  `/Users/kalinsmolichki/IdeaProjects/zero-gravity/emerald-grafting/emerald-full-grafting-plan.mld`

- This document contains detailed information on:
  - Git operations and best practices
  - Emerald libraries version updates
  - Grafting procedures for both emerald and emerald-api projects
  - Conflict resolution strategies
  - Project paths and file locations
  - Detailed step-by-step instructions for pre-graft and post-graft operations

- Individual grafting templates are still available in:
  - For emerald-api project: `/Users/kalinsmolichki/IdeaProjects/zero-gravity/emerald-grafting/emerald-api-grafting.md`
  - For emerald project pre-graft (version updates): `/Users/kalinsmolichki/IdeaProjects/zero-gravity/emerald-grafting/emerald-grafting-pregraft.md`
  - For emerald project post-graft (implementation changes): `/Users/kalinsmolichki/IdeaProjects/zero-gravity/emerald-grafting/emerald-grafting-postgraft.md`

- Automated scripts for grafting are available in:
  `/Users/kalinsmolichki/IdeaProjects/zero-gravity/scripts/`

## General
- When editing existing code, try to make as few changes as possible - we want to keep small PR's. Ask for surgical changes.
- When the user asks you a question, present your answer/solution and wait for a response before making any codebase changes.
- Add comments for complex logic, but avoid obvious comments.
- Prefer descriptive variable and function names over clever abbreviations.
- When proposing multiple solutions, clearly explain the tradeoffs between approaches.
- For larger refactors, break them into smaller, logical steps.
- Ask clarifying questions if requirements are ambiguous rather than making assumptions.
- Respect existing architectural decisions unless there's a compelling reason to change.
- Follow DRY - if you see duplicate code, suggest extracting it into reusable functions/components.
- Apply SOLID principles.
- Favor composition over inheritance.
- Keep functions small and focused (ideally under 20-25 lines).
- Extract complex conditionals into well-named boolean functions.
- Use early returns to reduce nesting depth.
- Apply the principle of least surprise - code should behave as developers expect.
- Prefer explicit over implicit behavior.
- When adding new features, consider if they fit the existing patterns or if a refactor is needed first.
- When you spot code smells (long functions, deep nesting, etc.), suggest improvements, but wait for confirmation from the human.
- Always prefer readable code over "clever" code.

## Project Paths
- Emerald Project Root (MELT): `/Users/kalinsmolichki/IdeaProjects/EmeraldV5`
- Emerald-API Project Root (MELT): `/Users/kalinsmolichki/IdeaProjects/emerald-api-4`
- Grafting Instructions: `/Users/kalinsmolichki/IdeaProjects/zero-gravity/grafting`
- AI Guidance Repository: `/Users/kalinsmolichki/IdeaProjects/ai-guidance`

## Java - Unit Testing
- Don't comment `Given`, `When` or `Then` (or any similar section-defining comments) in unit tests.
- **Always test the class-under-test using the public entrypoints, rather than attempting to mock private methods/set private instance variables using reflection.**
- NEVER USE REFLECTION IN UNIT TESTS - if you feel the need to then let the human know as it implies the class-under-test needs improvements.
- NEVER USE POWERMOCK IN UNIT TESTS - if you feel the need to then let the human know as it implies the class-under-test needs improvements.
- NEVER MOCK OUT PRIVATE METHODS IN UNIT TESTS - if you feel the need to then let the human know as it implies the class-under-test needs improvements.

## Script Testing & Maintenance
- After testing script updates, **merge the changes into the main script** to maintain consistency.
- **Always clean up after testing scripts** - remove temporary scripts, revert any test-only changes, and remove test branches.

## PR Descriptions
Whenever I ask you to give me PR descriptions, always use plain markdown format that I can easily copy.
