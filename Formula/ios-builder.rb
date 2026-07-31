# Formula for ios-builder — the `builder` CLI: remote iOS builds via GitHub
# Actions plus hot reload on real devices through MobAI.
#
# The release workflow (.github/workflows/release.yml in the ios-builder repo)
# uploads bare per-platform binaries and a `checksums.txt`. After each release,
# bump the four release URLs (sed -i "" s/v0.4.0/v<new>/g) and paste the sha256s from:
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
      url "https://github.com/MobAI-App/ios-builder/releases/download/v0.4.0/builder-darwin-arm64"
      sha256 "91ebda7d3ff722030eb339802bae66c17a29eb62938b13c1fe81e13cb330ccf9"
    end
    on_intel do
      url "https://github.com/MobAI-App/ios-builder/releases/download/v0.4.0/builder-darwin-amd64"
      sha256 "735697f2b2829eed5c6a5717120cea9b86011951a44aabad14be650d687dad6b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/MobAI-App/ios-builder/releases/download/v0.4.0/builder-linux-arm64"
      sha256 "160321d79ea210feb1dbc202ac266c05da93695300cd47f327ecb56ee4cdd29d"
    end
    on_intel do
      url "https://github.com/MobAI-App/ios-builder/releases/download/v0.4.0/builder-linux-amd64"
      sha256 "b86a0b2be01a50beb62116d19934a97690645d4bfc74d99d6f01a65491c7d8f5"
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
