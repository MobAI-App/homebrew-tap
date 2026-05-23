# Formula for simtime — control the wall-clock an iOS Simulator app sees.
#
# After each release, update `version` and `sha256` to match the values from
# the simtime release workflow (see .github/workflows/release.yml in the
# simtime repo). The sha256 is published next to the tarball as
# `simtime-v<version>-macos-arm64.tar.gz.sha256`.
class Simtime < Formula
  desc "Control the wall-clock an iOS Simulator app sees (freeze/travel/scale)"
  homepage "https://github.com/MobAI-App/simtime"
  url "https://github.com/MobAI-App/simtime/releases/download/v0.1.0/simtime-v0.1.0-macos-arm64.tar.gz"
  version "0.1.0"
  sha256 "0ebcc9486d76c8e33ab4c67469ed005b132d87c02f9e49ac03daa186df36fa22"
  license "Apache-2.0"

  # The runtime dylib is built against the iOS Simulator SDK and only loads
  # into simulator processes, so this is intrinsically macOS + Xcode-only.
  # arm64-only for now; add an Intel block once CI ships an x86_64 build.
  depends_on arch: :arm64
  depends_on macos: :sonoma # macOS 14.0+

  def install
    # The real binary + the runtime dylib both live under libexec; a tiny
    # wrapper in bin/ exports SIMTIME_DYLIB so `simtime inject` finds the
    # brew-installed copy without the user having to set anything.
    libexec.install "simtime" => "simtime-bin"
    libexec.install "libsimtime.dylib"
    (bin/"simtime").write <<~SH
      #!/bin/sh
      : "${SIMTIME_DYLIB:=#{libexec}/libsimtime.dylib}"
      export SIMTIME_DYLIB
      exec "#{libexec}/simtime-bin" "$@"
    SH
    chmod 0755, bin/"simtime"
  end

  def caveats
    <<~EOS
      simtime targets the iOS Simulator only (Apple does not allow
      DYLD_INSERT_LIBRARIES on real devices without jailbreak).

      The Obj-C runtime that gets injected into the target app lives at:
        #{opt_libexec}/libsimtime.dylib

      Typical flow:
        UDID=<your-sim-udid>
        APP=com.example.app
        simtime inject --udid $UDID --bundle $APP
        simtime freeze --udid $UDID --bundle $APP "2026-01-01T10:00:00Z"
        simtime travel --udid $UDID --bundle $APP "+8d"
        simtime scale  --udid $UDID --bundle $APP 60
        simtime reset  --udid $UDID --bundle $APP

      Note: this binary is ad-hoc signed. Each `brew upgrade simtime`
      produces a fresh identity, so any signed-binary system prompts will
      re-appear on upgrade.
    EOS
  end

  test do
    # `simtime --help` is the safest non-stateful smoke check.
    assert_match "USAGE: simtime", shell_output("#{bin}/simtime --help")
    # Verify the wrapper points at a real dylib in the cellar.
    assert_path_exists libexec/"libsimtime.dylib"
  end
end
