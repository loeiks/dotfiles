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

  # Agents whose skills should mirror the repo's .agents/skills, per skill.
  destDirs = [
    ".claude/skills"
    ".agents/skills"
  ];

  # Per-skill out-of-store symlinks. Every skill under each destDir points at
  # the same repo folder, so there is a single source of truth with no
  # per-agent copies and no whole-folder takeover.
  skillLinks = lib.listToAttrs (
    lib.concatMap (
      destDir:
      map (skillName: {
          name = "${destDir}/${skillName}";
          value = {
            source = config.lib.file.mkOutOfStoreSymlink "${repoDir}/.agents/skills/${skillName}";
            force = true;
          };
      }) skillNames
    ) destDirs
  );
in
{
  home.file = skillLinks;
}