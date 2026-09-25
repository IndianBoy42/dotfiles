---
name: ast-grep-explore
description: "Use when you need to explore, search, or understand codebases using structural AST patterns. Ideal for finding specific code patterns, understanding code architecture, discovering API usage, or locating code smells across multiple files."
---

# ast-grep Explorer Skill

## Overview

This skill enables systematic exploration of codebases using ast-grep's structural search capabilities. Unlike text-based grep, ast-grep matches code based on Abstract Syntax Tree (AST) structure, allowing precise pattern matching that understands code semantics.

## When to Use

Invoke this skill when you need to:
- **Understand codebase architecture** - Find class hierarchies, module structures, or component relationships
- **Discover API usage patterns** - Locate how specific functions, methods, or libraries are used
- **Find code patterns** - Identify recurring patterns like specific control flows, error handling styles, or design patterns
- **Locate specific constructs** - Find all async functions, React hooks, database queries, etc.
- **Analyze code quality** - Discover potential issues, deprecated patterns, or inconsistent implementations
- **Explore specific focus areas** - Start from a known file or pattern and expand exploration outward

## Core Concepts

### Metavariables
Use `$` followed by uppercase letters as wildcards that match any single AST node:
- `$VAR` - matches any variable name
- `$EXPR` - matches any expression
- `$FUNC` - matches any function
- `$TYPE` - matches any type annotation

**Example**: `$X && $X()` matches `obj.val && obj.val()`, `user && user()`, etc.

### Structural vs Textual Matching
- **Structural**: Matches based on syntax tree (understands code meaning)
- **Textual**: Use `--regex` for text-based matching within nodes
- **Field matching**: Match specific node fields like `.name`, `.body`, `.params`

### Languages
ast-grep supports 20+ languages including: JavaScript/TypeScript, Python, Rust, Go, Java, C/C++, C#, Ruby, PHP, and more.

## Essential Commands

### Basic Search
```bash
# Search for pattern in current directory
ast-grep --pattern 'console.log($X)' --lang js

# Short form (sg is alias for ast-grep)
sg -p 'console.log($X)' -l js

# Search specific directory
sg -p 'class $NAME { $$$BODY }' -l ts ./src
```

### Debug Pattern Understanding
```bash
# See AST structure of your pattern (crucial for learning)
sg -p 'function $NAME($$$PARAMS) { $$$BODY }' --debug-query -l js

# See what the pattern matches in files
sg -p '$X.map($F)' -l ts --json | jq '.[] | {file: .file, match: .text}'
```

### Language Auto-detection
```bash
# ast-grep infers language from file extensions
sg -p 'import $X from "$MOD"' ./src  # Works across .js, .ts, .jsx, .tsx
```

## Exploration Workflows

### Workflow 1: General Codebase Exploration

1. **Start with high-level patterns**
   ```bash
   # Find all class definitions
   sg -p 'class $NAME { $$$BODY }' -l ts ./src
   
   # Find all exported functions
   sg -p 'export function $NAME($$$PARAMS)' -l ts ./src
   
   # Find all async functions
   sg -p 'async function $NAME($$$PARAMS)' -l ts ./src
   ```

2. **Drill down into specific areas**
   ```bash
   # Find error handling patterns
   sg -p 'try { $$$TRY } catch ($ERR) { $$$CATCH }' -l ts ./src
   
   # Find specific API usage
   sg -p 'fetch($URL, $CONFIG)' -l ts ./src
   
   # Find React hooks usage
   sg -p 'use$HOOK($$$ARGS)' -l ts ./src/components
   ```

3. **Analyze relationships**
   ```bash
   # Find inheritance patterns
   sg -p 'class $CHILD extends $PARENT { $$$BODY }' -l ts ./src
   
   # Find imports and their usage
   sg -p 'import { $$$ITEMS } from "$MODULE"' -l ts ./src | head -20
   ```

### Workflow 2: Focused Exploration from Starting Point

When you have a specific file, function, or pattern to start from:

1. **Start from a known file**
   ```bash
   # Find all function calls in a specific file
   sg -p '$FUNC($$$ARGS)' -l ts ./src/services/user.ts
   
   # Find all method calls on a specific class instance
   sg -p 'userService.$METHOD($$$ARGS)' -l ts ./src/services/
   ```

2. **Expand to related code**
   ```bash
   # Find where a specific function is defined
   sg -p 'function fetchUserData($$$PARAMS)' -l ts ./src
   
   # Find all usages of that function
   sg -p 'fetchUserData($$$ARGS)' -l ts ./src
   
   # Find the context around usages
   sg -p 'const $X = fetchUserData($$$ARGS)' -l ts ./src
   ```

3. **Cross-reference patterns**
   ```bash
   # Find all database operations
   sg -p '$DB.$OP($$$ARGS)' -l ts ./src
   
   # Find specific database methods
   sg -p 'db.collection($COLL).$METHOD($$$ARGS)' -l ts ./src
   ```

### Workflow 3: Code Smell and Pattern Discovery

1. **Find potential issues**
   ```bash
   # Find console.log statements (should use logger)
   sg -p 'console.log($$$ARGS)' -l ts ./src
   
   # Find TODO/FIXME comments
   sg -p '// $COMMENT' --regex '(TODO|FIXME|HACK|XXX)' -l ts ./src
   
   # Find direct state mutations (React anti-pattern)
   sg -p '$STATE.$PROP = $VAL' -l ts ./src
   
   # Find eval or Function constructor usage
   sg -p 'eval($$$ARGS)' -l js ./src
   sg -p 'new Function($$$ARGS)' -l js ./src
   ```

