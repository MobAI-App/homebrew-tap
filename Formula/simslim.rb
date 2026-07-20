# Formula for simslim — slim iOS simulators to run many more on one Mac.
#
# After each release, update both `version` and `sha256` to match the values
# the GitHub Actions workflow prints.
class Simslim < Formula
  desc "Run more iOS simulators on one Mac by disabling background daemons they don't need"
  homepage "https://github.com/mobai-app/simslim"
  license "MIT"
  version "0.1.0"

  # Apple Silicon build. Add an x86_64 block here if an Intel build ships.
  depends_on arch: :arm64
  depends_on :macos

  url "https://github.com/mobai-app/simslim/releases/download/v#{version}/simslim-v#{version}-macos-arm64.tar.gz"
  sha256 "f15a6622de0bfd5022ff15bed24679371975595ef5f768cd14f4a67d315959c8"

  def install
    bin.install "simslim"
  end

  def caveats
    <<~EOS
      simslim drives Apple's iOS simulators, so it needs Xcode's command-line
      tools installed:
        xcode-select --install

      Verify the CLI runs:
        simslim list
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/simslim --version")
  end
end
