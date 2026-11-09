# Written by update-formula.sh from E8 0.5.2's release; edit the
# script, not this file.
class E8 < Formula
  desc "Editor that works the way Emacs works, extended in TypeScript"
  homepage "https://github.com/e8-editor/e8"
  version "0.5.2"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://github.com/e8-editor/e8/releases/download/v0.5.2/e8-0.5.2-aarch64-apple-darwin.tar.gz"
      sha256 "4234cfd34b198ef3659e8057f3065dfb8cc845c4d827c0b7192bba17ff778057"

      resource "app" do
        url "https://github.com/e8-editor/e8/releases/download/v0.5.2/E8-0.5.2-aarch64-apple-darwin.app.tar.gz"
        sha256 "fd1f56ac6de41f9a915b0b4d31c79c7b2252672a3d32ae9b85e7b2f7694fd0d2"
      end
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/e8-editor/e8/releases/download/v0.5.2/e8-0.5.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "26e859d5f1660539b1415b6a1d189b08703758926bb3039859477c4c54f4d601"
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
