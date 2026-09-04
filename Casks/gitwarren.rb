cask "gitwarren" do
  arch arm: "arm64", intel: "x64"

  version "0.1.5"
  sha256 arm:   "3e1fe91eff5ae88c35b2c04799fc00517dfb8d13cd55645f75a980820cccb9c4",
         intel: "9d53dc59f977110501e2da04997f7293f6b0f25d73bd9a258ced347702e6d5c0"

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
