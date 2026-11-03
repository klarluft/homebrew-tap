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
      url "https://github.com/klarluft/pitupitu/releases/download/v0.10.1/pitupitu-aarch64-apple-darwin.tar.gz"
      sha256 "6a8485d1e310884769f9c63158414733361d84ebda247f0c484e562ff809d4c6"
    end
    on_intel do
      url "https://github.com/klarluft/pitupitu/releases/download/v0.10.1/pitupitu-x86_64-apple-darwin.tar.gz"
      sha256 "db0b6b105fbd30e94fc4591f70e2d5fe4d89e71cb782a4b8a5cc8045228ffe39"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/klarluft/pitupitu/releases/download/v0.10.1/pitupitu-aarch64-unknown-linux-musl.tar.gz"
      sha256 "61205e6cea2591baa6fe837f02109ed1d860e0ede47d9768edf649cb6893e401"
    end
    on_intel do
      url "https://github.com/klarluft/pitupitu/releases/download/v0.10.1/pitupitu-x86_64-unknown-linux-musl.tar.gz"
      sha256 "158191d58e4880fa602e4c995163ed131e4f4326257a246beafc62291ce244ee"
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
