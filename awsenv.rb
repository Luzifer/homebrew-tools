require "language/go"

class Awsenv < Formula
  homepage "https://github.com/Luzifer/awsenv"
  desc "awsenv is a credential store for people using one or more AWS account"
  url "https://github.com/Luzifer/awsenv/archive/v0.5.1.tar.gz"
  head "https://github.com/Luzifer/awsenv.git"
  sha256 "5c3ea9071c6ad3120b314ac04086b36b4d8e12051c33bd2a6e2ba3925725b0da"

  depends_on "go" => :build

  go_resource "github.com/Sirupsen/logrus" do
    url "https://github.com/Sirupsen/logrus.git",
        :revision => "55eb11d21d2a31a3cc93838241d04800f52e823d"
  end

  go_resource "github.com/aws/aws-sdk-go" do
    url "https://github.com/aws/aws-sdk-go.git",
        :revision => "8bdb2521482f442bbab55cc9f716231d69565581"
  end

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

  go_resource "github.com/satori/go.uuid" do
    url "https://github.com/satori/go.uuid.git",
        :revision => "242673bbc820e051ef00033e274d32e08ece9e15"
  end

  go_resource "github.com/spf13/cobra" do
    url "https://github.com/spf13/cobra.git",
        :revision => "bba56042cf767e329430e7c7f68c3f9f640b4b8b"
  end

  go_resource "github.com/spf13/pflag" do
    url "https://github.com/spf13/pflag.git",
        :revision => "f1e68ce945b0710375b5cccee37318a3d13fdf8c"
  end

  go_resource "github.com/vaughan0/go-ini" do
    url "https://github.com/vaughan0/go-ini.git",
        :revision => "a98ad7ee00ec53921f08832bc06ecf7fd600e6a1"
  end

  go_resource "gopkg.in/yaml.v2" do
    url "https://gopkg.in/yaml.v2.git",
        :revision => "49c95bdc21843256fb6c4e0d370a05f24a0bf213"
  end

  def install
    mkdir_p "#{buildpath}/src/github.com/Luzifer/"
    ln_s buildpath, "#{buildpath}/src/github.com/Luzifer/awsenv"

    ENV["GOPATH"] = buildpath
    ENV.append_path "PATH", "#{ENV["GOPATH"]}/bin"

    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-ldflags", "-X main.version #{version}", "-o", "awsenv"
    bin.install "awsenv"
  end

  test do
    assert_equal "awsenv version #{version}", shell_output("#{bin}/awsenv version").strip

    # Check for a clean environment not to overwrite existing data
    assert(!File.exist?("#{ENV["HOME"]}/.config/awsenv"), "Database is not expected to exist in test")

    # Write an environment to the password database
    system "#{bin}/awsenv", "--password=test123", "add", "demoenv", "-a", "keytest", "-s", "secrettest", "-r", "eu-west-1"
    assert(File.exist?("#{ENV["HOME"]}/.config/awsenv"), "Database is expected to be available after first write")

    # Check the contents are available
    assert_equal true, shell_output("#{bin}/awsenv --password=test123 list").include?("demoenv")
    assert_equal true, shell_output("#{bin}/awsenv --password=test123 get demoenv").include?("AWS Access-Key:        keytest")

    # Delete demo env
    system "#{bin}/awsenv", "--password=test123", "delete", "demoenv"

    # Check it is not longer available
    assert_equal false, shell_output("#{bin}/awsenv --password=test123 list").include?("demoenv")

    # Test for travis
  end
end
