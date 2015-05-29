require "language/go"

class License < Formula
  homepage "https://github.com/Luzifer/license"
  desc "license is a small helper to add licenses to your work"
  url "https://github.com/Luzifer/license/archive/v1.0.0.tar.gz"
  head "https://github.com/Luzifer/license.git"
  sha256 "eeffc14c8ee561bafc8167d7676accb15f584bb909a93a7002c7cd3fd9261141"

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
    system "go", "build", "-o", "license"
    bin.install "license"
  end

  test do
    assert_equal "license version #{version}", shell_output("#{bin}/license version").strip
  end
end
