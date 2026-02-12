---
name: ast-grep-refactor
description: "Use when you need to perform code refactoring, semantic transformations, or structural rewrites across multiple files. Ideal for API migrations, code modernization, breaking change adoption, or systematic code transformations."
---

# ast-grep Refactor Skill

## Overview

This skill enables systematic code refactoring and semantic transformations using ast-grep. Unlike simple search-and-replace, ast-grep performs structural transformations that respect code semantics, making it safe for complex refactoring tasks across large codebases.

## When to Use

Invoke this skill when you need to:
- **Migrate APIs** - Update code to use new library versions or changed APIs
- **Modernize code** - Transform old patterns to modern equivalents (e.g., var → const/let)
- **Enforce breaking changes** - Help library users adopt API changes
- **Bulk refactor patterns** - Replace specific coding patterns systematically
- **Apply code transformations** - Implement architectural changes across files
- **Create reusable transformation rules** - Build lint rules or migration scripts

## Core Transformation Concepts

### Rewrite Syntax
Use `--rewrite` or `-r` to specify the replacement pattern:
```bash
sg -p 'var $X = $Y' -r 'const $X = $Y' -l js ./src
```

### Preserving Structure
Metavariables in patterns are captured and can be referenced in rewrites:
```bash
# Pattern captures $A and $B
sg -p '$A && $A()' -r '$A?.()' -l ts ./src
```

### Comby Operators in Rewrites
- `$CAPTURE` - References a captured metavariable
- `$$$` or `$$` - Matches zero or more nodes (ellipsis)
- `$CAPTURE:regex(...)` - Applies regex transformation to captured text

## Essential Refactoring Commands

### Basic Rewrite
```bash
# Replace console.log with logger.debug
sg -p 'console.log($$$ARGS)' -r 'logger.debug($$$ARGS)' -l ts ./src

# Transform to optional chaining
sg -p '$A && $A()' -r '$A?.()' -l ts ./src

# Modernize variable declarations
sg -p 'var $X = $Y' -r 'const $X = $Y' -l js ./src
```

### Interactive Mode (Recommended)
```bash
# Review each change before applying
sg -p '$A && $A()' -r '$A?.()' -l ts -i ./src

# Controls:
# y = accept this change
# n = skip this change
# e = open in editor
# q = quit
```

### Batch Transformation
```bash
# Apply all changes without confirmation (use with caution!)
sg -p 'console.log($$$ARGS)' -r 'logger.debug($$$ARGS)' -l ts -U ./src

# Check what would change (dry run)
sg -p 'console.log($$$ARGS)' -r 'logger.debug($$$ARGS)' -l ts ./src
```

## Refactoring Workflows

### Workflow 1: API Migration

When a library changes its API, migrate all usages systematically:

1. **Analyze current usage** (use ast-grep-explorer first)
   ```bash
   # Find all old API calls
   sg -p 'oldLibrary.$METHOD($$$ARGS)' -l ts ./src
   ```

2. **Create transformation pattern**
   ```bash
   # Transform to new API
   sg -p 'oldLibrary.fetch($URL, $CONFIG)' -r 'newClient.get($URL, $CONFIG)' -l ts -i ./src
   ```

3. **Handle complex transformations with rule files**
   ```yaml
   # sg-rules/migrate-api.yml
   id: migrate-api
   language: ts
   rule:
     pattern: oldLibrary.$METHOD($URL, $CONFIG)
   fix: newClient.$METHOD($URL, $CONFIG)
   ```
   
   ```bash
   sg scan -r sg-rules/migrate-api.yml -i ./src
   ```

### Workflow 2: Code Modernization

Transform legacy patterns to modern equivalents:

1. **Transform to optional chaining**
   ```bash
   # Multiple patterns to modernize
   sg -p '$A && $A.$B' -r '$A?.$B' -l ts -i ./src
   sg -p '$A && $A()' -r '$A?.()' -l ts -i ./src
   sg -p '$A && $A[$B]' -r '$A?.[$B]' -l ts -i ./src
   ```

2. **Transform to nullish coalescing**
   ```bash
   sg -p '$A !== null && $A !== undefined ? $A : $B' -r '$A ?? $B' -l ts -i ./src
   ```

3. **Modernize React patterns**
   ```bash
   # Transform class components to function components (complex, use rule files)
   # Extract commonly used patterns
   sg -p 'componentDidMount() { $$$BODY }' -r 'useEffect(() => { $$$BODY }, [])' -l ts -i ./src
   ```

### Workflow 3: Breaking Change Adoption

Help library users adopt breaking changes:

