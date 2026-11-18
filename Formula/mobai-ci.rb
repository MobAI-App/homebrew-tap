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
  version "0.15.2"
  license :cannot_represent

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.15.2/mobai-ci_0.15.2_darwin_arm64.tar.gz"
      sha256 "0a05cb2c7b71b89c508a43a06e870ad5de6a1bd6b03cdfc3cb0993b0d84c7b69"
    end
    on_intel do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.15.2/mobai-ci_0.15.2_darwin_amd64.tar.gz"
      sha256 "5b684bef62c04a1c534c6494cd5901043b451610954b5d690103337d6da27698"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.15.2/mobai-ci_0.15.2_linux_arm64.tar.gz"
      sha256 "dcff02bc816e55c40746c32792b86edc06a01a66e7545776712c56a116eac305"
    end
    on_intel do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.15.2/mobai-ci_0.15.2_linux_amd64.tar.gz"
      sha256 "e449af58d5790b5d2bacf0100242f90c2c20a7f97a2982c661f4492fc8d3df69"
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
