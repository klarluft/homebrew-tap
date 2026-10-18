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
      url "https://github.com/klarluft/pitupitu/releases/download/v0.3.2/pitupitu-aarch64-apple-darwin.tar.gz"
      sha256 "53568893c4b4b0e51cf8087adb7370dbe685285f4ea6c3fc3d43d41f9a4d193e"
    end
    on_intel do
      url "https://github.com/klarluft/pitupitu/releases/download/v0.3.2/pitupitu-x86_64-apple-darwin.tar.gz"
      sha256 "d217c4b33d820227807a401274afc05dd14bead9b52c088d93eb9c588e123344"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/klarluft/pitupitu/releases/download/v0.3.2/pitupitu-aarch64-unknown-linux-musl.tar.gz"
      sha256 "74a063658d4ccc64538f9c6a94cd06ee7c393ef6a4a7e166c8dac46380cc31cc"
    end
    on_intel do
      url "https://github.com/klarluft/pitupitu/releases/download/v0.3.2/pitupitu-x86_64-unknown-linux-musl.tar.gz"
      sha256 "88c2bb1b6bdf9297a5a41801e74f495ee3284aa24b9ceadbb6a1eed995966291"
    end
  end

  def install
    bin.install "pitupitu"
  end

  def caveats
    <<~EOS
      To sign this machine in and start pitupitu now and at every login:

        pitupitu setup

      After `brew upgrade pitupitu`, run `pitupitu setup` again so the
      service restarts on the new version. Before `brew uninstall pitupitu`,
      run `pitupitu uninstall` to remove the service.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pitupitu --version")
  end
end
