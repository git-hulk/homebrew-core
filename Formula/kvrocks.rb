class Kvrocks < Formula
  desc "Key-value NoSQL database based on RocksDB and compatible with Redis protocol"
  homepage "https://github.com/bitleak/kvrocks/"
  url "https://github.com/bitleak/kvrocks.git",
    tag:      "v2.0.1",
    revision: "5f41145adb25a79706a68d233a28a0f633ef255f"
  license "BSD-3-Clause"
  head "https://github.com/bitleak/kvrocks.git", branch: "unstable"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build

  def install
    system "git", "submodule", "init"
    system "git", "submodule", "update"
    mkdir "build" do
      system "cmake", "-DCMAKE_BUILD_TYPE=Release", "..", *std_cmake_args
      system "make", "kvrocks"
      bin.install "kvrocks"
      etc.install "../kvrocks.conf"
    end
  end

  test do
    assert_match "Version: 2.0.1", shell_output("#{bin}/kvrocks -v 2>&1")
    kvrocks = fork do
      exec bin/"kvrocks"
    end
    sleep(1)
    output = shell_output("echo \"ping\\r\\n\"|nc 127.0.0.1 6666")
    assert_match "+PONG", output
    ensure
      Process.kill(15, kvrocks)
      Process.wait kvrocks
  end
end
