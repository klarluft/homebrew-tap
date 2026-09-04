# klarluft/homebrew-tap

Homebrew casks for [GitWarren](https://gitwarren.com), a desktop app for local
code review of your own git repositories.

```bash
brew install --cask klarluft/tap/gitwarren
```

GitWarren updates itself once installed, so `brew upgrade` leaves it alone.
To have Homebrew move it forward instead, use `brew upgrade --greedy`.

The cask is kept current automatically: `.github/workflows/bump.yml` re-reads
the latest [release](https://github.com/klarluft/gitwarren-app/releases) and
rewrites the version and checksums. See `scripts/bump.sh`.
