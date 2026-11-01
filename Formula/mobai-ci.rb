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
  version "0.13.2"
  license :cannot_represent

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.13.2/mobai-ci_0.13.2_darwin_arm64.tar.gz"
      sha256 "ef8e9b03cb8837222ba471a39f06c07c62f665c21322f387baf09a81cefb83f6"
    end
    on_intel do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.13.2/mobai-ci_0.13.2_darwin_amd64.tar.gz"
      sha256 "a24fe009d70fe464829d114a480b321159a216b06f3ed8311458f858f3b923c1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.13.2/mobai-ci_0.13.2_linux_arm64.tar.gz"
      sha256 "8dac1a4b2fcac472ea6642e0a3dc51f57f37c457933dd86d5a882516179b72ee"
    end
    on_intel do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.13.2/mobai-ci_0.13.2_linux_amd64.tar.gz"
      sha256 "e504eed89006cadba4e66f29f4cb715251d014326b6900507f769c3883d5c1ab"
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