1. **Rename renamed exports**
   ```bash
   # Old import → New import
   sg -p 'import { $OLD as $NEW } from "library"' -r 'import { $NEW } from "library"' -l ts -i ./src
   ```

2. **Transform function signatures**
   ```bash
   # Old signature: function(oldArg1, oldArg2)
   # New signature: function({newArg1, newArg2})
   sg -p 'oldFunction($A, $B)' -r 'newFunction({ arg1: $A, arg2: $B })' -l ts -i ./src
   ```

3. **Transform method chains**
   ```bash
   # Old fluent API → New fluent API
   sg -p 'builder.setA($A).setB($B)' -r 'builder.withConfig({ a: $A, b: $B })' -l ts -i ./src
   ```

### Workflow 4: Reusable Rule-Based Refactoring

Create reusable YAML rules for complex transformations:

1. **Create rule file structure**
   ```bash
   # Initialize ast-grep project
   sg new --config sgconfig.yml
   mkdir -p sg-rules
   ```

2. **Write transformation rule**
   ```yaml
   # sg-rules/transform-error-handling.yml
   id: transform-error-handling
   language: ts
   message: "Transform old error handling to new pattern"
   severity: warning
   rule:
     pattern: |
       try {
         $$$TRY
       } catch ($ERR) {
         console.error($ERR);
         $$$CATCH
       }
   fix: |
     try {
       $$$TRY
     } catch ($ERR) {
       logger.error($ERR);
       $$$CATCH
     }
   ```

3. **Test the rule**
   ```bash
   # Dry run
   sg scan -r sg-rules/transform-error-handling.yml ./src
   
   # Interactive application
   sg scan -r sg-rules/transform-error-handling.yml -i ./src
   
   # Apply all
   sg scan -r sg-rules/transform-error-handling.yml -U ./src
   ```

4. **Create multiple related rules**
   ```yaml
   # sgconfig.yml
   ruleDirs:
     - sg-rules
   testConfigs:
     - testDir: sg-tests
   ```

## Advanced Transformation Techniques

### Conditional Transformations

Use YAML rules with constraints for conditional logic:

```yaml
# sg-rules/conditional-transform.yml
id: conditional-transform
language: ts
rule:
   pattern: $OBJ.$METHOD($$$ARGS)
   constraints:
     # Only transform if object name starts with 'legacy'
     OBJ:
       regex: ^legacy.*
fix: newObj.$METHOD($$$ARGS)
```

### Multi-Step Transformations

For complex transformations that require multiple steps:

```bash
# Step 1: Extract transformation data
sg -p 'oldPattern($A, $B)' --json -l ts ./src > /tmp/matches.json

# Step 2: Generate fix from data
jq -r '.[] | "sed -i 's/oldPattern\(.text\)/newPattern(\\1)/g"' /tmp/matches.json

# Step 3: Apply step-by-step with interactive review
sg -p 'oldPattern($A, $B)' -r 'intermediate($A)' -l ts -i ./src
sg -p 'intermediate($A)' -r 'newPattern($A, defaultValue)' -l ts -i ./src
```

### Using Contextual Transformations

Transform based on surrounding context:

```yaml
# Transform based on parent node
id: contextual-transform
language: ts
rule:
   pattern: console.log($$$ARGS)
   inside:
     kind: function_declaration
     stopBy: end
fix: logger.debug($$$ARGS)
```

## Refactoring Examples

### Example 1: Import Path Migration
```bash
# Migrate from relative imports to absolute imports
# Before: import { X } from "../../utils/helper"
# After:  import { X } from "@/utils/helper"

sg -p 'import { $$$ITEMS } from "$PATH"' -r 'import { $$$ITEMS } from "@/$PATH"' -l ts -i ./src
```

### Example 2: Type Transformation
```bash
# Transform interface to type alias (or vice versa)
sg -p 'interface $NAME { $$$BODY }' -r 'type $NAME = { $$$BODY }' -l ts -i ./src

# Add readonly to properties
sg -p '$PROP: $TYPE' -r 'readonly $PROP: $TYPE' -l ts -i ./src

# Transform to use utility types
sg -p '{ $PROP: $TYPE | null }' -r '{ $PROP?: $TYPE }' -l ts -i ./src
```

### Example 3: Function Transformation
```bash
# Transform function declarations to arrow functions
sg -p 'function $NAME($$$PARAMS) { $$$BODY }' -r 'const $NAME = ($$$PARAMS) => { $$$BODY }' -l ts -i ./src

# Add error handling wrapper
sg -p 'async function $NAME($$$PARAMS) { $$$BODY }' -r 'async function $NAME($$$PARAMS) { try { $$$BODY } catch (err) { handleError(err); throw; } }' -l ts -i ./src
```

