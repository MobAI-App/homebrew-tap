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
  version "0.15.0"
  license :cannot_represent

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.15.0/mobai-ci_0.15.0_darwin_arm64.tar.gz"
      sha256 "dddfbc9b593763f0cdd43e8d68eb4533452796d45414518bffb56222c4b1a270"
    end
    on_intel do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.15.0/mobai-ci_0.15.0_darwin_amd64.tar.gz"
      sha256 "91160bfac73f3e3cec64856a678ec6e37f2284a948544552bcd0e76fe457d093"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.15.0/mobai-ci_0.15.0_linux_arm64.tar.gz"
      sha256 "24a61f64cf83ce36be757b79322c96abaa485ad7315a5f6d2e33748410da5c4d"
    end
    on_intel do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.15.0/mobai-ci_0.15.0_linux_amd64.tar.gz"
      sha256 "c4f45d4918c0b5b7638b37ec2c4abca324e7962a5d916c6e28bb9c8d130f9bdd"
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
