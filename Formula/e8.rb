# Written by update-formula.sh from E8 0.5.1's release; edit the
# script, not this file.
class E8 < Formula
  desc "Editor that works the way Emacs works, extended in TypeScript"
  homepage "https://github.com/e8-editor/e8"
  version "0.5.1"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://github.com/e8-editor/e8/releases/download/v0.5.1/e8-0.5.1-aarch64-apple-darwin.tar.gz"
      sha256 "d08de57eab709516649327c27291350f0791c3230a7d3baafac244e03dd6c611"

      resource "app" do
        url "https://github.com/e8-editor/e8/releases/download/v0.5.1/E8-0.5.1-aarch64-apple-darwin.app.tar.gz"
        sha256 "606e2a295aa658b96ffdfeeb7a645cfdc8dc331b2189f672163861059b363ccf"
      end
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/e8-editor/e8/releases/download/v0.5.1/e8-0.5.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0a60f8d3341eb5614614abe94836e4d1905ef39c1af749529a9caba6f002c160"
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
