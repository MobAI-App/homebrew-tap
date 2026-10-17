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
  version "0.11.0"
  license :cannot_represent

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.11.0/mobai-ci_0.11.0_darwin_arm64.tar.gz"
      sha256 "4ee37128002e434284b1fba2289cdc9b583751edf103fcd5960fb10ff0d9ed01"
    end
    on_intel do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.11.0/mobai-ci_0.11.0_darwin_amd64.tar.gz"
      sha256 "d1c0ae2016ae61e963a43e8c632c9f8c76a77a667818430bcb2f19b0b94b4ece"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.11.0/mobai-ci_0.11.0_linux_arm64.tar.gz"
      sha256 "a784d5a7d2c7d6b277f0d7e19adf4baea6ac0773632412b14a377c0a987f6bb4"
    end
    on_intel do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.11.0/mobai-ci_0.11.0_linux_amd64.tar.gz"
      sha256 "e08a9c454f1feee1ee5d543c381f2284a13909256a53725b6da7690615042c53"
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
