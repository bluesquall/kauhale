function b2-restic
  set repo $argv[1]
  set --erase argv[1]

  set -lx RESTIC_REPOSITORY ( pass restic/b2/$repo | sed -n 's/^RESTIC_REPOSITORY=//p' )
  set -lx RESTIC_PASSWORD ( pass restic/b2/$repo | sed -n 's/^RESTIC_PASSWORD=//p' )
  set -lx B2_ACCOUNT_KEY ( pass restic/b2/$repo | sed -n 's/^B2_ACCOUNT_KEY=//p' )
  set -lx B2_ACCOUNT_ID ( pass restic/b2/$repo | sed -n 's/^B2_ACCOUNT_ID=//p' )

  restic $argv
end
