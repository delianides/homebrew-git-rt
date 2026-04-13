class GitRt < Formula
  desc "A real-time terminal dashboard for git changes with configurable actions"
  homepage "https://github.com/delianides/git-rt"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/delianides/git-rt/releases/download/v0.7.0/git-rt-aarch64-apple-darwin.tar.xz"
      sha256 "8e15e6a26d9d5631476079437c736446ebf8c4870f5ff36685f9b40535311d47"
    end
    if Hardware::CPU.intel?
      url "https://github.com/delianides/git-rt/releases/download/v0.7.0/git-rt-x86_64-apple-darwin.tar.xz"
      sha256 "da9562f34f5e38650457032c5989287a19b31d0812aeea53eba86927d9d1f72d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/delianides/git-rt/releases/download/v0.7.0/git-rt-aarch64-unknown-linux-musl.tar.xz"
      sha256 "48c7c83770a484e62e086d68a9592bb39942a1d45dac775993daa2382288d981"
    end
    if Hardware::CPU.intel?
      url "https://github.com/delianides/git-rt/releases/download/v0.7.0/git-rt-x86_64-unknown-linux-musl.tar.xz"
      sha256 "e64f6310c432f4ded973d2f324bf946cae2484fa3a66ffa781003aa1ce403cd3"
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
