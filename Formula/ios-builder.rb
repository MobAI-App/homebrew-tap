# Formula for ios-builder — the `builder` CLI: remote iOS builds via GitHub
# Actions, Codemagic, and Bitrise, plus hot reload through MobAI.
#
# The release workflow (.github/workflows/release.yml in the ios-builder repo)
# uploads bare per-platform binaries and a `checksums.txt`. After each release,
# bump the four release URLs (sed -i "" s/v0.11.0/v<new>/g) and paste the sha256s from:
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
      url "https://github.com/MobAI-App/ios-builder/releases/download/v0.11.0/builder-darwin-arm64"
      sha256 "8f8b753cdfc58c135ef66aebc07a7d2ddc9630435e2ebf76c7add541db329bd2"
    end
    on_intel do
      url "https://github.com/MobAI-App/ios-builder/releases/download/v0.11.0/builder-darwin-amd64"
      sha256 "f256ea8e4ba07d24a8ab7532e8e46244165fbb7626f4ce1b7039aea30e0cb2ce"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/MobAI-App/ios-builder/releases/download/v0.11.0/builder-linux-arm64"
      sha256 "609b8bfe15f594b50134909ddfcc0cff06c4438d0db191880cd2d1aa6cfb66f9"
    end
    on_intel do
      url "https://github.com/MobAI-App/ios-builder/releases/download/v0.11.0/builder-linux-amd64"
      sha256 "1f42e8d5928193422060b87c2bf1b9597ce3a7f40a64866783de8b300befc3f0"
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
