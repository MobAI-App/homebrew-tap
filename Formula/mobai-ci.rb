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
  version "0.13.0"
  license :cannot_represent

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.13.0/mobai-ci_0.13.0_darwin_arm64.tar.gz"
      sha256 "aacdd0c46b0c9b712d5518991d51f00fdf5da00418d21789540afa109524a729"
    end
    on_intel do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.13.0/mobai-ci_0.13.0_darwin_amd64.tar.gz"
      sha256 "f528188237457821b3c846d283d111f945b549cee0a117386076769c5f6a99cf"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.13.0/mobai-ci_0.13.0_linux_arm64.tar.gz"
      sha256 "d37ff51437bea52175e063c0a66628715cab9aced1bf7c2f958069c8d6495a72"
    end
    on_intel do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.13.0/mobai-ci_0.13.0_linux_amd64.tar.gz"
      sha256 "26d76d164d19ff1896f15e7fdad1ae1a86f5443b205a1e99c1810ca4e50006d3"
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
