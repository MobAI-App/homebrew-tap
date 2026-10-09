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
  version "0.10.2"
  license :cannot_represent

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.10.2/mobai-ci_0.10.2_darwin_arm64.tar.gz"
      sha256 "aa90d8027b687cdf48721f59b9dcde445a1d1fcfe75f03bc2d6cb7c73d186657"
    end
    on_intel do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.10.2/mobai-ci_0.10.2_darwin_amd64.tar.gz"
      sha256 "8e3f6da0223ce9e590f6aa1055a0032512f2b8832446725de34a8edd9db7c933"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.10.2/mobai-ci_0.10.2_linux_arm64.tar.gz"
      sha256 "d4602e820156ef17b864b6c43c9912face8e4b569871d5bdbb297184c369b4b0"
    end
    on_intel do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.10.2/mobai-ci_0.10.2_linux_amd64.tar.gz"
      sha256 "b79b3ea53d4e8e7df4bf41a97f0dac427c313c0ab79cfa600e87b6304e6f4e30"
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
