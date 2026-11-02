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
      url "https://github.com/klarluft/pitupitu/releases/download/v0.9.0/pitupitu-aarch64-apple-darwin.tar.gz"
      sha256 "ad5dc658f9fe0db1a02a2230c6255f5949eb987c77e7e8f6d85a1656fe89ccc7"
    end
    on_intel do
      url "https://github.com/klarluft/pitupitu/releases/download/v0.9.0/pitupitu-x86_64-apple-darwin.tar.gz"
      sha256 "37d5826a117c980fbe777a1878f236e22792c97e7992822858a93b9622d03489"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/klarluft/pitupitu/releases/download/v0.9.0/pitupitu-aarch64-unknown-linux-musl.tar.gz"
      sha256 "f8e4def9e08af39abd91aeb726be57e42efc5b78027c7f461a7edd48874084f3"
    end
    on_intel do
      url "https://github.com/klarluft/pitupitu/releases/download/v0.9.0/pitupitu-x86_64-unknown-linux-musl.tar.gz"
      sha256 "3b95fbb5bef056f43d34de05154fefbe592954b2e75989d42c099f9bd25c7675"
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
