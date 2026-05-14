# Formula for deskagent — macOS-only ScreenCaptureKit recorder + control CLI.
#
# After each release, update both `version` and `sha256` to match the values
# the GitHub Actions workflow prints (see RELEASING.md in the main repo).
class Deskagent < Formula
  desc "ScreenCaptureKit-based macOS screen recorder + deterministic UI driver"
  homepage "https://github.com/mobai-app/desktop-recorder-skill"
  license "MIT"
  version "0.1.0"

  # macOS-only, Apple Silicon. Add an Intel block here later if you ship
  # a macos-13 / x86_64 build from CI.
  depends_on macos: :sonoma   # macOS 14.0+ (ScreenCaptureKit content filter API)
  depends_on arch: :arm64

  url "https://github.com/mobai-app/desktop-recorder-skill/releases/download/v#{version}/deskagent-v#{version}-macos-arm64.tar.gz"
  sha256 "4863d6df4487f8aadd4abad45e97dbacce2ba8c6feb9ef6ff43f6d20c390835a"

  def install
    bin.install "deskagent"
  end

  def caveats
    <<~EOS
      First use will require Screen Recording permission:
        System Settings → Privacy & Security → Screen Recording → enable "deskagent"

      `deskagent control` additionally needs Accessibility permission:
        System Settings → Privacy & Security → Accessibility → enable "deskagent"

      Run `deskagent doctor` to verify both are granted.

      Note: this binary is ad-hoc signed (no Apple Developer ID). After each
      `brew upgrade deskagent`, macOS treats the new version as a fresh
      identity and you'll be re-prompted for Screen Recording permission.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/deskagent --version")
    # Doctor exits 2 if permissions are missing, but the help should always work
    assert_match "deskagent <subcommand>", shell_output("#{bin}/deskagent --help")
  end
end
