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
  version "0.16.0"
  license :cannot_represent

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.16.0/mobai-ci_0.16.0_darwin_arm64.tar.gz"
      sha256 "f3a0f050329b557c9b92d11fabf57aa90d0488d759a1097353deeeb64b868c2f"
    end
    on_intel do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.16.0/mobai-ci_0.16.0_darwin_amd64.tar.gz"
      sha256 "8884c4da1879ef18698a26097395a05488203610cdbbd69565f07a67b494cd05"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.16.0/mobai-ci_0.16.0_linux_arm64.tar.gz"
      sha256 "02a3f8f7cc8ed2f204c8a3fa6448e24247c73e3841bb4f73ba13e3fd73b523da"
    end
    on_intel do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.16.0/mobai-ci_0.16.0_linux_amd64.tar.gz"
      sha256 "b2f12b8276421b7862b51b2bac7815419f6ef8fd4d9c9553e9e7c22efbd20449"
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
