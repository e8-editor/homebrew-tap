# Written by update-formula.sh from E8 0.5.9's release; edit the
# script, not this file.
class E8 < Formula
  desc "Editor that works the way Emacs works, extended in TypeScript"
  homepage "https://github.com/e8-editor/e8"
  version "0.5.9"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://github.com/e8-editor/e8/releases/download/v0.5.9/e8-0.5.9-aarch64-apple-darwin.tar.gz"
      sha256 "abfbdecee9fff7b08df76b940cc007d0978df366365efa0f42d5bef7b7ca00bc"

      resource "app" do
        url "https://github.com/e8-editor/e8/releases/download/v0.5.9/E8-0.5.9-aarch64-apple-darwin.app.tar.gz"
        sha256 "a027c379f86a622f891fb7ac89abe975fbe98eb31b6aa9119ef925cee0926cf6"
      end
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/e8-editor/e8/releases/download/v0.5.9/e8-0.5.9-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4738719c904ab9705eb0bc3dd9acf69b1d4250a36c002c9ef95f8fbd0716e465"
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
