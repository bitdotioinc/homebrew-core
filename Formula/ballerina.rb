class Ballerina < Formula
  desc "Programming Language for Network Distributed Applications"
  homepage "https://ballerina.io"
  url "https://dist.ballerina.io/downloads/1.2.11/ballerina-1.2.11.zip"
  sha256 "c7b62a5a52fa9dde5180ee108cc5931a18d505abfceeec28554bda77f8d72b4c"
  license "Apache-2.0"

  livecheck do
    url "https://ballerina.io/learn/installing-ballerina/"
    regex(/href=.*?ballerina[._-]v?(\d+(?:\.\d+)+)/i)
  end

  bottle :unneeded

  depends_on "openjdk@8"

  def install
    # Remove Windows files
    rm Dir["bin/*.bat"]

    chmod 0755, "bin/ballerina"

    bin.install "bin/ballerina"
    libexec.install Dir["*"]
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("1.8"))
  end

  test do
    (testpath/"helloWorld.bal").write <<~EOS
      import ballerina/io;
      public function main() {
        io:println("Hello, World!");
      }
    EOS
    output = shell_output("#{bin}/ballerina run helloWorld.bal")
    assert_equal "Hello, World!", output.chomp
  end
end
