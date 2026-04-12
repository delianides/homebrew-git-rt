class GitRt < Formula
  desc "A real-time terminal dashboard for git changes with configurable actions"
  homepage "https://github.com/delianides/git-rt"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/delianides/git-rt/releases/download/v0.6.0/git-rt-aarch64-apple-darwin.tar.xz"
      sha256 "ef3d26434161c80c9253c680168b1e257fe049089ad9dd3f23daa503f9438108"
    end
    if Hardware::CPU.intel?
      url "https://github.com/delianides/git-rt/releases/download/v0.6.0/git-rt-x86_64-apple-darwin.tar.xz"
      sha256 "83f3b15a7bf506eeb75456e70f14fe79639842bb0040a82a0a172fd82b321693"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/delianides/git-rt/releases/download/v0.6.0/git-rt-aarch64-unknown-linux-musl.tar.xz"
      sha256 "40197e86c9f08eeacd3d587ada9629d799f37207304e2c38350168c694235e5f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/delianides/git-rt/releases/download/v0.6.0/git-rt-x86_64-unknown-linux-musl.tar.xz"
      sha256 "0eb136f56cb362e66bb6895650143e3d09de141b704808f97c24bbe9e4a66f9a"
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
