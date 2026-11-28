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
  version "0.18.5"
  license :cannot_represent

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.18.5/mobai-ci_0.18.5_darwin_arm64.tar.gz"
      sha256 "c50f9d7c8d178f0207b09262e33010ec7d28013e2c6edd87990239efd96149a8"
    end
    on_intel do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.18.5/mobai-ci_0.18.5_darwin_amd64.tar.gz"
      sha256 "2614af894f4563d111ea3ad8248883f2c9d6e091e3e1c035aa984159de9cba7a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.18.5/mobai-ci_0.18.5_linux_arm64.tar.gz"
      sha256 "d3a6e89a8ea9e8b7f3fb384d4b4d698c34d8da756a94a921b40c1b80806f9bb3"
    end
    on_intel do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.18.5/mobai-ci_0.18.5_linux_amd64.tar.gz"
      sha256 "8300463c68d0c02843ed91bdf293f9783b67013db5762e09b4fdf906c6950ce6"
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
