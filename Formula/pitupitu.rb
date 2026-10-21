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
      url "https://github.com/klarluft/pitupitu/releases/download/v0.6.0/pitupitu-aarch64-apple-darwin.tar.gz"
      sha256 "a0fd9885bfa952cff6ef207a4cfad8be7f74655bf990f5e8c5390caa7d4af3c2"
    end
    on_intel do
      url "https://github.com/klarluft/pitupitu/releases/download/v0.6.0/pitupitu-x86_64-apple-darwin.tar.gz"
      sha256 "2def363a7fb192a2a7e9160fb6d6914f36d6f42cf6fb882a74d0202277b02824"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/klarluft/pitupitu/releases/download/v0.6.0/pitupitu-aarch64-unknown-linux-musl.tar.gz"
      sha256 "1233a232e90b22342e60511e8428581f582081cc3043376c6fca2c9b0caba74b"
    end
    on_intel do
      url "https://github.com/klarluft/pitupitu/releases/download/v0.6.0/pitupitu-x86_64-unknown-linux-musl.tar.gz"
      sha256 "dcd2bc503edc18bae4eeb66fbc8c740b446dc4973a9261cf0fe34b7dc6ff00b5"
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
