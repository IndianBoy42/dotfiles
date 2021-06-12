function up -d "Go up till you get to a directory that contains the folder name that you've specified"
# https://gist.github.com/zlksnk/81a4993be410586c038f8b3fc140b1c7
  set -l dir_to_be_child $argv[1]

  if [ "$dir_to_be_child" = "" ]
    cd ..
  else
    cd -
    set -l alt_dir $PWD
    cd -
    set -l curr_dir $PWD

    set -l is_found 0
    while [ "$PWD" != "/" ]; and test $is_found -eq 0
      cd ..
      set -l res (find $dir_to_be_child -maxdepth 0 -type d 2>/dev/null | wc -l)
      if test $res -eq 1
        set is_found 1
      end
    end

    if [ "$PWD" = "/" ]
      cd $alt_dir
      cd $curr_dir
      echo "Couldn't find $dir_to_be_child"
      return 1
    end

    set -l found_dir $PWD
    cd $curr_dir
    cd $found_dir
  end
end