### Example 4: Framework Migration

```yaml
# sg-rules/vue-to-react.yml
id: vue-to-react
language: ts
message: "Migrate Vue component to React"
severity: hint
rule:
   pattern: |
     export default {
       data() {
         return $$$DATA
       },
       methods: {
         $$$METHODS
       }
     }
fix: |
   const Component = () => {
     const [$$$DATA] = useState($$$DATA)
     $$$METHODS
     return (
       <div></div>
     )
   }
   export default Component
```

## Safety and Validation

### Pre-Refactoring Checklist

Before applying transformations:

1. **Run tests** - Ensure existing tests pass
2. **Create backup** - Use version control (commit before refactoring)
3. **Review matches** - Dry run to see all matches first
4. **Start small** - Test on a single file or directory first
5. **Use interactive mode** - Review each change manually

### Validation Commands

```bash
# Count matches before transformation
sg -p 'pattern' -l ts --json ./src | jq 'length'

# See context around matches
sg -p 'pattern' -l ts -A 3 -B 3 ./src

# Verify no syntax errors after transformation
# (Run language-specific linter/TypeScript check)
npx tsc --noEmit
python -m py_compile file.py
```

### Rollback Strategy

```bash
# Use git to see what changed
git diff

# Revert if needed
git checkout -- ./src

# Or revert specific files
git checkout -- ./src/specific-file.ts
```

## Integration with CI/CD

### GitHub Action for Automated Refactoring

```yaml
# .github/workflows/refactor.yml
name: Code Refactoring
on:
   schedule:
     - cron: '0 0 * * 0'  # Weekly
   workflow_dispatch:

jobs:
   refactor:
     runs-on: ubuntu-latest
     steps:
       - uses: actions/checkout@v3
       - name: Install ast-grep
         run: npm install -g @ast-grep/cli
       - name: Run refactoring rules
         run: sg scan -U
       - name: Create Pull Request
         uses: peter-evans/create-pull-request@v5
         with:
           commit-message: "Apply automated refactoring"
           title: "Automated code refactoring"
           branch: automated-refactoring
```

## Common Refactoring Patterns

### Variable and Declaration Transformations
```bash
# var to const/let
sg -p 'var $X = $Y' -r 'const $X = $Y' -l js -i ./src

# String concatenation to template literals
sg -p '"$A" + $B + "$C"' -r '`${$A}${$B}${$C}`' -l js -i ./src

# Object property shorthand
sg -p '{ $PROP: $PROP }' -r '{ $PROP }' -l js -i ./src
```

### Function Transformations
```bash
# Anonymous to arrow functions
sg -p 'function($$$PARAMS) { $$$BODY }' -r '($$$PARAMS) => { $$$BODY }' -l js -i ./src

# Callback to async/await
sg -p '.then($F).catch($E)' -r 'try { await $F } catch ($E) {}' -l js -i ./src
```

### Import/Export Transformations
```bash
# CommonJS to ES modules
sg -p 'const $X = require("$M")' -r 'import * as $X from "$M"' -l js -i ./src
sg -p 'module.exports = $X' -r 'export default $X' -l js -i ./src

# Named export restructuring
sg -p 'export { $$$ITEMS }' -r 'export { $$$ITEMS }' -l ts -i ./src
```

## Tips for Effective Refactoring

1. **Always use interactive mode first** - Review changes individually
2. **Test on a subset** - Run on one file or directory before the full codebase
3. **Write tests first** - Ensure your transformations don't break functionality
4. **Use version control** - Commit before large refactorings
5. **Document patterns** - Save complex rules for reuse
6. **Combine with linting** - Run linters after transformation
7. **Use rule files for complex logic** - YAML rules support more sophisticated logic

## Common Pitfalls

1. **Over-matching**: Patterns that match unintended code
   - Solution: Use more specific patterns or constraints
   
2. **Context loss**: Transformations that lose important context
   - Solution: Preserve surrounding code with $$$ captures
   
3. **Syntax errors**: Rewrites that produce invalid syntax
   - Solution: Test on a single file first, verify with language tooling
   
4. **Unintended global changes**: -U flag applying too broadly
   - Solution: Always use -i (interactive) first, then -U only when confident

## Integration with Other Skills

This skill works synergistically with:
- **ast-grep-explorer**: Explore patterns first, then refactor
- **test agent**: Generate tests to verify transformations
- **linter**: Run linters after refactoring to catch issues

---

**Remember**: Refactoring is transformative but risky. Always backup, test, and verify.