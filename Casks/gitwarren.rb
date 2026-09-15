cask "gitwarren" do
  arch arm: "arm64", intel: "x64"

  version "0.1.12"
  sha256 arm:   "e5bbe52df163ab02123e28deaa3b6f4e0bfc689d9a8b9e8662c33c67d6980a7f",
         intel: "3aaee8a2b647f41a5e548ee5fb8b7ab1cdc4213634f68adaf568c43023390235"

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
