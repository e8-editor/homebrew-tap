# Written by update-formula.sh from E8 0.5.4's release; edit the
# script, not this file.
class E8 < Formula
  desc "Editor that works the way Emacs works, extended in TypeScript"
  homepage "https://github.com/e8-editor/e8"
  version "0.5.4"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://github.com/e8-editor/e8/releases/download/v0.5.4/e8-0.5.4-aarch64-apple-darwin.tar.gz"
      sha256 "abe62e23682c063c0ffeee6b34a74495f684724dcc2fdff83a7b033c982a61bc"

      resource "app" do
        url "https://github.com/e8-editor/e8/releases/download/v0.5.4/E8-0.5.4-aarch64-apple-darwin.app.tar.gz"
        sha256 "a8afb94706b6ee0542208ac4c5e073bf5b73d96167fec7a2fccefe2944e1c2ba"
      end
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/e8-editor/e8/releases/download/v0.5.4/e8-0.5.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ce18c9262955532e5f2cd2e4e405ca2cbfe42d92c6ace59db69b5ef1987dde08"
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
