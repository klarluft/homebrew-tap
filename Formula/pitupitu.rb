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
      url "https://github.com/klarluft/pitupitu/releases/download/v0.11.0/pitupitu-aarch64-apple-darwin.tar.gz"
      sha256 "3fea88987f3e32d2f7009ab9757e2a0872284d1ffeafc65b530c95cff5e24dc3"
    end
    on_intel do
      url "https://github.com/klarluft/pitupitu/releases/download/v0.11.0/pitupitu-x86_64-apple-darwin.tar.gz"
      sha256 "055bc968dd0ce11c3f8b77b4a20ef544824d875b8094a441a2393db349828fc0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/klarluft/pitupitu/releases/download/v0.11.0/pitupitu-aarch64-unknown-linux-musl.tar.gz"
      sha256 "bf720b3d1c586681ae5c614a7fdf61777debca3218df53f16c916a12a4d60337"
    end
    on_intel do
      url "https://github.com/klarluft/pitupitu/releases/download/v0.11.0/pitupitu-x86_64-unknown-linux-musl.tar.gz"
      sha256 "a42458f8b0bc68bf0f2ae8cddad0197e027c5118595494960a4d4c811536cc30"
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
