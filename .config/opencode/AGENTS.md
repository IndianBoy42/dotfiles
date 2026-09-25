<common_mistakes>
Make sure to run servers and background processes as background tasks (nohup, etc), make sure to keep track of the pid to stop it later

don't try and run sudo commands, ask the user for one off commands or present a *minimal, clear and understandable* script to run.

don't use blind pkill, if an external server/process needs to be restarted ask the user

don't guess at APIs, protocols, libraries or anything, make sure your information is up to date. 

the user questioning a decision does not mean they are telling you to make the opposite decision, just carefully consider and answer the question, the user will tell you what the next steps are
</common_mistakes>

<tools>
Batch independent tool calls in parallel for efficiency. Sequential chaining is only for when calls depend on each other.

Don't try and workaround permissions using subagents. Don't ask 'apply this patch exactly', 'write this content to a file directly' or 'return the contents verbatim'. subagents are not tools they are agents for execution or work or meaningful transformation. Instead give them clear goals to do meaningful work for you.

`rtk` is a wrapper injected on certain commands to make the output of shell commands more efficient, do not question whether it is erroneous or retry without `rtk` (it will always be injected)
</tools>

<good_work>
Complete work fully. If you actually cannot finish a task, you must escalate with explicit reasoning rather than leaving stubs or TODOs and admit your incapability.

Return results directly to the user/parent agent. Only create files in the filesystem when explicitly asked.

if a subagent is interrupted or returns an empty response, retry it **ONLY ONCE** and ask it to finish its work or return the response in the format you need.

be DRY. when editing code minimize duplication, try and find the most targeted, focused, and elegant way to achieve the goal. 
</good_work>

<comments>
The primary use of comments in internal code is to explain WHY (in present tense) and HOW (if not obvious, prefer good structuring and naming to clarify how). Do not annotate changes with "changed X to Y" comments.

Comments can also guide the user in navigating codebases, talk about type systems, function call flow, etc. They can be used to clarify or summarize blocks of code to enhance readability


Doc comments are necessary for Functions and types meant to be used 'publically' (including internally but in a different file/module), illustrating how they should be used and how they fit in with the rest of the API
</comments>


<version_control>
Prefer to start from a clean working copy and maintain a clean history of changes with atomic commits (using jj or git)If you are doing anything outside of this basic (additive) workflow you must use load the `jujutsu` skill and be very careful. NEVER perform destructive edits to the history, ask the user for help using the question tool instead.
</version_control>

<python>
Prefer `uv` for python project management (pyproject.toml) and one-off execution (`uv run --with`) — it automatically manages virtual environments and dependencies. Only use alternatives when absolutely necessary.

Always use `uv run python`, `uv run pip` instead of bare `python/pip`. Do not use `pip install`, never use `--break-system-packages`.
</python>

<grounding>
Never assume or guess what you can instead find out. Self-reasoning and inherent knowledge is limited, searching up concrete, specific, and up to date knowledge is cheap.

use the websearch tools given to you. explore the systems and documentation available locally. use codemode for experimentation and checking. preferring trying things and checking than overthinking, overplanning and guessing what would happen.
 - when tasked with researching other opensource projects, clone them (shallow) to `/tmp/` for easier exploration. note this in your output so that future agents can make use of it
</grounding>


<interaction>
Use the question tool rather than ending your response with a question:
- the user get a notification which means the user can respond quicker
- Ask for clarifications on the request/task while planning
- Ask to test something that requires human interaction
- Ask to confirm completion, or what next steps should be
- ask to install tools/programs you require
</interaction>
