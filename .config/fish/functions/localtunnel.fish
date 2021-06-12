function localtunnel
    if type -q "(which lt)"
        fish -c (which lt)
    else
        echo "localtunnel is not installed" >2
    end
end
