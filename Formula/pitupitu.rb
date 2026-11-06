# The Homebrew formula for pitupitu, as a template.
#
# The release workflow fills in the version and the four checksums from the
# tarballs it has just built (`fill.sh` next to this file) and attaches the
# result to the release as `pitupitu.rb`. klarluft/homebrew-tap copies that
# file in as it is, so the formula and the binaries it points at come from
# the same run. Homebrew reads the version from the `v…` in the URLs.
class Pitupitu < Formula
  desc "Links this machine's coding agents to pitupitu, a voice foreman"
  homepage "https://pitupitu.chat"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/klarluft/pitupitu/releases/download/v0.14.2/pitupitu-aarch64-apple-darwin.tar.gz"
      sha256 "7d4e8d64d5f86fe4ff3c72cc222be60e14d3b1163edb56879d331d7ae44649cf"
    end
    on_intel do
      url "https://github.com/klarluft/pitupitu/releases/download/v0.14.2/pitupitu-x86_64-apple-darwin.tar.gz"
      sha256 "a1503349c16b58fdc5b3cdce759c45f5b6af1308f7f302b79ad2716642018f7e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/klarluft/pitupitu/releases/download/v0.14.2/pitupitu-aarch64-unknown-linux-musl.tar.gz"
      sha256 "81cbc1eff74a4804750708204426b1680ee5d592eb3121fa58141d6b0de5fc3e"
    end
    on_intel do
      url "https://github.com/klarluft/pitupitu/releases/download/v0.14.2/pitupitu-x86_64-unknown-linux-musl.tar.gz"
      sha256 "2e1fe79a472ef5f54e51a571ec957ccdcf1cf0cefbddde2f1a1100492c7ea19f"
    end
  end

  def install
    if OS.mac? && File.directory?("pitupitu.app")
      # The signed app: macOS remembers the person's privacy answers by its
      # identifier, which survives upgrades (the Cellar folder does not).
      prefix.install "pitupitu.app"
      bin.install_symlink prefix/"pitupitu.app/Contents/MacOS/pitupitu"
    else
      bin.install "pitupitu"
    end
  end

  def caveats
    <<~EOS
      To sign this machine in and start pitupitu now and at every login:

        pitupitu setup

      pitupitu runs your agents in herdr; setup installs it when it is
      missing. After `brew upgrade pitupitu`, run `pitupitu setup` again so the
      service restarts on the new version. Before `brew uninstall pitupitu`,
      run `pitupitu uninstall` to remove the service.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pitupitu --version")
  end
end
