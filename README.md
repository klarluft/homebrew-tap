# klarluft/homebrew-tap

Homebrew packages for [GitWarren](https://gitwarren.com), code review for your
own git repositories and your own agents.

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
