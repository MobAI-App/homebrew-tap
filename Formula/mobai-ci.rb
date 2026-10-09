# Formula for mobai-ci: run MobAI mobile UI tests (.mob, .mobflow and Maestro
# flows) on local simulators, emulators and devices, in CI or on a laptop.
#
# Releases ship prebuilt tarballs (the binary plus LICENSE-BINARY.md) and a
# `checksums.txt`, uploaded by `make mobai-ci-publish` in the mobai repo. After
# each release, bump the three release URLs (sed -i "" s/0.10.0/<new>/g) and
# paste the sha256s from:
#   curl -sL https://github.com/MobAI-App/mobai-ci/releases/download/v<version>/checksums.txt
class MobaiCi < Formula
  desc "Run MobAI mobile UI tests on simulators, emulators and devices"
  homepage "https://github.com/MobAI-App/mobai-ci"
  version "0.10.0"
  license :cannot_represent

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.10.0/mobai-ci_0.10.0_darwin_arm64.tar.gz"
      sha256 "83b7ae28b32c7e03033fd97d314a3aca7e374220de3b49d16548ed3de71274f7"
    end
    on_intel do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.10.0/mobai-ci_0.10.0_darwin_amd64.tar.gz"
      sha256 "2fffdbda2963eda95b989f69264f5c07c5e4002922d5f8ffc98dccbd557bf6ed"
    end
  end

  on_linux do
    # No linux/arm64 build is published.
    on_intel do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.10.0/mobai-ci_0.10.0_linux_amd64.tar.gz"
      sha256 "e97f1f3a67e2bd3ab8b4ad0102e478515770e841480563779de7e8403bd6bce3"
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
