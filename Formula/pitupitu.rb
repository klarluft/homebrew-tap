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
      url "https://github.com/klarluft/pitupitu/releases/download/v0.3.3/pitupitu-aarch64-apple-darwin.tar.gz"
      sha256 "c0c4a7eab8caa17f2ea0bfa18f016f47b23cc89ad9cfabb7bd5e40be0cc13ba9"
    end
    on_intel do
      url "https://github.com/klarluft/pitupitu/releases/download/v0.3.3/pitupitu-x86_64-apple-darwin.tar.gz"
      sha256 "b91a978d862dff2787a5e49f4bc3f820c842df6dbc5f1e85e4c3f80eea14db04"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/klarluft/pitupitu/releases/download/v0.3.3/pitupitu-aarch64-unknown-linux-musl.tar.gz"
      sha256 "86bfcb0a2d426db442bcfe5d5e1a16e03f662385b126a62e46782f0434157740"
    end
    on_intel do
      url "https://github.com/klarluft/pitupitu/releases/download/v0.3.3/pitupitu-x86_64-unknown-linux-musl.tar.gz"
      sha256 "033b92ba367d9d992cf1849716a636c5edb2ef23112cf5ffc87b0ecdae5416f2"
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
