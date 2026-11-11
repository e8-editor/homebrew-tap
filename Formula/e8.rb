# Written by update-formula.sh from E8 0.5.6's release; edit the
# script, not this file.
class E8 < Formula
  desc "Editor that works the way Emacs works, extended in TypeScript"
  homepage "https://github.com/e8-editor/e8"
  version "0.5.6"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://github.com/e8-editor/e8/releases/download/v0.5.6/e8-0.5.6-aarch64-apple-darwin.tar.gz"
      sha256 "2f8362854c80f95725b53e4b43e1bb462e09815e03e240ace7f9173194e37d9b"

      resource "app" do
        url "https://github.com/e8-editor/e8/releases/download/v0.5.6/E8-0.5.6-aarch64-apple-darwin.app.tar.gz"
        sha256 "abe0f96715001d09e59f08e8410cb27bd00f6b2f7612967fbf42f2472b107db6"
      end
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/e8-editor/e8/releases/download/v0.5.6/e8-0.5.6-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "aae6b639819b4058a9c99f8b34eb775d7aa611e07f27cfa3aeaa1c31c80e83ec"
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
