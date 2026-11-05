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
      url "https://github.com/klarluft/pitupitu/releases/download/v0.12.1/pitupitu-aarch64-apple-darwin.tar.gz"
      sha256 "1cb6725577a702b56e3e6e959e5d9ee8c7e8b73a6ba509e5bee73aa0209b4fc4"
    end
    on_intel do
      url "https://github.com/klarluft/pitupitu/releases/download/v0.12.1/pitupitu-x86_64-apple-darwin.tar.gz"
      sha256 "d7141e87413bb0090854cec7f6cbf3c5942b7f85f42c17a3f234a7adc57ba825"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/klarluft/pitupitu/releases/download/v0.12.1/pitupitu-aarch64-unknown-linux-musl.tar.gz"
      sha256 "bfdb521effdee8ecffbd8e3b502b344b415f327d7acd3bbdba1aa62eb39b6000"
    end
    on_intel do
      url "https://github.com/klarluft/pitupitu/releases/download/v0.12.1/pitupitu-x86_64-unknown-linux-musl.tar.gz"
      sha256 "73b0a6dc4d81342c4181afe88fa963e50db14b307f93253380e489581ce1213e"
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
