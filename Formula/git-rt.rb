class GitRt < Formula
  desc "A real-time terminal dashboard for git changes"
  homepage "https://github.com/delianides/git-rt"
  version "1.0.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/delianides/git-rt/releases/download/v1.0.2/git-rt-aarch64-apple-darwin.tar.xz"
      sha256 "4e29c54a6323699c67aa20dc393ca641befaf6b4bb984822931766eaad1e126a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/delianides/git-rt/releases/download/v1.0.2/git-rt-x86_64-apple-darwin.tar.xz"
      sha256 "54186fbb8b5986d2a8e0363e408ab9f4c3c94dd8d3424229b0d46f2ac27eb84a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/delianides/git-rt/releases/download/v1.0.2/git-rt-aarch64-unknown-linux-musl.tar.xz"
      sha256 "7fa8d11ea02fcc04e585ef7eae42d046f55232bfa955f427870f8a5473e939e9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/delianides/git-rt/releases/download/v1.0.2/git-rt-x86_64-unknown-linux-musl.tar.xz"
      sha256 "bf4da3c282fb0d0b0cd654decbb15dc42a24ecbac3f653d2013eac339c71aee5"
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
