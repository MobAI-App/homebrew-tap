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
  version "0.18.4"
  license :cannot_represent

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.18.4/mobai-ci_0.18.4_darwin_arm64.tar.gz"
      sha256 "2fc886ecf0de8f028bd1db41439511fa37e5903cfe0997d320dca363b04c02bf"
    end
    on_intel do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.18.4/mobai-ci_0.18.4_darwin_amd64.tar.gz"
      sha256 "0bfea6907395c0958936454102219df804051b4ab01a7a492c9a50d849c4170a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.18.4/mobai-ci_0.18.4_linux_arm64.tar.gz"
      sha256 "4b68251d06176226f336cd2d70ff1e5b722e2e0a7b72f6e0ee4ff79c4952188f"
    end
    on_intel do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.18.4/mobai-ci_0.18.4_linux_amd64.tar.gz"
      sha256 "57f5bdbc3c468fd3b0cf9ea5a515a40c700ccee0bf5ceb389458d51086343b48"
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
