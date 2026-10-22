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
      url "https://github.com/klarluft/pitupitu/releases/download/v0.8.0/pitupitu-aarch64-apple-darwin.tar.gz"
      sha256 "19998350d917f1d8166437531d0bcc79953749036b0dcfd27f285ed445b07ee3"
    end
    on_intel do
      url "https://github.com/klarluft/pitupitu/releases/download/v0.8.0/pitupitu-x86_64-apple-darwin.tar.gz"
      sha256 "db6a6813d0e8ec17158cf43a84ea8232a0d14239588b102cb505f32f295eb9e7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/klarluft/pitupitu/releases/download/v0.8.0/pitupitu-aarch64-unknown-linux-musl.tar.gz"
      sha256 "9a2da8853ddd36274c75c4ac961c572a7aa6baa6d456977f1bf24bc8971ade88"
    end
    on_intel do
      url "https://github.com/klarluft/pitupitu/releases/download/v0.8.0/pitupitu-x86_64-unknown-linux-musl.tar.gz"
      sha256 "38d6c3b23ccba74ae285ca80e35a2e3ae2d83015d1dbebf1e3d1a3ed149889a3"
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
