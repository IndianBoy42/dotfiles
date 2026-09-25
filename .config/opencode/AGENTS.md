SHOULD prefer the builtin tools read, write, edit, grep, glob, list over the bash equivalents. 

ALWAYS batch tool calls as much as possible for efficiency.

NEVER create summary documents in the filesystem unless _explicitly_ asked to. Talk directly to the user/parent agent.

NEVER add comments describing what you changed to the code while changing. comments should provide context and describe WHY some code does what it does in the present tense

ALWAYS Check whether you are in a git repo `.git` or a jujutsu repo `.jj`, load the jujutsu skill if you are unsure of some operations. 
- Always maintain a clean history of changes with atomic commits
- Maintain the `.gitignore`

jujutsu specific:
 - create a new revision with its description *before* making changes
    1. Check the state of the repo `jj status` or `jj show` (for the full diff)
    2. if there are changes immediately `jj new` to start a new revision. this step is not necessary if the working copy is already clean
    3. with a clean working copy revision use `jj describe -m "message"` to state what you are _going to_ change (what the user asked)
    4. make the changes the user requests
       - in some cases (complex or compound tasks) you may create new revisions in between changes, always describe before editing files.
       - you may also edit the change description (commit message) afterwards using `jj describe -m "message"` or `jj describe --stdin`
    5. when the user says this change is done, or asks for a new unrelated change, you may `jj new` so that a new empty working copy revision is created.
       - it is important to use your judgement for when to create a new revision in a session. if the user requests a small followup/fix then it doesnt need a new revision. the jj history should be series of checkpoints: an easily readable and understandable history of 'real' changes to these documents
    - if you are delegating tasks to a subagent, the subagent should create the new revision
    - if you are spawning a batch of subagents (parallel) the commit will include all their changes, thus the primary agent should create it.

git specific:
 - Emulate the above workflow: always start a task with a clean working copy, commit with a descriptive message right after

ALWAYS Prefer to use `uv` for python project management and execution always (it automatically manages virtual environments and dependencies). Only do anything else if using uv is impossible.

Use the question tool freely, rather than ending your response with a question:
- I get a notification which means I can respond quicker
- you can ask for clarifications on the request/task/etc especially while planning
- you can ask me to test something that requires human interaction
- you can ask me to confirm that the tasks are completed properly, what next steps should be, etc.

Use `ast-grep` (via bash) for semantically exploring codebases more precisely for code relevant to your task

