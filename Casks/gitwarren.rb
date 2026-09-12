cask "gitwarren" do
  arch arm: "arm64", intel: "x64"

  version "0.1.8"
  sha256 arm:   "a48a247dff824d5fe9be57d09dda6bfbe59ef1cf2092fcd1f05890a425f84cad",
         intel: "55ddf79a2e17bb3608703bd40218c69c919f4ef56578338bb03bed65fc314ec8"

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
