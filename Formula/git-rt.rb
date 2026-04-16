class GitRt < Formula
  desc "A real-time terminal dashboard for git changes"
  homepage "https://github.com/delianides/git-rt"
  version "1.0.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/delianides/git-rt/releases/download/v1.0.4/git-rt-aarch64-apple-darwin.tar.xz"
      sha256 "3ededfd0b93714d169080eb1ad81dd514929bf398471ebb13615f55dd9d8a8bc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/delianides/git-rt/releases/download/v1.0.4/git-rt-x86_64-apple-darwin.tar.xz"
      sha256 "4b3db200e907e65f386ed017befffc3292b1c7d4227fba3ddf84d78c96e7927d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/delianides/git-rt/releases/download/v1.0.4/git-rt-aarch64-unknown-linux-musl.tar.xz"
      sha256 "1691fd324f95b383750a46817c51b37056c1170cd3293d86fb793c8a16599ef6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/delianides/git-rt/releases/download/v1.0.4/git-rt-x86_64-unknown-linux-musl.tar.xz"
      sha256 "2528a113c77960ac9a12c20a8e88a8fd5324d70550adc94c91a0f55d4d78c819"
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
