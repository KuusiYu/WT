# 项目规则 - Claude Code

以下规则适用于该Python项目，用于指导代码质量检查、格式化、bug修复和任务实现。

## 1. 代码质量检查 (Check)

```mdc
# Check

Perform comprehensive code quality and security checks.

## Primary Task:
Run `npm run check` (or project-specific check command) and resolve any resulting errors.

## Important:
- DO NOT commit any code during this process
- DO NOT change version numbers
- Focus only on fixing issues identified by checks

## Common Checks Include:
1. **Linting**: Code style and syntax errors
2. **Type Checking**: TypeScript/Flow type errors
3. **Unit Tests**: Failing test cases
4. **Security Scan**: Vulnerability detection
5. **Code Formatting**: Style consistency
6. **Build Verification**: Compilation errors

## Process:
1. Run the check command
2. Analyze output for errors and warnings
3. Fix issues in priority order:
   - Build-breaking errors first
   - Test failures
   - Linting errors
   - Warnings
4. Re-run checks after each fix
5. Continue until all checks pass

## For Different Project Types:
- **JavaScript/TypeScript**: `npm run check` or `yarn check`
- **Python**: `black`, `isort`, `flake8`, `mypy`
- **Rust**: `cargo check`, `cargo clippy`
- **Go**: `go vet`, `golint`
- **Swift**: `swift-format`, `swiftlint`
```

## 2. 代码清洁 (Clean)

```mdc
# Clean

Fix all code formatting and quality issues in the entire codebase.

## Python Projects:
Fix all `black`, `isort`, `flake8`, and `mypy` issues

### Steps:
1. **Format with Black**: `black .`
2. **Sort imports with isort**: `isort .`
3. **Fix flake8 issues**: `flake8 . --extend-ignore=E203`
4. **Resolve mypy type errors**: `mypy .`

## JavaScript/TypeScript Projects:
Fix all ESLint, Prettier, and TypeScript issues

### Steps:
1. **Format with Prettier**: `npx prettier --write .`
2. **Fix ESLint issues**: `npx eslint . --fix`
3. **Check TypeScript**: `npx tsc --noEmit`

## General Process:
1. Run automated formatters first
2. Fix remaining linting issues manually
3. Resolve type checking errors
4. Verify all tools pass with no errors
5. Review changes before committing

## Common Issues:
- Import order conflicts between tools
- Line length violations
- Unused imports/variables
- Type annotation requirements
- Missing return types
- Inconsistent quotes/semicolons
```

## 3. Bug修复 (Bug Fix)

```mdc
# Bug Fix

Fix a specific bug following a structured approach.

## Primary Task:
Implement a fix for a specific bug, ensuring all related issues are resolved and no regressions are introduced.

## Important:
- Focus only on the specified bug
- Maintain backward compatibility
- DO NOT refactor unrelated code
- DO NOT add new features

## Process:
1. **Reproduce**: Verify the bug exists with a clear test case
2. **Root Cause**: Analyze code to understand the underlying issue
3. **Fix**: Implement a minimal, focused solution
4. **Test**: Verify fix resolves the issue without regressions
5. **Document**: Update any relevant documentation

## Key Considerations:
- **Minimal Change**: Make the smallest change possible to fix the bug
- **Test Coverage**: Ensure the fix is covered by tests
- **Error Handling**: Add appropriate error handling
- **Edge Cases**: Consider all possible edge cases
- **Performance**: Ensure fix doesn't degrade performance
```

## 4. 任务实现 (Implement Task)

```mdc
# Implement Task

Implement a specific task following a structured approach.

## Primary Task:
Implement a specific feature or functionality according to the requirements.

## Important:
- Follow project coding standards
- Maintain consistency with existing code
- Write clear documentation
- Add appropriate tests

## Process:
1. **Understand**: Clarify requirements and constraints
2. **Plan**: Design the implementation approach
3. **Implement**: Write the code following best practices
4. **Test**: Verify functionality works as expected
5. **Review**: Check for quality, consistency, and completeness

## Key Considerations:
- **Architecture**: Follow project architecture patterns
- **Code Quality**: Write clean, maintainable code
- **Documentation**: Update or create relevant documentation
- **Testing**: Add unit tests for new functionality
- **Performance**: Consider performance implications
```

---

以上规则来自 https://github.com/steipete/agent-rules 项目，已适配Python项目使用。