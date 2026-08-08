# Formula for ios-builder — the `builder` CLI: remote iOS builds via GitHub
# Actions plus hot reload on real devices through MobAI.
#
# The release workflow (.github/workflows/release.yml in the ios-builder repo)
# uploads bare per-platform binaries and a `checksums.txt`. After each release,
# bump the four release URLs (sed -i "" s/v0.5.0/v<new>/g) and paste the sha256s from:
#   curl -sL https://github.com/MobAI-App/ios-builder/releases/download/v<version>/checksums.txt
class IosBuilder < Formula
  desc "Build iOS apps from any OS via GitHub Actions, with hot reload on real devices"
  homepage "https://github.com/MobAI-App/ios-builder"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/MobAI-App/ios-builder/releases/download/v0.5.0/builder-darwin-arm64"
      sha256 "d69ff760a9ded3f80d07aadbfea56c79deef976e8b4dfea4d91616f0e21cf559"
    end
    on_intel do
      url "https://github.com/MobAI-App/ios-builder/releases/download/v0.5.0/builder-darwin-amd64"
      sha256 "542a26872b6209ee97fd1501f85d6fc32146df74372a8d5975dc217702bcca16"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/MobAI-App/ios-builder/releases/download/v0.5.0/builder-linux-arm64"
      sha256 "ee06170986ca7d5b4b370857014d7f12531ecbecdfb4992aa39a06cc4f89ec3a"
    end
    on_intel do
      url "https://github.com/MobAI-App/ios-builder/releases/download/v0.5.0/builder-linux-amd64"
      sha256 "a432de1198bf5ed8917505fa6a4b9b45c49f134ef565efd46f2291bcef8ee6c4"
    end
  end

  def install
    # Releases ship bare binaries rather than tarballs, so the staged file keeps
    # its platform suffix (e.g. builder-darwin-arm64) and needs +x restored.
    binary = Dir["builder-*"].first
    odie "no builder-* binary in the download" if binary.nil?
    bin.install binary => "builder"
    chmod 0755, bin/"builder"
  end

  def caveats
    <<~EOS
      First run, from the repo you want to build:
        builder auth github    # GitHub OAuth device flow, token goes in the keychain
        builder init           # writes .github/workflows/ios-build.yml + builder.json
        builder ios build      # triggers the build, downloads the IPA to ./dist/

      Hot reload on a real iOS device (`builder dev flutter|rn|kmp`) additionally
      needs MobAI running with a physical device connected: https://mobai.run

      Note: these binaries are ad-hoc signed (no Apple Developer ID), so macOS
      may prompt on first run after each `brew upgrade ios-builder`.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/builder --version")
    assert_match "GitHub Actions workflows to build iOS apps", shell_output("#{bin}/builder --help")
    # Outside a configured repo this must fail with the setup hint, not a crash.
    output = shell_output("#{bin}/builder ios build 2>&1", 1)
    assert_match "builder.json not found", output
  end
end
