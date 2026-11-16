# Written by update-formula.sh from E8 0.5.15's release; edit the
# script, not this file.
class E8 < Formula
  desc "Editor that works the way Emacs works, extended in TypeScript"
  homepage "https://github.com/e8-editor/e8"
  version "0.5.15"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://github.com/e8-editor/e8/releases/download/v0.5.15/e8-0.5.15-aarch64-apple-darwin.tar.gz"
      sha256 "8909c516952c0d7924be0dcb7460276667751833df582a5c15acf3806e56b13d"

      resource "app" do
        url "https://github.com/e8-editor/e8/releases/download/v0.5.15/E8-0.5.15-aarch64-apple-darwin.app.tar.gz"
        sha256 "957f53ee1c82e726b4862e937c2efaabf05b573a5e9ef4172185466d91bf294a"
      end
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/e8-editor/e8/releases/download/v0.5.15/e8-0.5.15-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1c935c3be469363654197b7b03e1ffffcda87eeb7c50913b13949d0d440d7442"
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
