class Vault2env < Formula
  desc "is a utility to put variables from vault to the ENV"
  homepage "https://github.com/Luzifer/vault2env"
  url "https://github.com/Luzifer/vault2env/archive/v0.4.2.tar.gz"
  sha256 "fc15dacaa913f1d31ce50a4215fc15c12ba4cbcccca5aa0aa7355d763e9bdd7d"

  depends_on "go" => :build

  def install
    mkdir_p "#{buildpath}/src/github.com/Luzifer/"
    ln_s buildpath, "#{buildpath}/src/github.com/Luzifer/vault2env"

    ENV["GOPATH"] = buildpath

    system "go", "install", "-ldflags", "-X main.version=v#{version}", "github.com/Luzifer/vault2env"
    bin.install "#{buildpath}/bin/vault2env"
  end

  test do
    assert_equal "vault2env v#{version}", shell_output("#{bin}/vault2env --version").strip
  end
end
