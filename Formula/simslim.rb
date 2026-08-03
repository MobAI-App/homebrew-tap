# Formula for simslim: slim iOS simulators to run many more on one Mac.
#
# Installs a prebuilt Homebrew bottle so `brew install` never runs a source
# build (which triggers Xcode/Command-Line-Tools version checks). After each
# release, update the source `sha256` and the bottle stanza from the values the
# GitHub Actions release workflow prints.
class Simslim < Formula
  desc "Run more iOS simulators on one Mac by disabling unneeded background daemons"
  homepage "https://github.com/mobai-app/simslim"
  url "https://github.com/mobai-app/simslim/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "cc94249529c9726e8e1e4266cf197be5849955160f25e2d82dd303766bfd3be9"
  license "MIT"

  bottle do
    root_url "https://github.com/mobai-app/simslim/releases/download/v0.6.0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "eb912b339953ef982e0f77eb0a4537ab27caf3c9925426480f18aca95ea145b5"
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
