# Formula for simslim: slim iOS simulators to run many more on one Mac.
#
# Installs a prebuilt Homebrew bottle so `brew install` never runs a source
# build (which triggers Xcode/Command-Line-Tools version checks). After each
# release, update the source `sha256` and the bottle stanza from the values the
# GitHub Actions release workflow prints.
class Simslim < Formula
  desc "Run more iOS simulators on one Mac by disabling unneeded background daemons"
  homepage "https://github.com/mobai-app/simslim"
  url "https://github.com/mobai-app/simslim/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "ff220b5c33c3830d438ce4a61b4b99f6103b2312db3e6b15b479bed2656763ee"
  license "MIT"

  bottle do
    root_url "https://github.com/mobai-app/simslim/releases/download/v0.1.0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "8b758fde7a7b2036fc08fb9a26eec6d00be7dee82418fc4e2add15bd6b6a0e62"
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
