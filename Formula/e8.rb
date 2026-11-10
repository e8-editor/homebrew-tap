# Written by update-formula.sh from E8 0.5.3's release; edit the
# script, not this file.
class E8 < Formula
  desc "Editor that works the way Emacs works, extended in TypeScript"
  homepage "https://github.com/e8-editor/e8"
  version "0.5.3"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://github.com/e8-editor/e8/releases/download/v0.5.3/e8-0.5.3-aarch64-apple-darwin.tar.gz"
      sha256 "50fffdc0c083e0eb11024b245f303900aa70de447ee04191972c9593a210fb91"

      resource "app" do
        url "https://github.com/e8-editor/e8/releases/download/v0.5.3/E8-0.5.3-aarch64-apple-darwin.app.tar.gz"
        sha256 "008dd7b6605272ad246cb89e2160554804c750029ae9f3832b9232cc3b7c4b05"
      end
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/e8-editor/e8/releases/download/v0.5.3/e8-0.5.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "516261fc00e66e56e141f40de0d2cc2cf0bcb4f462e5ef351712778c07720ad8"
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
