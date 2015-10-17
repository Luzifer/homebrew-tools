require "language/go"

class Diary < Formula
  homepage "https://github.com/Luzifer/diary"
  desc "diary is a small utility to write a personal, encrypted markdown diary"
  url "https://github.com/Luzifer/diary/archive/v0.1.2.tar.gz"
  head "https://github.com/Luzifer/diary.git"
  sha256 "8374f25896980b96f35c94ccf7f0a4f5ce9412b3560c841d53b80737f78c369e"

  depends_on "go" => :build

  go_resource "github.com/Luzifer/go-openssl" do
    url "https://github.com/Luzifer/go-openssl.git",
      :revision => "5c6e7579832374b7acd6bbd2d78e14d758b1f792"
  end

  go_resource "github.com/bgentry/speakeasy" do
    url "https://github.com/bgentry/speakeasy.git",
      :revision => "36e9cfdd690967f4f690c6edcc9ffacd006014a0"
  end

  go_resource "github.com/cpuguy83/go-md2man" do
    url "https://github.com/cpuguy83/go-md2man.git",
      :revision => "71acacd42f85e5e82f70a55327789582a5200a90"
  end

  go_resource "github.com/inconshreveable/mousetrap" do
    url "https://github.com/inconshreveable/mousetrap.git",
      :revision => "76626ae9c91c4f2a10f34cad8ce83ea42c93bb75"
  end

  go_resource "github.com/russross/blackfriday" do
    url "https://github.com/russross/blackfriday.git",
      :revision => "8cec3a854e68dba10faabbe31c089abf4a3e57a6"
  end

  go_resource "github.com/shurcooL/sanitized_anchor_name" do
    url "https://github.com/shurcooL/sanitized_anchor_name.git",
      :revision => "244f5ac324cb97e1987ef901a0081a77bfd8e845"
  end

  go_resource "github.com/spf13/cobra" do
    url "https://github.com/spf13/cobra.git",
      :revision => "d732ab3a34e6e9e6b5bdac80707c2b6bad852936"
  end

  go_resource "github.com/spf13/pflag" do
    url "https://github.com/spf13/pflag.git",
      :revision => "b084184666e02084b8ccb9b704bf0d79c466eb1d"
  end

  go_resource "gopkg.in/yaml.v2" do
    url "https://gopkg.in/yaml.v2.git",
      :revision => "53feefa2559fb8dfa8d81baad31be332c97d6c77"
  end

  def install
    mkdir_p "#{buildpath}/src/github.com/Luzifer/"
    ln_s buildpath, "#{buildpath}/src/github.com/Luzifer/diary"

    ENV["GOPATH"] = buildpath
    ENV.append_path "PATH", "#{ENV["GOPATH"]}/bin"

    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-ldflags", "-X main.version #{version}", "-o", "diary"
    bin.install "diary"
  end

end
