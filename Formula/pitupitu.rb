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
      url "https://github.com/klarluft/pitupitu/releases/download/v0.7.1/pitupitu-aarch64-apple-darwin.tar.gz"
      sha256 "3017362f622ead4120349c3bb5fb760e3e153880928a053aa1a4f629b5bfe085"
    end
    on_intel do
      url "https://github.com/klarluft/pitupitu/releases/download/v0.7.1/pitupitu-x86_64-apple-darwin.tar.gz"
      sha256 "0ca4285afa52ef6cad44d0a5e1dde8884837e3edc35f725673a0c9fb63ea0fee"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/klarluft/pitupitu/releases/download/v0.7.1/pitupitu-aarch64-unknown-linux-musl.tar.gz"
      sha256 "bd474a719551dea9224946c115c2e853c2b59310a0177ffcf86c4d82de3a9ae8"
    end
    on_intel do
      url "https://github.com/klarluft/pitupitu/releases/download/v0.7.1/pitupitu-x86_64-unknown-linux-musl.tar.gz"
      sha256 "7f394f02e07d1e89c9d4e4b3d03fbef78d4809e791faf430fcd9e5aa501e062e"
    end
  end

  def install
    bin.install "pitupitu"
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
