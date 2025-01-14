class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/tfsec/tfsec/archive/v0.41.0.tar.gz"
  sha256 "e6d578264d6e316ee9136535d76d0f46292bc5a31df0831b9a9299276b456e93"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8e2b3203b2a7134413e97cd3a48b74cbbb22385fcef19681eb731f9e8d8ce0ab"
    sha256 cellar: :any_skip_relocation, big_sur:       "c19832206c1ecc0e3e88c8ac01938871dc3d312b22869949d4f0379ab7196c67"
    sha256 cellar: :any_skip_relocation, catalina:      "fe7f64a025acc839114057ac9dca0441c2c93ab191154339fcee4372436800fa"
    sha256 cellar: :any_skip_relocation, mojave:        "014811b8e6d6a6aa11e84a41302d24ac8e66f7099460e62064d888c41aabe528"
  end

  depends_on "go" => :build

  def install
    system "scripts/install.sh", "v#{version}"
    bin.install "tfsec"
  end

  test do
    (testpath/"good/brew-validate.tf").write <<~EOS
      resource "aws_alb_listener" "my-alb-listener" {
        port     = "443"
        protocol = "HTTPS"
      }
    EOS
    (testpath/"bad/brew-validate.tf").write <<~EOS
      resource "aws_security_group_rule" "world" {
        description = "A security group triggering tfsec AWS006."
        type        = "ingress"
        cidr_blocks = ["0.0.0.0/0"]
      }
    EOS

    good_output = shell_output("#{bin}/tfsec #{testpath}/good")
    assert_match "No problems detected!", good_output
    bad_output = shell_output("#{bin}/tfsec #{testpath}/bad 2>&1", 1)
    assert_match "WARNING", bad_output
  end
end
