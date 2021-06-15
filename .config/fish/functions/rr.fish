# Defined in /tmp/fish.C7b2pk/rr.fish @ line 2
function rr --wraps='curl -s -L https://raw.githubusercontent.com/keroserene/rickrollrc/master/roll.sh | bash'
  set PREV_OUTPUT (eval $history[1])
  set CMD $argv[1]
  echo "Running '$CMD $PREV_OUTPUT'"
  eval "$CMD $PREV_OUTPUT"
end
