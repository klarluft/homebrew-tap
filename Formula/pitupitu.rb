# The Homebrew formula for pitupitu, as a template.
#
# The release workflow fills in the version and the four checksums from the
# tarballs it has just built (`fill.sh` next to this file) and attaches the
# result to the release as `pitupitu.rb`. klarluft/homebrew-tap copies that
# file in as it is, so the formula and the binaries it points at come from
# the same run. Homebrew reads the version from the `v…` in the URLs.
class Pitupitu < Formula
  desc "Links this machine's coding agents to pitupitu, a voice assistant"
  homepage "https://pitupitu.chat"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/klarluft/pitupitu/releases/download/v0.15.2/pitupitu-aarch64-apple-darwin.tar.gz"
      sha256 "872039903c7aaea75be589faf13427cf5aac6250c91ceea8ad99e400fc3c41d5"
    end
    on_intel do
      url "https://github.com/klarluft/pitupitu/releases/download/v0.15.2/pitupitu-x86_64-apple-darwin.tar.gz"
      sha256 "50dbcbf5ba5ea49b25d60d2fbafa7212f879e6387d3c10044b9c91acab28b01d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/klarluft/pitupitu/releases/download/v0.15.2/pitupitu-aarch64-unknown-linux-musl.tar.gz"
      sha256 "b8593d73280e9e990e673d84db50ea89bf0ee2fd571a17904b0844568a48865d"
    end
    on_intel do
      url "https://github.com/klarluft/pitupitu/releases/download/v0.15.2/pitupitu-x86_64-unknown-linux-musl.tar.gz"
      sha256 "e693f8127bddfaace22fa669a97a28b0e67b886eceea4288210893b756519fb5"
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
