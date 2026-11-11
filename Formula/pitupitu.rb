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
      url "https://github.com/klarluft/pitupitu/releases/download/v0.15.0/pitupitu-aarch64-apple-darwin.tar.gz"
      sha256 "d44bee8e701fd3ce305cfd8aacd834c06d452bd3284059488776c187db1028d4"
    end
    on_intel do
      url "https://github.com/klarluft/pitupitu/releases/download/v0.15.0/pitupitu-x86_64-apple-darwin.tar.gz"
      sha256 "724905fe8e7baa898dc42ab71877343d64234670fe3b680a59449b7fe3c24a3d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/klarluft/pitupitu/releases/download/v0.15.0/pitupitu-aarch64-unknown-linux-musl.tar.gz"
      sha256 "474ba8c6169f4500dd09b5ce7d0701ddbad32ce4352d0e2511429013aab7bf63"
    end
    on_intel do
      url "https://github.com/klarluft/pitupitu/releases/download/v0.15.0/pitupitu-x86_64-unknown-linux-musl.tar.gz"
      sha256 "c63b4f457d9e567ba2b4672170ce205352c7512c96398b36fcc0a22afbe92205"
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

      pitupitu runs your agents in herdr; setup offers to install it when
      it is missing. Keep herdr open in a terminal (run `herdr`) so
      pitupitu can reach your agents. After `brew upgrade pitupitu`, run `pitupitu setup` again so the
      service restarts on the new version. Before `brew uninstall pitupitu`,
      run `pitupitu uninstall` to remove the service.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pitupitu --version")
  end
end
