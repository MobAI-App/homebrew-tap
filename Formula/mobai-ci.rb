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
  version "0.12.2"
  license :cannot_represent

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.12.2/mobai-ci_0.12.2_darwin_arm64.tar.gz"
      sha256 "136a54cf0927e53193cc0836a0babbefff8a2a20bf24b5e517ece5209089ff0b"
    end
    on_intel do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.12.2/mobai-ci_0.12.2_darwin_amd64.tar.gz"
      sha256 "ac396b0fce19d86319018596f908d1aac9a33eb350c857b7bca85f3e4b9eefb5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.12.2/mobai-ci_0.12.2_linux_arm64.tar.gz"
      sha256 "d8293aab5f00ce8c9254316e985fd5f33f3d71c9936fe67fcba9510873303375"
    end
    on_intel do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.12.2/mobai-ci_0.12.2_linux_amd64.tar.gz"
      sha256 "110e957c78e49b0bfd9ae14050e2fcb64b9fac4a0b73b6f51db39a8accf4a56f"
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
