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
  version "0.16.1"
  license :cannot_represent

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.16.1/mobai-ci_0.16.1_darwin_arm64.tar.gz"
      sha256 "fbbe76b7a2552cb3da39f9cc9aedbb8615eadfc1d28ab2c93fd1b248438eb128"
    end
    on_intel do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.16.1/mobai-ci_0.16.1_darwin_amd64.tar.gz"
      sha256 "17c803dd7a7b5fad79eecfd29b7c19487bb470b34094e8c0ee508261ed5ac84d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.16.1/mobai-ci_0.16.1_linux_arm64.tar.gz"
      sha256 "62c2a822647e558638421927e969fc215e849b69814f5488db69fe9e4b9ab712"
    end
    on_intel do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.16.1/mobai-ci_0.16.1_linux_amd64.tar.gz"
      sha256 "637e9cdd11b154d2f5589d795eaddd91b09c03c748647af2a07146bc9b86790a"
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
