class GitRt < Formula
  desc "A real-time terminal dashboard for git changes"
  homepage "https://github.com/delianides/git-rt"
  version "1.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/delianides/git-rt/releases/download/v1.1.0/git-rt-aarch64-apple-darwin.tar.xz"
      sha256 "b88f23db535471b676692ea891cb9b5d63c9f73e21a9756a738a2a7c05dc6bfd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/delianides/git-rt/releases/download/v1.1.0/git-rt-x86_64-apple-darwin.tar.xz"
      sha256 "373df43d716d41b2b54c9f22e9f64ff16b7f7177354e10411f18f82ab70a516c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/delianides/git-rt/releases/download/v1.1.0/git-rt-aarch64-unknown-linux-musl.tar.xz"
      sha256 "864b03a5834b85f1973415dbaf699ae286b08b6c6d6e11010e94b758772cd1b3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/delianides/git-rt/releases/download/v1.1.0/git-rt-x86_64-unknown-linux-musl.tar.xz"
      sha256 "51b715478e45b62cf7b90d009a8cb04b326298b4c29f3956793839e06abcdb3b"
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
