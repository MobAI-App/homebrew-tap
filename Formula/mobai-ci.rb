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
  version "0.18.0"
  license :cannot_represent

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.18.0/mobai-ci_0.18.0_darwin_arm64.tar.gz"
      sha256 "9f5882241854c8e4b509898947294b93730b7810cedcdd772d2f85c3119d6bce"
    end
    on_intel do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.18.0/mobai-ci_0.18.0_darwin_amd64.tar.gz"
      sha256 "a22088ee93e8d91d8934831babaac76e5694beb2b817fa33263efa146e995991"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.18.0/mobai-ci_0.18.0_linux_arm64.tar.gz"
      sha256 "248a34b6b29b198d6a4a9337847cebb8eebd0c015091076db7eb7cb295746f05"
    end
    on_intel do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.18.0/mobai-ci_0.18.0_linux_amd64.tar.gz"
      sha256 "cd7e6945eb88ea81613322ef2b613cab42e6dfabef26780bcd444136cee3b46e"
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
