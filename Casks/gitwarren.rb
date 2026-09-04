cask "gitwarren" do
  arch arm: "arm64", intel: "x64"

  version "0.1.4"
  sha256 arm:   "c87c5e0a6f713d8cbdfac8331e3d9107ea522b53104308748f1159d959e64e00",
         intel: "c9f81b0b99ac9bb62a1d899c29febd74348baef79145abfd085deb1695351078"

  url "https://github.com/klarluft/gitwarren-app/releases/download/v#{version}/GitWarren-#{version}-#{arch}.dmg",
      verified: "github.com/klarluft/gitwarren-app/"
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
