class License < Formula
  homepage "https://github.com/Luzifer/license"
  desc "license is a small helper to add licenses to your work"
  url "https://github.com/Luzifer/license/archive/v1.2.0.tar.gz"
  head "https://github.com/Luzifer/license.git"
  sha256 "be08b4771ac4fb66f7438f8a472208b5841a3d6d8ae7ee5e71c30e957a7601c2"

  depends_on "go" => :build

  def install
    mkdir_p "#{buildpath}/src/github.com/Luzifer/"
    ln_s buildpath, "#{buildpath}/src/github.com/Luzifer/license"

    ENV["GOPATH"] = buildpath

    system "go", "install", "-ldflags", "-X main.version=#{version}", "github.com/Luzifer/license"
    system "touch", "keep"
    
    prefix.install "keep"
    bin.install "#{buildpath}/bin/license"
  end

  test do
    assert_equal "license version #{version}", shell_output("#{bin}/license version").strip
  end
end
