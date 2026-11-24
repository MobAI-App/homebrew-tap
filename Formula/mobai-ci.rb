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
  version "0.16.2"
  license :cannot_represent

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.16.2/mobai-ci_0.16.2_darwin_arm64.tar.gz"
      sha256 "6b035766a3976107f2e1b8d74ae7d906176113205983cc83ec53b924eed7c148"
    end
    on_intel do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.16.2/mobai-ci_0.16.2_darwin_amd64.tar.gz"
      sha256 "39452eda6b86aebb4d9237e5895e2a169f1db2fd21a29668a983c2a3b5d3d65d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.16.2/mobai-ci_0.16.2_linux_arm64.tar.gz"
      sha256 "383dd742fae8cb0cee206a9eea809571c986864c094b4a584b794b0e04782d73"
    end
    on_intel do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.16.2/mobai-ci_0.16.2_linux_amd64.tar.gz"
      sha256 "d525d80bd88475872ae1b329bba99408d9afa2438d530e59b626e5b685e4f417"
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
