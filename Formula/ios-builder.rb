# Formula for ios-builder — the `builder` CLI: remote iOS builds via GitHub
# Actions, Codemagic, and Bitrise, plus hot reload through MobAI.
#
# The release workflow (.github/workflows/release.yml in the ios-builder repo)
# uploads bare per-platform binaries and a `checksums.txt`. After each release,
# bump the four release URLs (sed -i "" s/v0.10.0/v<new>/g) and paste the sha256s from:
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
      url "https://github.com/MobAI-App/ios-builder/releases/download/v0.10.0/builder-darwin-arm64"
      sha256 "2c940f62ec51cdc05286ef9112eaca5cadb5e1db4542408c2cdf94b24376cde3"
    end
    on_intel do
      url "https://github.com/MobAI-App/ios-builder/releases/download/v0.10.0/builder-darwin-amd64"
      sha256 "e1021539902a49835f5e02e95f0f21b84de7e9b4c1ffc8c79bdd3a38c5b0abd9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/MobAI-App/ios-builder/releases/download/v0.10.0/builder-linux-arm64"
      sha256 "50486644a87997ea8fd3e0f139190f65ec72e5ca7524272adda062332b820238"
    end
    on_intel do
      url "https://github.com/MobAI-App/ios-builder/releases/download/v0.10.0/builder-linux-amd64"
      sha256 "ccc8ff99dc995911d2021ebfb9681a2e5cfe34efb7af3927e43a23aa9d3461bf"
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
