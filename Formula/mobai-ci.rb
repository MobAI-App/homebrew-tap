# Formula for mobai-ci: run MobAI mobile UI tests (.mob, .mobflow and Maestro
# flows) on local simulators, emulators and devices, in CI or on a laptop.
#
# Releases ship prebuilt tarballs (the binary plus LICENSE-BINARY.md) and a
# `checksums.txt`, uploaded by `make mobai-ci-publish` in the mobai repo. After
# each release, bump the four release URLs (sed -i "" s/0.10.2/<new>/g) and
# paste the sha256s from:
#   curl -sL https://github.com/MobAI-App/mobai-ci/releases/download/v<version>/checksums.txt
class MobaiCi < Formula
  desc "Run MobAI mobile UI tests on simulators, emulators and devices"
  homepage "https://github.com/MobAI-App/mobai-ci"
  version "0.15.4"
  license :cannot_represent

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.15.4/mobai-ci_0.15.4_darwin_arm64.tar.gz"
      sha256 "02f45df2b1581975156b5c7ee809bc682cb807d9c972df530d7bc8c013016446"
    end
    on_intel do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.15.4/mobai-ci_0.15.4_darwin_amd64.tar.gz"
      sha256 "63fc682db5657c9cf42373098ea45fbdb368c75b7937690281f43c7641f46385"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.15.4/mobai-ci_0.15.4_linux_arm64.tar.gz"
      sha256 "c98c629ca1dd4b50311125679257e150b040361f14eb2dc0403f30fe5a1932e9"
    end
    on_intel do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.15.4/mobai-ci_0.15.4_linux_amd64.tar.gz"
      sha256 "b3398582571340444d106544fb0c6ccfe654ee2a404db6f7e3920dc81cbb0102"
    end
  end

  def install
    bin.install "mobai-ci"
    prefix.install "LICENSE-BINARY.md"
  end

  def caveats
    <<~EOS
      Run a folder of tests on the only connected device or booted simulator:
        mobai-ci test ./flows

      iOS simulators need Xcode; Android needs adb and an emulator or device.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mobai-ci --version")
  end
end
