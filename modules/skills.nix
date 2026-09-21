{
  config,
  lib,
  ...
}:

let
repoDir = "${config.home.homeDirectory}/dotfiles";

# Add new skill names here as they're added.
skillNames = [
  "handoff"
  "teach"
  "i-have-adhd"
];

# Recursively list files (relative paths) under a directory.
listFilesRec =
dir: relPrefix:
lib.concatLists (
  lib.mapAttrsToList (
    name: type:
    let
    path = dir + "/${name}";
    rel = if relPrefix == "" then name else "${relPrefix}/${name}";
    in
    if type == "directory" then listFilesRec path rel else [ rel ]
  ) (builtins.readDir dir)
);

# Destination dirs (under $HOME) that should mirror .agents/skills, per-file.
destDirs = [
  ".claude/skills"
  ".agents/skills"
];

# Per-file symlinks avoid polluting the repo with tool-written extras.
mkSkillLinks =
destDir: skillName:
let
skillDir = ../.agents/skills + "/${skillName}";
in
lib.listToAttrs (
  map (rel: {
      name = "${destDir}/${skillName}/${rel}";
      value.source = config.lib.file.mkOutOfStoreSymlink "${repoDir}/.agents/skills/${skillName}/${rel}";
  }) (listFilesRec skillDir "")
);
in
{
  home.file = lib.mkMerge (
    lib.concatMap (destDir: map (mkSkillLinks destDir) skillNames) destDirs
  );
}
