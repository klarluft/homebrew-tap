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
      url "https://github.com/klarluft/pitupitu/releases/download/v0.14.0/pitupitu-aarch64-apple-darwin.tar.gz"
      sha256 "953dc03051e203ce59b8cc9dbf9432b7a4f29b31d8b3411927fac59b41b09e9e"
    end
    on_intel do
      url "https://github.com/klarluft/pitupitu/releases/download/v0.14.0/pitupitu-x86_64-apple-darwin.tar.gz"
      sha256 "6db57843b43adf0769be76cbd70be8fd73f83f824c8c059f9a3972dfb19b0399"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/klarluft/pitupitu/releases/download/v0.14.0/pitupitu-aarch64-unknown-linux-musl.tar.gz"
      sha256 "85f32bc87f960a3a2f6b78d9287ab19ca17cb94db9f0346f703366fa2104aca6"
    end
    on_intel do
      url "https://github.com/klarluft/pitupitu/releases/download/v0.14.0/pitupitu-x86_64-unknown-linux-musl.tar.gz"
      sha256 "fb47c89f0500cb7d19994742779a7f68c02050f1e5f54a1735709e63c3f09f81"
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
