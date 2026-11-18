# Written by update-formula.sh from E8 0.5.18's release; edit the
# script, not this file.
class E8 < Formula
  desc "Editor that works the way Emacs works, extended in TypeScript"
  homepage "https://github.com/e8-editor/e8"
  version "0.5.18"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://github.com/e8-editor/e8/releases/download/v0.5.18/e8-0.5.18-aarch64-apple-darwin.tar.gz"
      sha256 "b3fda482a46ff598fb091b0e42a442ced903001a1efb56571997d5e2f1891c82"

      resource "app" do
        url "https://github.com/e8-editor/e8/releases/download/v0.5.18/E8-0.5.18-aarch64-apple-darwin.app.tar.gz"
        sha256 "c9aa49928071e5a90c59abd3da207540e761444228453cb0cf780cfa029cc67e"
      end
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/e8-editor/e8/releases/download/v0.5.18/e8-0.5.18-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "cc238ead4187e011c3b46d85a1b94efb3fa8e1be17b63e4a56eddb55985b1668"
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
