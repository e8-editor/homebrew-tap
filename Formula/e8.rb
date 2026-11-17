# Written by update-formula.sh from E8 0.5.17's release; edit the
# script, not this file.
class E8 < Formula
  desc "Editor that works the way Emacs works, extended in TypeScript"
  homepage "https://github.com/e8-editor/e8"
  version "0.5.17"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://github.com/e8-editor/e8/releases/download/v0.5.17/e8-0.5.17-aarch64-apple-darwin.tar.gz"
      sha256 "aaafe90505877a3073ddac36287f0c7dd74010d94cc4a76fea8f8d717c21c63b"

      resource "app" do
        url "https://github.com/e8-editor/e8/releases/download/v0.5.17/E8-0.5.17-aarch64-apple-darwin.app.tar.gz"
        sha256 "331400893ba1c6a4d33780d34404de28669dd9934721eabfba713f975c69301f"
      end
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/e8-editor/e8/releases/download/v0.5.17/e8-0.5.17-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e9e27a8523d1e2c5ae5ea184c80256f6fdb95473c77517f0b75cba52fd9a825b"
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