2. **Discover inconsistent patterns**
   ```bash
   # Find both Promise.then and async/await usage (potential inconsistency)
   sg -p '.then($$$ARGS)' -l ts ./src
   sg -p 'await $EXPR' -l ts ./src
   
   # Find multiple error handling styles
   sg -p '.catch($$$ARGS)' -l ts ./src
   sg -p 'try { $$$BODY } catch' -l ts ./src
   ```

## Advanced Exploration Techniques

### Using Comby-style Matching
```bash
# Match any node multiple times with $$ or $$$ (zero or more)
sg -p 'function $NAME($$$PARAMS) { $$$BODY }' -l ts ./src

# Match at least one occurrence with $$+
sg -p 'const $VAR = $$$EXPRS;' -l ts ./src
```

### Extracting Specific Information
```bash
# Get just the filenames
sg -p 'TODO' -l ts --json ./src | jq -r '.[].file' | sort | uniq

# Get count of matches per file
sg -p 'console.log($$$ARGS)' -l ts --json ./src | jq -r '.[].file' | sort | uniq -c

# Get the actual matched code
sg -p 'function $NAME($$$PARAMS)' -l ts --json ./src | jq -r '.[].text' | head -20
```

### Multi-language Exploration
```bash
# Find similar patterns across languages
# Python class definitions
sg -p 'class $NAME($$$BASES):' -l py ./src

# JavaScript class definitions  
sg -p 'class $NAME { $$$BODY }' -l js ./src

# Rust struct definitions
sg -p 'struct $NAME { $$$FIELDS }' -l rs ./src
```

## Exploration Examples

### Example 1: Understanding a React Component Structure
```bash
# Find all React components (function components)
sg -p 'function $NAME($$$PROPS) { $$$BODY }' -l ts ./src/components

# Find all hook usages
sg -p 'use$HOOK($$$ARGS)' -l ts ./src/components

# Find state management
sg -p 'useState($$$ARGS)' -l ts ./src/components
sg -p 'useEffect($$$ARGS)' -l ts ./src/components

# Find prop usage
sg -p 'props.$PROP' -l ts ./src/components
```

### Example 2: Analyzing API Client Usage
```bash
# Find all API calls
sg -p 'api.$METHOD($URL, $$$CONFIG)' -l ts ./src

# Find specific endpoint usage
sg -p '$CLIENT.get("$ENDPOINT")' -l ts ./src

# Find error handling around API calls
sg -p 'try { $CLIENT.$METHOD($$$ARGS) } catch ($ERR) { $$$HANDLER }' -l ts ./src
```

### Example 3: Exploring Type Definitions
```bash
# Find all interfaces
sg -p 'interface $NAME { $$$BODY }' -l ts ./src

# Find all type aliases
sg -p 'type $NAME = $$$DEF' -l ts ./src

# Find exported types
sg -p 'export interface $NAME { $$$BODY }' -l ts ./src

# Find generic usage
sg -p '$TYPE<$GENERIC>' -l ts ./src
```

## Tips for Effective Exploration

1. **Start broad, then narrow**: Begin with general patterns, then add specificity
2. **Use --debug-query**: Understand how ast-grep interprets your patterns
3. **Inspect JSON output**: Use `--json | jq` for programmatic analysis
4. **Chain patterns**: Use multiple searches to build understanding layer by layer
5. **Save useful patterns**: Document patterns you use frequently
6. **Learn tree-sitter basics**: Understanding AST nodes helps write better patterns
7. **Use field names**: Reference specific AST node fields (e.g., `.name`, `.params`)

## Common Pattern Templates

```bash
# Function definitions
sg -p 'function $NAME($$$PARAMS) { $$$BODY }' -l ts

# Arrow functions
sg -p 'const $NAME = ($$$PARAMS) => $$$BODY' -l ts

# Method calls
sg -p '$OBJ.$METHOD($$$ARGS)' -l ts

# Import statements
sg -p 'import { $$$ITEMS } from "$MODULE"' -l ts
sg -p 'import $DEFAULT from "$MODULE"' -l ts

# Export statements
sg -p 'export { $$$ITEMS }' -l ts
sg -p 'export default $DEFAULT' -l ts

# Class methods
sg -p '$METHOD($$$PARAMS) { $$$BODY }' -l ts

# Variable declarations
sg -p 'const $NAME = $VALUE' -l ts
sg -p 'let $NAME = $VALUE' -l ts

# Control flow
sg -p 'if ($COND) { $$$THEN } else { $$$ELSE }' -l ts
sg -p 'for ($$$INIT; $COND; $$$UPDATE) { $$$BODY }' -l ts
sg -p 'while ($COND) { $$$BODY }' -l ts

# Error handling
sg -p 'try { $$$TRY } catch ($ERR) { $$$CATCH }' -l ts
sg -p 'throw new $ERROR($$$ARGS)' -l ts
```

## Output Formats

```bash
# Standard colorful output (default)
sg -p 'console.log($$$ARGS)' -l ts ./src

# JSON for programmatic processing
sg -p 'console.log($$$ARGS)' -l ts --json ./src | jq '.'

# Quiet mode (just exit code, no output)
sg -p 'console.log($$$ARGS)' -l ts --quiet ./src && echo "Found matches"
```

## Limitations

- Requires valid syntax (cannot parse files with syntax errors)
- Language must be specified or inferable from file extension
- Pattern must be valid code in the target language
- Complex multi-file patterns require rule files (see ast-grep-refactor skill)

## Integration

This skill is often used before the **ast-grep-refactor** skill:
1. Use this skill to explore and understand patterns
2. Use the refactor skill to transform those patterns

---

**Remember**: Exploration is iterative. Start with a hypothesis, search, refine your understanding, and search again with more specific patterns.
