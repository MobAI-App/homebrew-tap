# Formula for ios-builder — the `builder` CLI: remote iOS builds via GitHub
# Actions plus hot reload on real devices through MobAI.
#
# The release workflow (.github/workflows/release.yml in the ios-builder repo)
# uploads bare per-platform binaries and a `checksums.txt`. After each release,
# bump the four release URLs (sed -i "" s/v0.3.0/v<new>/g) and paste the sha256s from:
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
      url "https://github.com/MobAI-App/ios-builder/releases/download/v0.3.0/builder-darwin-arm64"
      sha256 "ed73085901616ee50b189a006787a4454860bedafc3a365b77c5670da0615d5a"
    end
    on_intel do
      url "https://github.com/MobAI-App/ios-builder/releases/download/v0.3.0/builder-darwin-amd64"
      sha256 "d95ba01ed5299bbb7a73823b808ba05b5ef6342acfa02fc01d401c57c557f002"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/MobAI-App/ios-builder/releases/download/v0.3.0/builder-linux-arm64"
      sha256 "b5658889b66dd3e0e9ceb15fe4861bbb4292511f231c0ec503f7e6f1ef5a7d78"
    end
    on_intel do
      url "https://github.com/MobAI-App/ios-builder/releases/download/v0.3.0/builder-linux-amd64"
      sha256 "3c0b499a1dbee33082f554f38fe0514c1b2ff145301f4262efaf94fabd0b3b0e"
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
    assert_match "GitHub Actions workflows to build iOS apps", shell_output("#{bin}/builder --help")
    # Outside a configured repo this must fail with the setup hint, not a crash.
    output = shell_output("#{bin}/builder ios build 2>&1", 1)
    assert_match "builder.json not found", output
  end
end
