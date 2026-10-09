# Formula for mobai-ci: run MobAI mobile UI tests (.mob, .mobflow and Maestro
# flows) on local simulators, emulators and devices, in CI or on a laptop.
#
# Releases ship prebuilt tarballs (the binary plus LICENSE-BINARY.md) and a
# `checksums.txt`, uploaded by `make mobai-ci-publish` in the mobai repo. After
# each release, bump the four release URLs (sed -i "" s/0.10.1/<new>/g) and
# paste the sha256s from:
#   curl -sL https://github.com/MobAI-App/mobai-ci/releases/download/v<version>/checksums.txt
class MobaiCi < Formula
  desc "Run MobAI mobile UI tests on simulators, emulators and devices"
  homepage "https://github.com/MobAI-App/mobai-ci"
  version "0.10.1"
  license :cannot_represent

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.10.1/mobai-ci_0.10.1_darwin_arm64.tar.gz"
      sha256 "1b57b9cce99593f0e96024fa8f8cdb50a73a6d06158bf7b3f4a39b765005fd9c"
    end
    on_intel do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.10.1/mobai-ci_0.10.1_darwin_amd64.tar.gz"
      sha256 "42df6676ca6b2a1f4d13fe012f0c4585e99dbe777869ea97e1ad6601008e8821"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.10.1/mobai-ci_0.10.1_linux_arm64.tar.gz"
      sha256 "8df8c8c3d569f768e7c2efd3146b039e0e8b1a3501f9a7084fc35b175fb8a412"
    end
    on_intel do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.10.1/mobai-ci_0.10.1_linux_amd64.tar.gz"
      sha256 "70b19bc2da56b2ab421de5971930f29078270e5501c44c532bc45acde3bb0cb5"
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
