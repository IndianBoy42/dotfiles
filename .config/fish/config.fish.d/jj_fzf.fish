# ---------------------------------------------------------
# 1. Helper Functions (JJ Logic)
# ---------------------------------------------------------

set -g default_jj_pick 'all()'

# Helper to format JJ log output for FZF
function _jj_log_fmt
    # $argv[1] is the revset to query
    set -l revset $argv[1]

    # Template: change_id | commit_id | author | timestamp | bookmarks | description
    set -l template 'separate(" ", change_id.shortest(12), commit_id.shortest(12), author.email(), format_timestamp(committer.timestamp), bookmarks, description.first_line()) ++ "\n"'

    jj log -r "$revset" --no-graph --color=always -T $template
end

# A generic picker that takes a revset, shows fzf, and prints the Change ID
function _pick_jj_rev
    set -l revset $argv[1]
    set -l header $argv[2]

    _jj_log_fmt "$revset" | fzf --ansi --reverse --header "$header" --preview 'jj show --color=always {1}' | awk '{print $1}'
end

# ---------------------------------------------------------
# 2. The Smart Implementations
# ---------------------------------------------------------

# --- LOG PICKER (Ctrl+Alt+L) ---
function _smart_fzf_log
    if type -q jj; and jj root >/dev/null 2>&1
        # In JJ: Show all reachable commits
        set -l result (_pick_jj_rev $default_jj_pick "Select Revision (JJ Log)")
        if test -n "$result"
            commandline -i -- $result
        end
        commandline -f repaint
    else
        # Fallback: fzf.fish git log
        if functions -q _fzf_search_git_log
            _fzf_search_git_log
        end
    end
end

# --- STATUS PICKER (Ctrl+Alt+S) ---
function _smart_fzf_status
    if type -q jj; and jj root >/dev/null 2>&1
        # In JJ: Show diff summary
        set -l result (jj diff --summary --color=always | \
            fzf --ansi --reverse --header "Select changed file" --preview 'jj diff --color=always {2}' | \
            awk '{print $2}')

        if test -n "$result"
            commandline -i -- $result
        end
        commandline -f repaint
    else
        # Fallback: fzf.fish git status
        if functions -q _fzf_search_git_status
            _fzf_search_git_status
        end
    end
end

# --- BRANCH/BOOKMARK PICKER (Ctrl+Alt+B) ---
function _smart_fzf_branches
    if type -q jj; and jj root >/dev/null 2>&1
        # In JJ: Select from Bookmarks (local & remote) and Tags
        # We search for anything that is a bookmark or a tag
        set -l result (_pick_jj_rev "bookmarks() | tags()" "Select Bookmark/Tag")

        if test -n "$result"
            commandline -i -- $result
        end
        commandline -f repaint
    else
        # Fallback: fzf.fish git branches/tags
        # Note: fzf.fish usually doesn't expose a combined function, 
        # so we default to the standard git branch search.
        if functions -q _fzf_search_git_status
            # fzf.fish doesn't have a public function for branches usually, 
            # but it binds it to Ctrl+G. We can reuse the logic or just run the command.
            # Here is a manual implementation for standard Git:
            git branch --all --color=always --format='%(refname:short)' | fzf --ansi --reverse --header "Select Git Branch" --preview 'git log --oneline --graph --color=always {} | head -20' | read -l git_result

            if test -n "$git_result"
                commandline -i -- $git_result
            end
            commandline -f repaint
        end
    end
end

# --- CONFLICTS PICKER (Ctrl+Alt+C) ---
function _smart_fzf_conflicts
    if type -q jj; and jj root >/dev/null 2>&1
        # In JJ: List files that require resolution in the current working copy
        # We use 'jj cat' for preview so you can see the <<<< >>>> markers
        set -l result (jj resolve --list | \
            fzf --ansi --reverse --header "Select Conflicted File" \
                --preview 'bat --color=always {}' \
        )

        if test -n "$result"
            commandline -i -- $result
        end
        commandline -f repaint
    else
        # Fallback: Git (using diff --name-only --diff-filter=U)
        set -l git_conflicts (git diff --name-only --diff-filter=U)
        if test -n "$git_conflicts"
            set -l result (echo "$git_conflicts" | \
                fzf --ansi --reverse --header "Select Conflicted File (Git)" \
                    --preview 'git diff --color=always {}' \
            )
            if test -n "$result"
                commandline -i -- $result
            end
        end
        commandline -f repaint
    end
end

# ---------------------------------------------------------
# 3. The General Revset Picker
# ---------------------------------------------------------

# Usage: jjpick "author(me)"
# Usage: jjpick "trunk().."
function jjpick --description "Pick a revision from a specific JJ revset"
    set -l revset $argv[1]

    if test -z "$revset"
        # Default to all if no argument provided
        set revset $default_jj_pick
    end

    if not type -q jj; or not jj root >/dev/null 2>&1
        echo "Error: Not in a jj repository"
        return 1
    end

    set -l result (_pick_jj_rev "$revset" "Picking from revset: $revset")

    if test -n "$result"
        commandline -i -- $result
    end
    commandline -f repaint
end

# ---------------------------------------------------------
# 4. Key Bindings
# ---------------------------------------------------------

function jj_obslog
    jj obslog --no-graph --color=always \
        -T 'separate(" ", change_id.shortest(12), commit_id.shortest(12), description.first_line()) ++ "\n"' | fzf --ansi --reverse --preview 'jj show --color=always {2}'
end

function jj_bookmarks
    jjpick "bookmarks()"
    # jj log -r "bookmarks() | tags()" --no-graph --color=always \
    #     -T 'separate(" ", bookmarks, tags, change_id.shortest(12), description.first_line()) ++ "\n"' | fzf --ansi --reverse --preview 'jj show --color=always {3}' | awk '{print $3}'
end

function jj_conflict_revs
    jjpick "conflicts()"
    # jj log -r "conflicts()" --no-graph --color=always \
    #     -T 'separate(" ", change_id.shortest(12), description.first_line()) ++ "\n"' | fzf --ansi --reverse --header "Select a conflict to edit" --preview 'jj show --color=always {1}' | awk '{print $1}'
end

function fzf_jj_fish_bindings
    # Ctrl+Alt+R -> General Revset Picker (Prompts for input)
    # This is a bit advanced: it inserts the function name so you can type the revset
    bind ctrl-alt-r "commandline -r 'jjpick \"\"'; commandline -C 8"

    # Bind Ctrl+Alt+L (Log) to the smart dispatcher
    bind ctrl-alt-l _smart_fzf_log

    # Bind Ctrl+Alt+S (Status) to the smart dispatcher
    bind ctrl-alt-s _smart_fzf_status

    # JJ Specifics (No git equivalent in fzf.fish, so we bind directly)
    # Ctrl+Alt+C for Conflicts
    bind ctrl-alt-c _smart_fzf_conflicts

    bind ctrl-alt-e "commandline -i (jj_obslog)"

    bind ctrl-alt-b _smart_fzf_branches
end
