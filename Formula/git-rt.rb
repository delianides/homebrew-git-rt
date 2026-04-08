class GitRt < Formula
  desc "A real-time terminal dashboard for git changes with configurable actions"
  homepage "https://github.com/delianides/git-rt"
  version "0.2.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/delianides/git-rt/releases/download/v0.2.3/git-rt-aarch64-apple-darwin.tar.xz"
      sha256 "f262ed8c8fb541504b43b393baa3143ea812f17f86d580f93709449e2d5d6258"
    end
    if Hardware::CPU.intel?
      url "https://github.com/delianides/git-rt/releases/download/v0.2.3/git-rt-x86_64-apple-darwin.tar.xz"
      sha256 "f2b975065910e8266f1127bb1c6c0fe21b7d7b65d5a6bfc9ecb1b46dec178efe"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/delianides/git-rt/releases/download/v0.2.3/git-rt-aarch64-unknown-linux-musl.tar.xz"
      sha256 "7ef23730df5cf73049c62fc859f65723411abe62c02dc54a8ad13975a021d4e1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/delianides/git-rt/releases/download/v0.2.3/git-rt-x86_64-unknown-linux-musl.tar.xz"
      sha256 "8f8bb5654fd504cf623b5a51f55a6621631fbdd9238eb5612222a44d222676be"
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
