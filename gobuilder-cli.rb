require "language/go"

class GobuilderCli < Formula
  homepage "https://gobuilder.me/github.com/Luzifer/gobuilder/cmd/gobuilder-cli"
  desc "control GoBuilder.me from CLI"
  url "https://github.com/Luzifer/gobuilder/archive/v1.24.0.tar.gz"
  head "https://github.com/Luzifer/gobuilder.git"
  sha256 "d4977063820bf40e631c4ddc899e0095b71da435838076d90e5d8748d7c1713d"

  depends_on "go" => :build

  go_resource "github.com/inconshreveable/mousetrap" do
    url "https://github.com/inconshreveable/mousetrap.git",
        :revision => "76626ae9c91c4f2a10f34cad8ce83ea42c93bb75"
  end

  go_resource "github.com/spf13/cobra" do
    url "https://github.com/spf13/cobra.git",
        :revision => "385fc87e4343efec233811d3d933509e8975d11a"
  end

  go_resource "github.com/spf13/pflag" do
    url "https://github.com/spf13/pflag.git",
        :revision => "67cbc198fd11dab704b214c1e629a97af392c085"
  end

  def install
    mkdir_p "#{buildpath}/src/github.com/Luzifer/"
    ln_s buildpath, "#{buildpath}/src/github.com/Luzifer/gobuilder"

    cd "#{buildpath}/src/github.com/Luzifer/gobuilder/cmd/gobuilder-cli"

    ENV["GOPATH"] = buildpath
    ENV.append_path "PATH", "#{ENV["GOPATH"]}/bin"

    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-o", "gobuilder-cli"
    bin.install "gobuilder-cli"
  end
end
