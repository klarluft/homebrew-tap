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
      url "https://github.com/klarluft/pitupitu/releases/download/v0.10.0/pitupitu-aarch64-apple-darwin.tar.gz"
      sha256 "7717ca6e8a7bc5ff37b19fb3674e8be3261ae8fa0c34802282d3c81208a175a0"
    end
    on_intel do
      url "https://github.com/klarluft/pitupitu/releases/download/v0.10.0/pitupitu-x86_64-apple-darwin.tar.gz"
      sha256 "039874fbb9636be72ff7025ccdb919ebe8834eaef519236898bf1e5c87fb7671"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/klarluft/pitupitu/releases/download/v0.10.0/pitupitu-aarch64-unknown-linux-musl.tar.gz"
      sha256 "e316c45363d83db9274d6346623b4ba7d859a1e51e9a6750e2c6d1bb8ecafbff"
    end
    on_intel do
      url "https://github.com/klarluft/pitupitu/releases/download/v0.10.0/pitupitu-x86_64-unknown-linux-musl.tar.gz"
      sha256 "ba4d7b8b432bf2448de6a99e287b607fd58797e4e4ee3453ae63d9efa9acc1a3"
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
