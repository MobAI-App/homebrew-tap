# Formula for simslim: slim iOS simulators to run many more on one Mac.
#
# Installs a prebuilt Homebrew bottle so `brew install` never runs a source
# build (which triggers Xcode/Command-Line-Tools version checks). After each
# release, update the source `sha256` and the bottle stanza from the values the
# GitHub Actions release workflow prints.
class Simslim < Formula
  desc "Run more iOS simulators on one Mac by disabling unneeded background daemons"
  homepage "https://github.com/mobai-app/simslim"
  url "https://github.com/mobai-app/simslim/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "a0916be11d9a7dfbd979c11790368dca2b624386b70d03669d20a681cc7a3315"
  license "MIT"

  bottle do
    root_url "https://github.com/mobai-app/simslim/releases/download/v0.2.0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "bd3b623ca1532cab2c667d83ade3ffb9ac660ff588171adb680fd560d4c080fa"
  end

  depends_on "go" => :build
  depends_on arch: :arm64
  depends_on :macos

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  def caveats
    <<~EOS
      simslim drives iOS simulators, so it needs Xcode with an iOS Simulator
      runtime installed (not just the standalone Command Line Tools).

      Verify the CLI runs:
        simslim list
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/simslim --version")
  end
end
