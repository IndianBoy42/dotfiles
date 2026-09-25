# abbr g git
# # Alias all git aliases
# for al in (git config -l | grep '^alias\.' | cut -d'=' -f1 | cut -d'.' -f2)
#     abbr g$al "git $al"
# end
# abbr gdiff git diff
# TODO: switch to jj
abbr addup 'git add -u'
abbr addall 'git add .'
abbr branch 'git branch'
abbr checkout 'git checkout'
abbr clone 'git clone'
abbr commit 'git commit -m'
abbr fetch 'git fetch'
abbr pull 'git pull origin'
abbr push 'git push origin'
abbr tag 'git tag'
abbr newtag 'git tag -a'
abbr gits 'git s'
abbr gitf 'git f'

abbr gitall -- 'ls | xargs -P 0 -I{} git -C {} "$argv"'

abbr g git
abbr --command jj g git
abbr -a --command git --command yadm s status
abbr -a --command git --command yadm c commit
abbr -a --command git --command yadm cv "commit -v"
abbr -a --command git --command yadm f "fetch --all"
abbr -a --command git --command yadm a add
abbr -a --command git --command yadm u up
abbr -a --command git --command yadm d down
abbr -a --command git --command yadm sw switch
abbr -a --command git --command yadm addi "add --interactive"
abbr -a --command git --command yadm new "checkout -b"
abbr -a --command git --command yadm save "commit -av"
abbr -a --command git --command yadm save-all "add -A && git commit"
abbr -a --command git --command yadm wip "commit -am WIP"
abbr -a --command git --command yadm undo "reset HEAD~1 --mixed"
abbr -a --command git --command yadm amend "commit --amend"
abbr -a --command yadm sync "fetch && git pull --ff-only && git push -u origin HEAD"
# abbr -a --command git --command yadm down "pull --rebase --prune $@ && git submodule update --init --recursive"
abbr -a --command git --command yadm up "push -u origin HEAD"
abbr -a --command git --command yadm ec "config --global -e"
abbr -a --command git --command yadm unstage "restore --staged"
abbr -a --command git --command yadm list-aliases "config -l | grep alias | cut -c 7-"
abbr -a --command git --command yadm ra "remote add"
abbr -a --command git --command yadm rao "remote add origin"
abbr -a --command git --command yadm clean-merged "branch --merged | grep -v \"\\*\" | xargs -n 1 git branch -d"
abbr -a --command git --command yadm sm submodule
abbr -a --command git --command yadm root "rev-parse --show-toplevel"
abbr -a --command git --command yadm pre-pull "diff @ @{upstream}"
abbr -a --command git --command yadm any-changes "diff --no-ext-diff --quiet --exit-code"
abbr -a --command git --command yadm untracked "ls-files . --exclude-standard --others"
abbr -a --command git --command yadm tracked "ls-tree -r HEAD --name-only "
abbr -a --command git --command yadm staged "diff --staged"
abbr -a --command git --command yadm partial-clone "clone --filter=blob:none"
abbr -a --command git --command yadm shallow-clone "clone --filter=tree:0"
abbr -a --command git --command yadm unshallow "fetch --unshallow"
abbr -a --command git --command yadm fork-point "merge-base --fork-point origin/master"
abbr -a --command git --command yadm autosquash "rebase -i --autosquash"
abbr -a --command git --command yadm diff1 "diff HEAD~1 HEAD"
abbr -a --command git --command yadm dft difftool
abbr -a --command git --command yadm dft1 "difftool HEAD~1 HEAD"
abbr -a --command git --command yadm dp "diff @{1} HEAD"

# TODO: auto add jj aliases for these
