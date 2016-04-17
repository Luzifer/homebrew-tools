class GimmeEc2 < Formula
  desc "is a small utility to spawn a throw-away-ec2"
  homepage "https://github.com/Luzifer/gimme_ec2"
  url "https://github.com/Luzifer/gimme_ec2/archive/v0.1.3.tar.gz"
  sha256 "fdad153b71135a6b6f13d570fed8ee7e289aaf6ec25c0cbed4b060a36713f524"

  depends_on "go" => :build

  def install
    mkdir_p "#{buildpath}/src/github.com/Luzifer/"
    ln_s buildpath, "#{buildpath}/src/github.com/Luzifer/gimme_ec2"

    ENV["GOPATH"] = buildpath

    system "go", "install", "-ldflags", "-X main.version=v#{version}", "github.com/Luzifer/gimme_ec2"
    bin.install "#{buildpath}/bin/gimme_ec2"
  end

  test do
    assert_equal "gimme_ec2 v#{version}", shell_output("#{bin}/gimme_ec2 --version").strip
  end
end
