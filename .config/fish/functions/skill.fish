function skill

# Soft kill the process
# Send signals with increasing strictness and damage to the process

  set posixSignal 1 15 2 9

  for sign in $posixSignal

    kill -0 $argv
    if test $status -eq 0
      echo "Sending -$sign SIGN to $argv PID"
      kill -1 $argv
      sleep 15
    end

  end

end
