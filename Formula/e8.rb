# Written by update-formula.sh from E8 0.5.13's release; edit the
# script, not this file.
class E8 < Formula
  desc "Editor that works the way Emacs works, extended in TypeScript"
  homepage "https://github.com/e8-editor/e8"
  version "0.5.13"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://github.com/e8-editor/e8/releases/download/v0.5.13/e8-0.5.13-aarch64-apple-darwin.tar.gz"
      sha256 "0b018bf8bba207e0d1ce81b2842aab87f389e02ca676b78b7bc05598588db64d"

      resource "app" do
        url "https://github.com/e8-editor/e8/releases/download/v0.5.13/E8-0.5.13-aarch64-apple-darwin.app.tar.gz"
        sha256 "1849ab5b6c09c48dccc3ad799646bf6e76caee25879c4b2ee100394949f9c976"
      end
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/e8-editor/e8/releases/download/v0.5.13/e8-0.5.13-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b9b716f138ae87d60248e1cfebb75be47d8caf87b8333a999da5196f93a3a430"
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
