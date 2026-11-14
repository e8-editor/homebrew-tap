# Written by update-formula.sh from E8 0.5.10's release; edit the
# script, not this file.
class E8 < Formula
  desc "Editor that works the way Emacs works, extended in TypeScript"
  homepage "https://github.com/e8-editor/e8"
  version "0.5.10"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://github.com/e8-editor/e8/releases/download/v0.5.10/e8-0.5.10-aarch64-apple-darwin.tar.gz"
      sha256 "adc24e81d0e33899ec0a5c1d07c9b5e762f16e5d7a663a2978d2d34aac28e9b1"

      resource "app" do
        url "https://github.com/e8-editor/e8/releases/download/v0.5.10/E8-0.5.10-aarch64-apple-darwin.app.tar.gz"
        sha256 "bddbe24fb83dca0270f9d8ea4d633e9696f643dbb3d5b7d369dc4a4954719b46"
      end
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/e8-editor/e8/releases/download/v0.5.10/e8-0.5.10-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e880cdc9d1139773ad8d12e727e519a3fbd33cb27831a80a6da3b0fcebb06fe8"
    end
  end

  def install
    bin.install "e8", "e8-mcp"
    # Homebrew strips the one folder at the top of the tarball, E8.app,
    # when it unpacks it, so the app is staged into a folder of that name.
    resource("app").stage(prefix/"E8.app") if OS.mac? && resources.any? { |r| r.name == "app" }
  end

  def caveats
    return unless (opt_prefix/"E8.app").exist?

    <<~EOS
      The window version is E8.app, in #{opt_prefix}. To open it from
      Launchpad and Spotlight, link it into /Applications:
        ln -sf #{opt_prefix}/E8.app /Applications/E8.app
    EOS
  end

  test do
    output = shell_output("#{bin}/e8 --batch --eval 'e8.message(e8.variable(\"e8-version\"))' 2>&1")
    assert_equal version.to_s, output.strip
  end
end
