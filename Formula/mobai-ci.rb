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
  version "0.15.3"
  license :cannot_represent

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.15.3/mobai-ci_0.15.3_darwin_arm64.tar.gz"
      sha256 "a8c82b31c5381469508aa826e8f65025cd125dfae0ab3bea61bcd97b0f650e45"
    end
    on_intel do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.15.3/mobai-ci_0.15.3_darwin_amd64.tar.gz"
      sha256 "01d8d1a7023f3cb053422730745169b26e41e248732a35aa38e45423a3a76f42"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.15.3/mobai-ci_0.15.3_linux_arm64.tar.gz"
      sha256 "2f743306f4f8328a29bbc835a6e456e8c9b550787ec32b65e7c496bd15a34730"
    end
    on_intel do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.15.3/mobai-ci_0.15.3_linux_amd64.tar.gz"
      sha256 "a577a2813298cf86ed4355360eb264743954dff3f4710c5a00833e1c6e6e207c"
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
