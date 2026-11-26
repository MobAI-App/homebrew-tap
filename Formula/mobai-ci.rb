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
  version "0.18.1"
  license :cannot_represent

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.18.1/mobai-ci_0.18.1_darwin_arm64.tar.gz"
      sha256 "65c948b290ea913e174f943582887fd5f15f0817e3ba3742c7db56063e2bacad"
    end
    on_intel do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.18.1/mobai-ci_0.18.1_darwin_amd64.tar.gz"
      sha256 "fa3642656dc31978523348724e6f8b28b0c3c5224681c296fd7528a1e3c0a1fd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.18.1/mobai-ci_0.18.1_linux_arm64.tar.gz"
      sha256 "466f6260399b956d7acee387befecdb60b5680ad7d048bf6bf4ebbeca765bea2"
    end
    on_intel do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.18.1/mobai-ci_0.18.1_linux_amd64.tar.gz"
      sha256 "e1d36678d492853d3f587ba102588825f0a3816866cd6bcad7a34257e8a87db8"
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
