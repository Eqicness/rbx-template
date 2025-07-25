# Roblox Project Template
Common Roblox project workflow. Useful project settings for vscode settings in [settings.json](.vscode/settings.json)

**Rokit** for tooling management, useful tools include ([rokit.toml](rokit.toml)):
  - rojo: **essential**
  - luau-lsp: **essential**, handles luau in an external editor (vscode)
  - wally: **essential**, package management
  - darklua: very useful for producitivity - supports string requires for automatic library importing, cleans up code (luau-lsp/selene should already have you writing clean code)
  - stylua: very useful for automatic formatting & consistent styling
  - wally-package-types: useful fix for wally & luau
  - lune: useful for running luau code outside of studio but cannot access roblox datamodel so moreso for utility testing

**Wally** packages notes ([wally.toml](wally.toml)):
  - binders/observers
  - trove/janitor/maid: cleanup, i use this everywhere & constantly
  - fusion for ui (roact is cool, fusion is dynamic)
  - future/promises
  - signals (or simpler callback models)
  - comm is cool for replication, regular events are fine, use whatever works for you
  - profilestore: super easy data management, it's been battle tested. i typically use this with Rodux but there are better, newer state management libraries that play nicer with Luau types. important to have some sort of declarative/failsafe management & typing for any kind of saved data.

## Opinion on Frameworks
- Not very useful. Best to use a simple loader utility if necessary, but super easy to use autoimports & just manage things granularly. Best coding practice is to think about how easy it will be to remove/swap out a part of the code. keep systems as self-contained as possible, but don't waste time on the *perfect* structure. Use scripts to run processes, use modules with Init/Start methods called by a runner if they need to be used.

## Utility scripts:
(originally derived from [grillme99](https://github.com/grilme99/roblox-project-template)):
- `(windows/ubuntu)-dev.sh`: serve the darklua processed project using rojo. use this instead of rojo serve.

## String requires
- Very useful for autoimporting files & speeding up workflows
- Sources must be defined both in [darklua](.darklua.json)  and [.luaurc](.luaurc)