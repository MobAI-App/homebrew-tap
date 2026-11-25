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
  version "0.17.0"
  license :cannot_represent

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.17.0/mobai-ci_0.17.0_darwin_arm64.tar.gz"
      sha256 "570d8b005a0cd5448fca948639b7225239b5072ada480430636edaa8fe48da0d"
    end
    on_intel do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.17.0/mobai-ci_0.17.0_darwin_amd64.tar.gz"
      sha256 "2b152bbf4d5f3b322ce3c92a66af5e6f3757dcdd9e0c6ad852a47075365e20cd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.17.0/mobai-ci_0.17.0_linux_arm64.tar.gz"
      sha256 "2b295aa4d180fe0842e7e95941e079b021a7a0c89ec9094613e679112584f07e"
    end
    on_intel do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.17.0/mobai-ci_0.17.0_linux_amd64.tar.gz"
      sha256 "ec0af65f98e643aa973dfaaccfd43ce859939909b33f042f1661f8fd550322d9"
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
