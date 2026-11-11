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
      url "https://github.com/klarluft/pitupitu/releases/download/v0.15.1/pitupitu-aarch64-apple-darwin.tar.gz"
      sha256 "7ef0f117539538f3d8cc58d57235bbb0ac0f41330aed1721e9c04024b63ca0a9"
    end
    on_intel do
      url "https://github.com/klarluft/pitupitu/releases/download/v0.15.1/pitupitu-x86_64-apple-darwin.tar.gz"
      sha256 "aa665c3a09a42e463712e4d7b136297b8d64f54140632c453855d659d1e24909"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/klarluft/pitupitu/releases/download/v0.15.1/pitupitu-aarch64-unknown-linux-musl.tar.gz"
      sha256 "c273c8a131be2da17c7e8f73114f1426588c36a74cf45c97042baf100883f15f"
    end
    on_intel do
      url "https://github.com/klarluft/pitupitu/releases/download/v0.15.1/pitupitu-x86_64-unknown-linux-musl.tar.gz"
      sha256 "2e33301d87d21201893d7d6223629970aa9615644e6509d4646157bbd1e1e9ad"
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
