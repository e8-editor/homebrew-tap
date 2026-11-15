# Written by update-formula.sh from E8 0.5.12's release; edit the
# script, not this file.
class E8 < Formula
  desc "Editor that works the way Emacs works, extended in TypeScript"
  homepage "https://github.com/e8-editor/e8"
  version "0.5.12"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://github.com/e8-editor/e8/releases/download/v0.5.12/e8-0.5.12-aarch64-apple-darwin.tar.gz"
      sha256 "d2d56e48ae90da157bdafe1da30ecfee07a3c49a9e7fc43b4cfd519cfb7e3517"

      resource "app" do
        url "https://github.com/e8-editor/e8/releases/download/v0.5.12/E8-0.5.12-aarch64-apple-darwin.app.tar.gz"
        sha256 "6f7040ee19de1bf21441d2a953d06a8c8750d19a2be1d1401f5df608a48145fd"
      end
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/e8-editor/e8/releases/download/v0.5.12/e8-0.5.12-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "26f6d5b7a06ac4cf31b9d704ee06746b803bbefa11197c90c71f4d1f3aaf9c26"
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
