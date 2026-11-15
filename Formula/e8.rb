# Written by update-formula.sh from E8 0.5.11's release; edit the
# script, not this file.
class E8 < Formula
  desc "Editor that works the way Emacs works, extended in TypeScript"
  homepage "https://github.com/e8-editor/e8"
  version "0.5.11"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://github.com/e8-editor/e8/releases/download/v0.5.11/e8-0.5.11-aarch64-apple-darwin.tar.gz"
      sha256 "472da3608461f7ece5096cb6a2bbfec4ec04a3a5526434f7c09e3d59043904b4"

      resource "app" do
        url "https://github.com/e8-editor/e8/releases/download/v0.5.11/E8-0.5.11-aarch64-apple-darwin.app.tar.gz"
        sha256 "508ba10881f58fd6bbfdf055dc717572b57270ccc384ae2e001265cda2c8454d"
      end
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/e8-editor/e8/releases/download/v0.5.11/e8-0.5.11-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2d05c7d3056ce6ec0a31c5ad489d493ec0d7b15396ad6e64018fbcacaa94e3e1"
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
