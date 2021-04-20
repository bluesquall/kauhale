function ssh-copy-terminfo
  set remote $argv[1]

  infocmp | ssh $remote "cat > /tmp/terminfo && tic -x /tmp/terminfo; rm /tmp/terminfo"
end

