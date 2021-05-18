function bakrm --desc "Adds the sufix '.bak' (backup) to files, and deletes the original"
    for file in $argv
        mv $file $file.bak
    end
end
