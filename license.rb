require "language/go"

class License < Formula
  homepage "https://github.com/Luzifer/license"
  desc "license is a small helper to add licenses to your work"
  url "https://github.com/Luzifer/license/archive/v1.1.2.tar.gz"
  head "https://github.com/Luzifer/license.git"
  sha256 "37037a9a8640e517c95215ed1c568dcfe25e15b920a1fa8af64cacd39f4044e3"

  depends_on "go" => :build

  go_resource "github.com/inconshreveable/mousetrap" do
    url "https://github.com/inconshreveable/mousetrap.git",
        :revision => "76626ae9c91c4f2a10f34cad8ce83ea42c93bb75"
  end

  go_resource "github.com/spf13/cobra" do
    url "https://github.com/spf13/cobra.git",
        :revision => "bba56042cf767e329430e7c7f68c3f9f640b4b8b"
  end

  go_resource "github.com/spf13/pflag" do
    url "https://github.com/spf13/pflag.git",
        :revision => "f1e68ce945b0710375b5cccee37318a3d13fdf8c"
  end

  def install
    mkdir_p "#{buildpath}/src/github.com/Luzifer/"
    ln_s buildpath, "#{buildpath}/src/github.com/Luzifer/license"

    ENV["GOPATH"] = buildpath
    ENV.append_path "PATH", "#{ENV["GOPATH"]}/bin"

    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-ldflags", "-X main.version #{version}", "-o", "license"
    bin.install "license"
  end

  test do
    assert_equal "license version #{version}", shell_output("#{bin}/license version").strip
  end
end
