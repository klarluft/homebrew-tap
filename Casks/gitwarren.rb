cask "gitwarren" do
  arch arm: "arm64", intel: "x64"

  version "0.1.17"
  sha256 arm:   "46856cf7f23c87410215197045e39f0ebcb27863e3da20dbb8b579b6cb4baff1",
         intel: "c77e565ac2e7b22c853b83f9ce8835d97b82bcea52e9d8c77582d2f287bc8b18"

  url "https://github.com/klarluft/gitwarren-app/releases/download/v#{version}/GitWarren-#{version}-#{arch}.dmg"
  name "GitWarren"
  desc "Local code review for git repositories, including uncommitted worktrees"
  homepage "https://gitwarren.com/"

  livecheck do
    url :url
    strategy :github_latest
  end

  # The app updates itself through electron-updater (checks on launch and
  # every six hours, applies on the next restart), so `brew upgrade` leaves it
  # alone unless asked with --greedy.
  auto_updates true
  depends_on macos: :ventura

  app "GitWarren.app"

  zap trash: [
    "~/Library/Application Support/GitWarren",
    "~/Library/Caches/com.gitwarren.app",
    "~/Library/Caches/com.gitwarren.app.ShipIt",
    "~/Library/Caches/gitwarren-updater",
    "~/Library/HTTPStorages/com.gitwarren.app",
    "~/Library/Preferences/com.gitwarren.app.plist",
    "~/Library/Saved Application State/com.gitwarren.app.savedState",
    "~/Library/WebKit/com.gitwarren.app",
  ]
end
