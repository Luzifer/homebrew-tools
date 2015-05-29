require "language/go"

class Password < Formula
  homepage "https://github.com/Luzifer/password"
  desc "password is a fast and secure password generator"
  url "https://github.com/Luzifer/password/archive/v1.3.0.tar.gz"
  head "https://github.com/Luzifer/password.git"
  sha256 "a30ade15d23c47ec1bca74376e921dd1522ce8ceb10739102070e7431f0a6f47"

  depends_on "go" => :build

  go_resource "github.com/gorilla/context" do
    url "https://github.com/gorilla/context.git",
        :revision => "215affda49addc4c8ef7e2534915df2c8c35c6cd"
  end

  go_resource "github.com/gorilla/mux" do
    url "https://github.com/gorilla/mux.git",
        :revision => "8096f47503459bcc74d1f4c487b7e6e42e5746b5"
  end

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
    ln_s buildpath, "#{buildpath}/src/github.com/Luzifer/password"

    ENV["GOPATH"] = buildpath
    ENV.append_path "PATH", "#{ENV["GOPATH"]}/bin"

    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-o", "password"
    bin.install "password"
  end

  test do
    assert_equal "password version #{version}", shell_output("#{bin}/password version").strip
  end
end
