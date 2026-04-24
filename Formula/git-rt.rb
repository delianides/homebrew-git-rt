class GitRt < Formula
  desc "A real-time terminal dashboard for git changes"
  homepage "https://github.com/delianides/git-rt"
  version "1.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/delianides/git-rt/releases/download/v1.2.0/git-rt-aarch64-apple-darwin.tar.xz"
      sha256 "15a2815f49195e7a11cb8c39d3f836a2b5bc33031807fed234874cc838cf3f6d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/delianides/git-rt/releases/download/v1.2.0/git-rt-x86_64-apple-darwin.tar.xz"
      sha256 "d061865dc50668e6c086806c5df6b014e979ec593db2438830fed832f7ec3e27"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/delianides/git-rt/releases/download/v1.2.0/git-rt-aarch64-unknown-linux-musl.tar.xz"
      sha256 "153df0e105d4064e853ba0d617770620b9280e4df1ce8b97dbf0266f58b29078"
    end
    if Hardware::CPU.intel?
      url "https://github.com/delianides/git-rt/releases/download/v1.2.0/git-rt-x86_64-unknown-linux-musl.tar.xz"
      sha256 "a5855ffd276df364be735e9b50c936c460addd82b51cb6982a2452b6d8bbe2ad"
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
