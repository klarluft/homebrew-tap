# klarluft/homebrew-tap

Homebrew packages for [GitWarren](https://gitwarren.com), code review for your
own git repositories and your own agents, and for the
[pitupitu](https://pitupitu.chat) box agent.

## GitWarren

The desktop app, as a cask:

```bash
brew install --cask klarluft/tap/gitwarren
```

The command line, as a formula — the same review UI served into a browser tab,
for macOS and Linux, with its own Node inside:

```bash
brew install klarluft/tap/gitwarren-cli
gitwarren serve --open
```

The tokens differ so the first line keeps meaning the app; the command the
formula installs is called `gitwarren`. `gitwarren --help` lists what it does,
and [Installing GitWarren](https://gitwarren.com/docs/install) explains it.
Without Homebrew, `curl -fsSL https://gitwarren.com/install.sh | sh` installs
the same tarball.

GitWarren.app updates itself once installed, so `brew upgrade` leaves the cask
alone; `brew upgrade --greedy` moves it forward. The command line has no
updater, so `brew upgrade gitwarren-cli` is how it moves.

Both are kept current automatically: `.github/workflows/bump.yml` re-reads the
latest [release](https://github.com/klarluft/gitwarren-app/releases), rewrites
the cask's version and checksums, and copies in the `gitwarren-cli.rb` that
release attached. See `scripts/bump.sh`.

## pitupitu

The box agent that links a machine's coding agents to pitupitu, for macOS and
Linux:

```bash
brew install klarluft/tap/pitupitu
pitupitu setup
```

`setup` signs the machine in and starts a user service (launchd or systemd).
After `brew upgrade pitupitu`, run `pitupitu setup` again so the service
restarts on the new binary; before `brew uninstall pitupitu`, run
`pitupitu uninstall`.

`.github/workflows/bump-pitupitu.yml` copies the `pitupitu.rb` that each
[release](https://github.com/klarluft/pitupitu/releases) attaches, every six
hours or when run by hand. See `scripts/bump-pitupitu.sh`.
