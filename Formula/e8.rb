# Written by update-formula.sh from E8 0.5.8's release; edit the
# script, not this file.
class E8 < Formula
  desc "Editor that works the way Emacs works, extended in TypeScript"
  homepage "https://github.com/e8-editor/e8"
  version "0.5.8"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://github.com/e8-editor/e8/releases/download/v0.5.8/e8-0.5.8-aarch64-apple-darwin.tar.gz"
      sha256 "3bd63ee1fb6d81bc6a7af1b39ce6721bfd8984b09167cf0658bd1ce0e78ee697"

      resource "app" do
        url "https://github.com/e8-editor/e8/releases/download/v0.5.8/E8-0.5.8-aarch64-apple-darwin.app.tar.gz"
        sha256 "831be10a4b061ec5b26ce8d97b54097fc3bc8a638af2873451ec465b32ce7b3c"
      end
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/e8-editor/e8/releases/download/v0.5.8/e8-0.5.8-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "28d8c5398d17699bbb64537752cf51ecbd9169b00a00620cea7704d384c8fd90"
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
