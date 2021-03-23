function fish_user_key_bindings
  if type -q fzf_key_bindings
    fzf_key_bindings
  end
  
  
  #bind \cs __commandline_stash
  #bind \cS __commandline_pop
  bind \cs push-line
end

