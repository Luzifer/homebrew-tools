class Awsenv < Formula
  desc "is a credential store for people with multiple AWS accounts"
  homepage "https://github.com/Luzifer/awsenv"
  url "https://github.com/Luzifer/awsenv/archive/v0.11.0.tar.gz"
  sha256 "23b4f89eb7c6fdd0624bb9cb2e8826cdfb580fdc2711ae399d79c61abc5df597"
  head "https://github.com/Luzifer/awsenv.git"

  depends_on "go" => :build

  def install
    mkdir_p "#{buildpath}/src/github.com/Luzifer/"
    ln_s buildpath, "#{buildpath}/src/github.com/Luzifer/awsenv"

    ENV["GOPATH"] = buildpath

    system "go", "install", "-ldflags", "-X main.version #{version}", "github.com/Luzifer/awsenv"
    bin.install "#{buildpath}/bin/awsenv"
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
