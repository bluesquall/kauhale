self: super: {
  st = super.st.overrideAttrs (old: {
    patches = (old.patches or []) ++ [
      (super.fetchpatch {
        url = "https://st.suckless.org/patches/solarized/st-solarized-both-0.8.4.diff";
        sha256 = "0qsjj1xsp7s9gig44w90lbq8q725sbmlq197qv09j947cbf49j0d";
      })
      (super.fetchpatch {
        url = "https://st.suckless.org/patches/clipboard/st-clipboard-0.8.3.diff";
        sha256 = "1h1nwilwws02h2lnxzmrzr69lyh6pwsym21hvalp9kmbacwy6p0g";
      })

    ];
  });
}
