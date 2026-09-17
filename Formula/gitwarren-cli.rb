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
  desc "Code review for your own machines and your own agents, served on loopback"
  homepage "https://github.com/klarluft/gitwarren-app"
  version "0.1.16"
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
      url "https://github.com/klarluft/gitwarren-app/releases/download/v0.1.16/gitwarren-daemon-0.1.16-darwin-arm64.tar.gz"
      sha256 "f427f7cbc3d533cd297c1f5c31bfd9e934a15f517dfb53f9e95eba81ce3cefe9"
    end
    on_intel do
      url "https://github.com/klarluft/gitwarren-app/releases/download/v0.1.16/gitwarren-daemon-0.1.16-darwin-x64.tar.gz"
      sha256 "89aa87032b03c49c94a5d684d8c3f0370711b032a5bfc0957bcbfe50480279f9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/klarluft/gitwarren-app/releases/download/v0.1.16/gitwarren-daemon-0.1.16-linux-arm64.tar.gz"
      sha256 "a91fe4ee0d054c4814e27f8282ddf2909edce8e0b9f7d3ffc261099d222a12db"
    end
    on_intel do
      url "https://github.com/klarluft/gitwarren-app/releases/download/v0.1.16/gitwarren-daemon-0.1.16-linux-x64.tar.gz"
      sha256 "d80919571773d2fae7d5b58427ed8fac94a9147f3a069b5ab0ad736760d2bbc8"
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

  # Read once, at the moment someone has just installed this and does not yet
  # know what it is. So it answers the three questions that moment has - how
  # do I start it, how do I keep it running, how does my agent get in - in
  # that order, and says what each command does to the machine rather than
  # what it is called. The desktop app is last because a person who wanted it
  # has probably typed the wrong formula.
  def caveats
    <<~EOS
      To run GitWarren in this terminal and open it in your browser:

        gitwarren serve --open

      That serves on 127.0.0.1 only and stops when you press Ctrl-C. To keep
      GitWarren running in the background instead, starting now and again at
      every login:

        gitwarren service install       (undo with: gitwarren service uninstall)

      Either one also writes ~/.gitwarren/bin/gitwarren-mcp, the command a coding
      agent starts GitWarren's MCP server with. `gitwarren agent-setup` prints the
      sentence to give the agent. Reviews live in one SQLite file, and the MCP
      server reads it whether or not GitWarren is being served.

      Updating is `brew upgrade gitwarren-cli`, and `gitwarren update --check`
      will tell you when there is one. Before `brew uninstall gitwarren-cli`, run

        gitwarren uninstall

      which takes the login item and the two files in ~/.gitwarren/bin with it -
      brew does not know about either, and a launcher left pointing into a Cellar
      that is gone is how an agent ends up reporting that it cannot connect.
      `gitwarren doctor` says whether that has already happened.

      `gitwarren --help` lists everything. The desktop app is a separate package:

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
