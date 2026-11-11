# Written by update-formula.sh from E8 0.5.5's release; edit the
# script, not this file.
class E8 < Formula
  desc "Editor that works the way Emacs works, extended in TypeScript"
  homepage "https://github.com/e8-editor/e8"
  version "0.5.5"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://github.com/e8-editor/e8/releases/download/v0.5.5/e8-0.5.5-aarch64-apple-darwin.tar.gz"
      sha256 "8928d11573456071cd198194444b6c5844f3674aa65763c6c7531018d5503fff"

      resource "app" do
        url "https://github.com/e8-editor/e8/releases/download/v0.5.5/E8-0.5.5-aarch64-apple-darwin.app.tar.gz"
        sha256 "08fb89b8b1759f4b99085324a6fff3a52ccf6c9f54fe5b360f65b1bd507a2ea1"
      end
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/e8-editor/e8/releases/download/v0.5.5/e8-0.5.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "35d4eb8c866afc46e324ed3f82b19f95bdafcf1b092fe441f36ef5b8c173bb67"
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
