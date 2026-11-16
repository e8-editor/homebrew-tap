# Written by update-formula.sh from E8 0.5.14's release; edit the
# script, not this file.
class E8 < Formula
  desc "Editor that works the way Emacs works, extended in TypeScript"
  homepage "https://github.com/e8-editor/e8"
  version "0.5.14"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://github.com/e8-editor/e8/releases/download/v0.5.14/e8-0.5.14-aarch64-apple-darwin.tar.gz"
      sha256 "a6d8fe4ed4a099afef160b2d394df63c0f4d10113e0084ad3bd4cf94088df1c1"

      resource "app" do
        url "https://github.com/e8-editor/e8/releases/download/v0.5.14/E8-0.5.14-aarch64-apple-darwin.app.tar.gz"
        sha256 "1320c9f385bfd13ae44d3ebe8155f6c50b86dd6b926a3b2caddd6fb6f8b2594e"
      end
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/e8-editor/e8/releases/download/v0.5.14/e8-0.5.14-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "76b470cb656f36f661c61318d6f005c4691aeea99a32735677c8de7e3235b342"
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
