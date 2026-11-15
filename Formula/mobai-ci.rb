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
  version "0.14.0"
  license :cannot_represent

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.14.0/mobai-ci_0.14.0_darwin_arm64.tar.gz"
      sha256 "fe7ef8f63e4aa1fd09131a1b47c7ca448201b937e7d1ce0bec41ef92f847733f"
    end
    on_intel do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.14.0/mobai-ci_0.14.0_darwin_amd64.tar.gz"
      sha256 "4d4e7cc3c689f85f81047e3cc73c898d065f44c51210b93d6c6a26a6a153eb5f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.14.0/mobai-ci_0.14.0_linux_arm64.tar.gz"
      sha256 "a8517d67cec73e051e226829ca029a70a18aa06d15a0a3ad78278cf955e2f8f5"
    end
    on_intel do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.14.0/mobai-ci_0.14.0_linux_amd64.tar.gz"
      sha256 "0c1454d72cdaffb36a4e20870f1e856a3d11714a3014c0d90ca042b6fb25c792"
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
