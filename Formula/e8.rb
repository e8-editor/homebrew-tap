# Written by update-formula.sh from E8 0.5.7's release; edit the
# script, not this file.
class E8 < Formula
  desc "Editor that works the way Emacs works, extended in TypeScript"
  homepage "https://github.com/e8-editor/e8"
  version "0.5.7"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://github.com/e8-editor/e8/releases/download/v0.5.7/e8-0.5.7-aarch64-apple-darwin.tar.gz"
      sha256 "386ea75f9d64bda650d5d63fd2278aceb41dcca7b6de8f0f74227122b86d3b5b"

      resource "app" do
        url "https://github.com/e8-editor/e8/releases/download/v0.5.7/E8-0.5.7-aarch64-apple-darwin.app.tar.gz"
        sha256 "cd761f29893b689ec9637fdd4170dfa8655911b77ec671e407c03168ab7c3b5c"
      end
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/e8-editor/e8/releases/download/v0.5.7/e8-0.5.7-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "24c0f6c5d5c4ea71eb1f4b39108a1a9e475bce6a05507fce7481c89f3275f6e1"
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
