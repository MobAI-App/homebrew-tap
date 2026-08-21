# Formula for ios-builder — the `builder` CLI: remote iOS builds via GitHub
# Actions plus hot reload on real devices through MobAI.
#
# The release workflow (.github/workflows/release.yml in the ios-builder repo)
# uploads bare per-platform binaries and a `checksums.txt`. After each release,
# bump the four release URLs (sed -i "" s/v0.6.0/v<new>/g) and paste the sha256s from:
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
      url "https://github.com/MobAI-App/ios-builder/releases/download/v0.6.0/builder-darwin-arm64"
      sha256 "3d92933b81f790ae6e356bdcfc55f19321c95e6314cd87f4db2b9a2e2bfdf4b8"
    end
    on_intel do
      url "https://github.com/MobAI-App/ios-builder/releases/download/v0.6.0/builder-darwin-amd64"
      sha256 "b9e09b723b08a081ab765eb6abb1a08fe0cbf1b7c45bf956e6b61cf5415d99a6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/MobAI-App/ios-builder/releases/download/v0.6.0/builder-linux-arm64"
      sha256 "a5eb98922086e7f6b1c07edc7cffe5ae68a8bde710f3bc759339f354e67e2ea5"
    end
    on_intel do
      url "https://github.com/MobAI-App/ios-builder/releases/download/v0.6.0/builder-linux-amd64"
      sha256 "b3022444598392fba9a61c6c81183cf380997ec6076d25962f5b12a959a7103a"
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
