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
  depends_on "gcc" => :build
  depends_on "libtool" => :build

  def install
    mkdir_p "_build"
    system "sh", "build.sh", "_build"
    bin.install "_build/kvrocks"
    etc.install "kvrocks.conf"
  end

  test do
    assert_match "/Version: 999\.999\.999.*/", shell_output("#{bin}/kvrocks -v 2>&1")
  end
end
