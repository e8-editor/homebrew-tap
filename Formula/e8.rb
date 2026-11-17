# Written by update-formula.sh from E8 0.5.16's release; edit the
# script, not this file.
class E8 < Formula
  desc "Editor that works the way Emacs works, extended in TypeScript"
  homepage "https://github.com/e8-editor/e8"
  version "0.5.16"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://github.com/e8-editor/e8/releases/download/v0.5.16/e8-0.5.16-aarch64-apple-darwin.tar.gz"
      sha256 "c8b44346bbf25ab0eda747b004646fb4d987ef7c8cac587c2405c6df0344c727"

      resource "app" do
        url "https://github.com/e8-editor/e8/releases/download/v0.5.16/E8-0.5.16-aarch64-apple-darwin.app.tar.gz"
        sha256 "92e9856799113fcf933c810bac9e35b44c05a37037654d2ef85de6b4d502c5ae"
      end
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/e8-editor/e8/releases/download/v0.5.16/e8-0.5.16-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7cedee5dcfee9b3b1c36ac4dd0153f70d9075aed0d7e90ba6982dbf1b8a69660"
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
