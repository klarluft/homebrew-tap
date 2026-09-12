# GitWarren's Homebrew formula, as a template.
#
# `scripts/build-homebrew-formula.mjs` fills in the version and the four
# checksums from tarballs that have actually been built, and the release
# workflow attaches the result to the release as `gitwarren-cli.rb`. The tap at
# klarluft/homebrew-tap copies that file in rather than computing anything of
# its own, so the formula and the thing it points at are produced by the same
# run and cannot describe different bits.
#
# ## Why `gitwarren-cli` rather than `gitwarren`
#
# The cask is already `klarluft/tap/gitwarren` and it stays that way: it is the
# app, it is what the README's first line installs, and a token that has been
# handed out is not free to move. A formula with the same token in the same tap
# would make `brew install klarluft/tap/gitwarren` ambiguous, which Homebrew
# resolves in favour of the formula - quietly turning the documented way to get
# the app into a way to get the command line instead.
#
# So the *tokens* differ and the *binary* does not: this installs a command
# called `gitwarren`, because that is what every other file in this repository
# calls it. A user types `brew install klarluft/tap/gitwarren-cli` once and then
# never sees the suffix again.
class GitwarrenCli < Formula
  desc "Local-only code review for your git repositories, served on loopback"
  homepage "https://github.com/klarluft/gitwarren-app"
  version "0.1.7"
  license "GPL-3.0-or-later"

  # Four bottles that are not bottles: each is the self-contained tarball from
  # spike S3, carrying its own Node and its own better-sqlite3 prebuild. There
  # is nothing to compile and no dependency to declare, which is why this
  # formula has no `depends_on` at all - deliberately, including no
  # `depends_on "node"`. A daemon whose Node can be upgraded out from under its
  # native addon by an unrelated `brew upgrade` is a bug report waiting to
  # happen, and the tarball exists precisely so that cannot occur.
  on_macos do
    on_arm do
      url "https://github.com/klarluft/gitwarren-app/releases/download/v0.1.7/gitwarren-daemon-0.1.7-darwin-arm64.tar.gz"
      sha256 "542caaa530d8292be79c0c6a6eb6868eadfa60e675790549be52b901bc2bd3a1"
    end
    on_intel do
      url "https://github.com/klarluft/gitwarren-app/releases/download/v0.1.7/gitwarren-daemon-0.1.7-darwin-x64.tar.gz"
      sha256 "82787bf36afe9290ae29c9e8366eb9e990efa6c6d8fa64bf324310e79f0160b6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/klarluft/gitwarren-app/releases/download/v0.1.7/gitwarren-daemon-0.1.7-linux-arm64.tar.gz"
      sha256 "87f3b84e5129df154d1fdcc6abaa3a846bb9e25b37d15a19907d0f431d7d2091"
    end
    on_intel do
      url "https://github.com/klarluft/gitwarren-app/releases/download/v0.1.7/gitwarren-daemon-0.1.7-linux-x64.tar.gz"
      sha256 "e7886e00fdf9e72e03dfd37dd95b300591120c0cbe738a6e1877f735a06c20bc"
    end
  end

  def install
    # The tarball's single root directory is stripped by Homebrew before this
    # runs, so what is here is bin/, lib/, drizzle/ and web/. They go into
    # libexec together because the launchers find every one of them relative to
    # their own location - splitting them across Homebrew's prefixes would
    # break that, and there is nothing in here another formula should link
    # against anyway.
    libexec.install Dir["*"]

    # Symlinks rather than copies, and the launchers follow them: `bin/gitwarren`
    # in the tarball resolves `$0` through a `readlink` loop before computing
    # where it is. See the preamble in scripts/build-daemon-tarball.mjs - without
    # that loop this line is exactly what breaks.
    bin.install_symlink libexec/"bin/gitwarren"
    bin.install_symlink libexec/"bin/gitwarren-mcp"
  end

  def caveats
    <<~EOS
      GitWarren serves its web view on 127.0.0.1 only:

        gitwarren serve         start it, and print a URL carrying this launch's token
        gitwarren open          open that URL in your browser
        gitwarren service install   start it at login, and write the agent launcher

      `service install` also writes ~/.gitwarren/bin/gitwarren-mcp, which is the
      one command to point an agent at. The desktop app is a separate package:

        brew install --cask klarluft/tap/gitwarren
    EOS
  end

  test do
    # `--version` is the one subcommand that touches no database, binds no port
    # and writes nothing, which is what makes it the right thing to assert on in
    # a sandbox that has none of those.
    assert_match version.to_s, shell_output("#{bin}/gitwarren --version")

    # That the bundled Node can load the native addon is the thing most likely
    # to be wrong in a tarball, and it is not covered by the line above.
    # `serve --stdio` opens the database, runs the migrations and answers one
    # framed request, so a single round trip exercises all of it.
    output = pipe_output(
      "#{bin}/gitwarren serve --stdio",
      "{\"id\":1,\"method\":\"repositories.list\"}\n",
    )
    assert_match "\"id\":1", output
  end
end
