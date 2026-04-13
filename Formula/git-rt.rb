class GitRt < Formula
  desc "A real-time terminal dashboard for git changes"
  homepage "https://github.com/delianides/git-rt"
  version "0.8.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/delianides/git-rt/releases/download/v0.8.0/git-rt-aarch64-apple-darwin.tar.xz"
      sha256 "6fcf96365e90d3321100202ef7a4123cf35c7bf51f0b076bcc83084c2c897fd9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/delianides/git-rt/releases/download/v0.8.0/git-rt-x86_64-apple-darwin.tar.xz"
      sha256 "be21241f23ef52feac4a94d79a0da6e029b86cbb2e6f674c137447eb7e84f76a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/delianides/git-rt/releases/download/v0.8.0/git-rt-aarch64-unknown-linux-musl.tar.xz"
      sha256 "ff7bdf4f7e752135354befd28222530f2b66e1afea4cffabcf388afb382ff418"
    end
    if Hardware::CPU.intel?
      url "https://github.com/delianides/git-rt/releases/download/v0.8.0/git-rt-x86_64-unknown-linux-musl.tar.xz"
      sha256 "b06d410d14e637b633408ae2795a75f28cfff45efee682f069b6b61504adc6b7"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "git-rt" if OS.mac? && Hardware::CPU.arm?
    bin.install "git-rt" if OS.mac? && Hardware::CPU.intel?
    bin.install "git-rt" if OS.linux? && Hardware::CPU.arm?
    bin.install "git-rt" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
