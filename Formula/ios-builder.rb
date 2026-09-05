# Formula for ios-builder — the `builder` CLI: remote iOS builds via GitHub
# Actions, Codemagic, and Bitrise, plus hot reload through MobAI.
#
# The release workflow (.github/workflows/release.yml in the ios-builder repo)
# uploads bare per-platform binaries and a `checksums.txt`. After each release,
# bump the four release URLs (sed -i "" s/v0.9.0/v<new>/g) and paste the sha256s from:
#   curl -sL https://github.com/MobAI-App/ios-builder/releases/download/v<version>/checksums.txt
class IosBuilder < Formula
  desc "Build iOS apps via GitHub Actions, Codemagic, or Bitrise"
  homepage "https://github.com/MobAI-App/ios-builder"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/MobAI-App/ios-builder/releases/download/v0.9.0/builder-darwin-arm64"
      sha256 "595d6ffa98412554cf2b18c180265eaac7651a53db3629fd80a3acffa535bd46"
    end
    on_intel do
      url "https://github.com/MobAI-App/ios-builder/releases/download/v0.9.0/builder-darwin-amd64"
      sha256 "c68ce8ec6a69a47bc0ea48d31706e7a7cf99c9104e91bc44af75dec88d91b5ea"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/MobAI-App/ios-builder/releases/download/v0.9.0/builder-linux-arm64"
      sha256 "24b24ee2c61e5db3c5a99d6cb51322a1b4f7ea04feea41284440c28116120ab4"
    end
    on_intel do
      url "https://github.com/MobAI-App/ios-builder/releases/download/v0.9.0/builder-linux-amd64"
      sha256 "7a19e866e122924cd57788fd2efc9cc447f80c5785b85a3aa11a5b5e482aae69"
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
    assert_match "GitHub Actions (default), Codemagic, or Bitrise", shell_output("#{bin}/builder --help")
    # Outside a configured repo this must fail with the setup hint, not a crash.
    output = shell_output("#{bin}/builder ios build 2>&1", 1)
    assert_match "builder.json not found", output
  end
end
