# Written by update-formula.sh from E8 0.5.0's release; edit the
# script, not this file.
class E8 < Formula
  desc "Editor that works the way Emacs works, extended in TypeScript"
  homepage "https://github.com/e8-editor/e8"
  version "0.5.0"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://github.com/e8-editor/e8/releases/download/v0.5.0/e8-0.5.0-aarch64-apple-darwin.tar.gz"
      sha256 "6569b5969892b4d56d7380b75edc57b23460388defde594b07f0ccd187eb8bbe"

      resource "app" do
        url "https://github.com/e8-editor/e8/releases/download/v0.5.0/E8-0.5.0-aarch64-apple-darwin.app.tar.gz"
        sha256 "67e01a12c3b6bfd4f76c66bac58072bb8a89259234caf35751e8e6cb8227552f"
      end
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/e8-editor/e8/releases/download/v0.5.0/e8-0.5.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5da9e022d86a5d046645d324c243717ec6ec16b1e52932dcfd78f280016f096b"
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
