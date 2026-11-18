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
  version "0.15.1"
  license :cannot_represent

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.15.1/mobai-ci_0.15.1_darwin_arm64.tar.gz"
      sha256 "e680fb6e46307f7b6d3d5ce3979c1492fea9a369d25516d76511f1a9eb8aab48"
    end
    on_intel do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.15.1/mobai-ci_0.15.1_darwin_amd64.tar.gz"
      sha256 "bed1153d6f4f6cec133ed5a6d8fe4353b3d84e23c61c64ff4374d8c936987f44"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.15.1/mobai-ci_0.15.1_linux_arm64.tar.gz"
      sha256 "b425cd6546727d038de514b5e15a64c952b1b935b009740b08624682798b8c0b"
    end
    on_intel do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.15.1/mobai-ci_0.15.1_linux_amd64.tar.gz"
      sha256 "c9af0a5fdb121da3f4b95d22abd87dcfa9a4115203208b4dfadcccf45e814aaa"
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
