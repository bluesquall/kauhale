{ sources, runCommand, git, symlinkJoin, makeWrapper, writeTextFile }:

let
  gitHome = writeTextFile {
    name = "git-config";
    text = builtins.replaceStrings[ "@GITIGNORE@" ][ "${./gitignore}" ](builtins.readFile ./config);
    destination = "./gitconfig";
  };
in
symlinkJoin {
  name = "git";
  buildInputs = [ makeWrapper ];
  paths = [ git ];
  postBuild = ''wrapProgram "$out/bin/git" --set HOME "${gitHome}"'';
}
