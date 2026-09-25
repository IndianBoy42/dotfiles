# for dev in (tailscale status | awk '/^100\./ {print $2}')
#     abbr --command ssh --command kitten --command opencode -a tssh-$dev "ssh $dev"
# end
