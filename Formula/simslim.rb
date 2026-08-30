# Formula for simslim: slim iOS simulators to run many more on one Mac.
#
# Installs a prebuilt Homebrew bottle so `brew install` never runs a source
# build (which triggers Xcode/Command-Line-Tools version checks). After each
# release, update the source `sha256` and the bottle stanza from the values the
# GitHub Actions release workflow prints.
class Simslim < Formula
  desc "Run more iOS simulators on one Mac by disabling unneeded background daemons"
  homepage "https://github.com/mobai-app/simslim"
  url "https://github.com/mobai-app/simslim/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "f6eee4dd84832618c12af6afbfacd32bd70f2c14decc4a68121c44f79fb1992f"
  license "MIT"

  bottle do
    root_url "https://github.com/mobai-app/simslim/releases/download/v0.7.0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "ab5f04fa3fa0e5a0c7b36085d9517b14ae1752304a514af853c44285cf0eba31"
  end

  depends_on "go" => :build
  depends_on arch: :arm64
  depends_on :macos

  def install
    # std_go_args passes no package path, so the CLI must be named explicitly:
    # the repo root is the importable simslim library, not package main.
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/simslim"
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
