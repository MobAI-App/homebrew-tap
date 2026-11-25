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
  version "0.17.1"
  license :cannot_represent

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.17.1/mobai-ci_0.17.1_darwin_arm64.tar.gz"
      sha256 "bbd95cb7e7fa7d68e2f40d9f1b0ced5cd8b9f9e4433fbd2fbeafd3c096d07943"
    end
    on_intel do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.17.1/mobai-ci_0.17.1_darwin_amd64.tar.gz"
      sha256 "cbb2c76929259ac894b0c6c1f5498d4381d328816712403651646b02b8fc966b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.17.1/mobai-ci_0.17.1_linux_arm64.tar.gz"
      sha256 "7e5bfee7aa5422e4fdeb0ebb73db55b4a9b02887e871c2429142d7a3818247aa"
    end
    on_intel do
      url "https://github.com/MobAI-App/mobai-ci/releases/download/v0.17.1/mobai-ci_0.17.1_linux_amd64.tar.gz"
      sha256 "586d98c3e2fcefe952f9319973a582b292af1f170d9ecfc28f40495460e9a6aa"
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
