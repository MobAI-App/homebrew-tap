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
  version "0.13.3"
  license :cannot_represent

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.13.3/mobai-ci_0.13.3_darwin_arm64.tar.gz"
      sha256 "545911c32ff3e7f6910eafe9d35ca03f850eaab62fa199e4d7934c02ca26a488"
    end
    on_intel do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.13.3/mobai-ci_0.13.3_darwin_amd64.tar.gz"
      sha256 "029f8e624682c71db2cd9433f88140be88ab02df1045d5409e17d31e3d861c05"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.13.3/mobai-ci_0.13.3_linux_arm64.tar.gz"
      sha256 "121d0f0dd3ee1c965b2ea950c8c5dad717cd35b470e15adf5461cc6c34269159"
    end
    on_intel do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.13.3/mobai-ci_0.13.3_linux_amd64.tar.gz"
      sha256 "ec2d6852c62d6c90b42dbe3d3e00585710cd949cb2b86d59b2de3171d47d0e3a"
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
