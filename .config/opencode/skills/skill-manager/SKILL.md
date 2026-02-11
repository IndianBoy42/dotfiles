---
name: skill-manager
description: Find existing Agent Skills from marketplaces or write new SKILL.md files following best practices. Use when user asks to create a skill, find skills for a task, or improve existing skills.
---

# Skill Manager

## When to Find vs Write

### Find Existing Skills First
Before writing, search these sources in order:
1. **SkillsMP** (skillsmp.com): 160K+ skills, best coverage
2. **Agent Skills Hub** (agentskillshub.dev): 458+ verified, security-graded
3. **GitHub collections**:
   - anthropics/skills (official Anthropic skills)
   - VoltAgent/awesome-agent-skills (curated aggregator)

### Write New Skills When
- No existing skill matches the specific domain/workflow
- Existing skills are too generic or outdated
- User has unique project-specific conventions

## Writing New Skills

### File Structure
Create in `.agents/skills/<skill-name>/SKILL.md`:
```
.agents/skills/
└── <skill-name>/
    ├── SKILL.md (required)
    ├── scripts/ (optional)
    └── references/ (optional)
```

For globals skills put it in `~/.agents/skills`

### SKILL.md Template
```markdown
***
name: kebab-case-name
description: What it does AND when to use it. Include trigger keywords users might say.
***

# Skill Title

## When to Use
[1-2 sentences: specific scenarios that trigger this skill]

## Process/Workflow
[Numbered steps or bullet points, NOT walls of text]
1. First action with specific details
2. Second action with concrete examples
3. Final output or validation step

## Key Patterns
[Common approaches, code patterns, or configurations]
- Pattern 1: Brief explanation
- Pattern 2: With example

## Anti-Patterns to Avoid
[Common mistakes specific to this domain]
- What NOT to do and why

## Output Format
[Expected structure of deliverable: code, config, documentation]
```

### Writing Effective Descriptions
The description determines when the skill activates. Include:
- **What**: Core capability (e.g., "Debug REST API errors")
- **When**: Trigger scenarios (e.g., "Use when API requests return 4xx/5xx codes")
- **Keywords**: Terms users might say (e.g., "authentication", "rate limiting")

**Examples:**
- ✅ "Configure Kubernetes deployments with health checks and resource limits. Use when deploying apps to K8s or debugging pod crashes."
- ✅ "Write pytest fixtures and parameterized tests. Use when creating Python unit tests or refactoring test code."
- ❌ "Helps with testing" (too vague)

### Body Content Guidelines

**Be Concise**: Every token competes for context space
- Assume the AI is intelligent
- Use code snippets over lengthy explanations
- Focus on domain-specific knowledge, not general programming

**Structure Over Prose**
- Use headings (##, ###) to organize sections
- Bullet points for lists of items
- Numbered lists for sequential processes
- Code blocks for concrete examples

**Specificity Levels**
- **Open-ended tasks** (design, architecture): Provide flexible guidance
- **Critical operations** (database migrations, deployments): Give strict step-by-step instructions
- **Repetitive tasks** (boilerplate, configs): Include complete templates

**Include Examples**
Show expected outputs:
```python
# Example: Good error handling pattern
try:
    response = requests.get(url, timeout=5)
    response.raise_for_status()
except requests.Timeout:
    logger.error(f"Timeout connecting to {url}")
    return None
except requests.HTTPError as e:
    logger.error(f"HTTP {e.response.status_code}: {e.response.text}")
    raise
```

### Validation Checklist

Before finalizing, verify:
- [ ] Description includes both "what" and "when"
- [ ] Name is kebab-case and descriptive (not too broad)
- [ ] Body is <500 words unless complexity requires more
- [ ] Contains concrete examples or code snippets
- [ ] Organized with clear section headings
- [ ] No repetition between sections
- [ ] Covers edge cases and error handling
- [ ] Specifies expected output format

## Testing Skills

### Test Activation
Verify the skill triggers correctly:
1. Create test prompts that should activate the skill
2. Create test prompts that should NOT activate it
3. Confirm description keywords match user vocabulary

### Test Instructions
Run through the skill workflow:
1. Follow each step in the Process section
2. Verify examples compile/run correctly
3. Check that output matches specified format
4. Test with edge cases mentioned in the skill

### Iteration Process
1. Write minimal viable skill (description + basic workflow)
2. Test with 2-3 representative prompts
3. Identify gaps or unclear instructions
4. Add specific examples for confusing steps
5. Remove unnecessary verbosity
6. Retest until consistent quality

## When to Add Scripts

Prefer instructions over scripts unless you need:
- **Deterministic behavior**: Exact output format required
- **External tooling**: Calling specialized CLI tools
- **Complex logic**: Multi-step conditional workflows
- **Error recovery**: Robust handling of edge cases

Scripts add complexity but provide reliability for precision-critical operations.

## Common Mistakes to Avoid

1. **Too broad**: "developer-tools" → Split into "git-helper", "docker-compose", etc.
2. **Vague description**: "Helps with APIs" → "Debug REST API authentication and rate limiting errors"
3. **Explaining basics**: Don't teach what the AI already knows (e.g., explaining what Git is)
4. **No examples**: Include at least one concrete code/config example
5. **Flat structure**: Use headings, not a wall of paragraphs
6. **Missing "when"**: Description must say when to use it, not just what it does

## Output Format

When **finding skills**, provide:
- Skill name and source (with URL)
- Security grade if available (Agent Skills Hub)
- GitHub stars/activity metrics
- Installation command
- Brief description of what it does

When **writing skills**, provide:
- Complete SKILL.md file ready to save
- Suggested file path (`.github/skills/name/SKILL.md`)
- Brief explanation of what scenarios will trigger it
- 2-3 test prompts to verify activation
