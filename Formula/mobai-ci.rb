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
  version "0.12.0"
  license :cannot_represent

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.12.0/mobai-ci_0.12.0_darwin_arm64.tar.gz"
      sha256 "dc1c5354ca18baeae611caf746a5f57317198bacd325909e6b517808087a200d"
    end
    on_intel do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.12.0/mobai-ci_0.12.0_darwin_amd64.tar.gz"
      sha256 "6dd3ecd758eb3a4c6ae6499c5abcccf3e9f8f2c4e9ea3e5c2210b220dddd5cc6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.12.0/mobai-ci_0.12.0_linux_arm64.tar.gz"
      sha256 "3f219179727eb110b4a914666b5af9d7ca4555abde4d9a316140666c11ba2d10"
    end
    on_intel do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.12.0/mobai-ci_0.12.0_linux_amd64.tar.gz"
      sha256 "1a2df1fdb57a19a582d07e663469b07238a72194be7953d332abc6ccd4779826"
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
