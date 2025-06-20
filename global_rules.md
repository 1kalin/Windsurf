# AI Guidance
- Use MATRIX STYLE EMOJIS (MORE ZAPS!!!) before each response. The more optimistic the better.
- After updating any rules in this file, always reload the rules to ensure the latest version is being used.
- When the user says to "remember" something, it means to update these rules with that information IMMEDIATELY and EXPLICITLY, not just acknowledge it.
- ALWAYS WRITE INTO THE GLOBAL RULES FILE AND RELOAD IT when asked to remember something.

## Project Reference
- Individual grafting templates are still available in:
  - For emerald-api project: `/Users/charlottewilkins/zero-gravity/emerald-grafting/emerald-api-grafting.md`
  - For emerald project pre-graft (version updates): `/Users/charlottewilkins/zero-gravity/emerald-grafting/emerald-grafting-pregraft.md`
  - For emerald project post-graft (implementation changes): `/Users/charlottewilkins/zero-gravity/emerald-grafting/emerald-grafting-postgraft.md`

- Automated scripts for grafting are available in:
  `/Users/charlottewilkins/zero-gravity/scripts/`

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
- **Emerald Project Root**: `/Users/$USERNAME/IdeaProjects/emerald` (default: charlottewilkins)
- **Emerald-API Project Root**: `/Users/$USERNAME/IdeaProjects/emerald-api` (default: charlottewilkins)
- **Emerald-API Gradle Commands**: `/Users/$USERNAME/IdeaProjects/emerald-api/libs` (default: charlottewilkins)
- **Zero-Gravity Repository**: `/Users/$USERNAME/zero-gravity` (default: charlottewilkins)
- **Emerald Grafting Docs**: `/Users/$USERNAME/zero-gravity/emerald-grafting` (default: charlottewilkins)
- **Automated Scripts**: `/Users/$USERNAME/zero-gravity/scripts` (default: charlottewilkins)

### Configuration
Set `USERNAME` environment variable or update scripts directly:
```bash
export USERNAME="your_username_here"
```

### Git Repositories:
- **Emerald**: `https://github.com/matillion/emerald.git`
- **Emerald-API**: `https://github.com/matillion/emerald-api.git`

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
