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
  version "0.18.3"
  license :cannot_represent

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.18.3/mobai-ci_0.18.3_darwin_arm64.tar.gz"
      sha256 "edf1883f7a338306e34d94b9c0e004df512c3515512f00c5f26db166e18d956d"
    end
    on_intel do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.18.3/mobai-ci_0.18.3_darwin_amd64.tar.gz"
      sha256 "04210450d23d856fbe5b34a3d97c6898fc95522a4ca70186bf03f53c9980de82"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.18.3/mobai-ci_0.18.3_linux_arm64.tar.gz"
      sha256 "ded477595e7e0ac60bcbac329259abc7871129f14253124d7490665fa4246d54"
    end
    on_intel do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.18.3/mobai-ci_0.18.3_linux_amd64.tar.gz"
      sha256 "2c68af4161bac2d845304b404cf9ddd05e290790c804d570b66766b80195f101"
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
