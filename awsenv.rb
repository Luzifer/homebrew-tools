require "language/go"

class Awsenv < Formula
  desc "is a credential store for people with multiple AWS accounts"
  homepage "https://github.com/Luzifer/awsenv"
  url "https://github.com/Luzifer/awsenv/archive/v0.8.0.tar.gz"
  sha256 "84d64ea95b94425f4a83813a3b64192e9bfe25cf16ba61a1a86e31f27e6bd485"
  head "https://github.com/Luzifer/awsenv.git"

  depends_on "go" => :build

  go_resource "github.com/Sirupsen/logrus" do
    url "https://github.com/Sirupsen/logrus.git",
      :revision => "418b41d23a1bf978c06faea5313ba194650ac088"
  end

  go_resource "github.com/aws/aws-sdk-go" do
    url "https://github.com/aws/aws-sdk-go.git",
      :revision => "661aeb3339ad9bd5fd420752ebf18a651d40413e"
  end

  go_resource "github.com/bgentry/speakeasy" do
    url "https://github.com/bgentry/speakeasy.git",
      :revision => "36e9cfdd690967f4f690c6edcc9ffacd006014a0"
  end

  go_resource "github.com/cpuguy83/go-md2man" do
    url "https://github.com/cpuguy83/go-md2man.git",
      :revision => "71acacd42f85e5e82f70a55327789582a5200a90"
  end

  go_resource "github.com/gorilla/context" do
    url "https://github.com/gorilla/context.git",
      :revision => "1c83b3eabd45b6d76072b66b746c20815fb2872d"
  end

  go_resource "github.com/gorilla/mux" do
    url "https://github.com/gorilla/mux.git",
      :revision => "49c024275504f0341e5a9971eb7ba7fa3dc7af40"
  end

  go_resource "github.com/inconshreveable/mousetrap" do
    url "https://github.com/inconshreveable/mousetrap.git",
      :revision => "76626ae9c91c4f2a10f34cad8ce83ea42c93bb75"
  end

  go_resource "github.com/russross/blackfriday" do
    url "https://github.com/russross/blackfriday.git",
      :revision => "8cec3a854e68dba10faabbe31c089abf4a3e57a6"
  end

  go_resource "github.com/satori/go.uuid" do
    url "https://github.com/satori/go.uuid.git",
      :revision => "08f0718b61e95ddba0ade3346725fe0e4bf28ca6"
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

  go_resource "github.com/vaughan0/go-ini" do
    url "https://github.com/vaughan0/go-ini.git",
      :revision => "a98ad7ee00ec53921f08832bc06ecf7fd600e6a1"
  end

  go_resource "gopkg.in/yaml.v2" do
    url "https://gopkg.in/yaml.v2.git",
      :revision => "53feefa2559fb8dfa8d81baad31be332c97d6c77"
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
