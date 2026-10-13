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
  version "0.10.3"
  license :cannot_represent

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.10.3/mobai-ci_0.10.3_darwin_arm64.tar.gz"
      sha256 "456d619a10bfbf6cb5a0a6ca9a04b5d9dd92dd4d59f7e688fd77e58ca483fe88"
    end
    on_intel do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.10.3/mobai-ci_0.10.3_darwin_amd64.tar.gz"
      sha256 "0d2b82126136ed77dcb9bf78f41e058ffb9a22a6e66a93aecc74adb3d0f62be8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.10.3/mobai-ci_0.10.3_linux_arm64.tar.gz"
      sha256 "58dfc77a340bc323ea1b4f14611b11300c2ab66950dde5b1b47e1dfd95a58acd"
    end
    on_intel do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.10.3/mobai-ci_0.10.3_linux_amd64.tar.gz"
      sha256 "a4f9a90b524f13a5624fde464a57aace92a94662c5bf9b89e3c93567c5734f7e"
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
