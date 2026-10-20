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
      url "https://github.com/klarluft/pitupitu/releases/download/v0.5.0/pitupitu-aarch64-apple-darwin.tar.gz"
      sha256 "21a8ec0f2ab63b6984c7dc6e2d6481ba43084a4c877f20444f758d8f659f6b93"
    end
    on_intel do
      url "https://github.com/klarluft/pitupitu/releases/download/v0.5.0/pitupitu-x86_64-apple-darwin.tar.gz"
      sha256 "4decdeb38ab0d5fa50ccfaaf8ca9bf2814c6c9965cc077078b470b7b07b56ca0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/klarluft/pitupitu/releases/download/v0.5.0/pitupitu-aarch64-unknown-linux-musl.tar.gz"
      sha256 "48ae8af185489236a99630252f90fb1bc30900b824dc9af2401ac21cce605890"
    end
    on_intel do
      url "https://github.com/klarluft/pitupitu/releases/download/v0.5.0/pitupitu-x86_64-unknown-linux-musl.tar.gz"
      sha256 "296af2b95a44341bec773e3e5ae388eb1053b083e2b679ec12b607c5f41c4c0e"
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
