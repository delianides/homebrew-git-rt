class GitRt < Formula
  desc "A real-time terminal dashboard for git changes"
  homepage "https://github.com/delianides/git-rt"
  version "1.0.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/delianides/git-rt/releases/download/v1.0.3/git-rt-aarch64-apple-darwin.tar.xz"
      sha256 "634dee0b422afa8fae96bed0f9a587dc02bd173b9a349607d318af913e168124"
    end
    if Hardware::CPU.intel?
      url "https://github.com/delianides/git-rt/releases/download/v1.0.3/git-rt-x86_64-apple-darwin.tar.xz"
      sha256 "fb2b2ac9d7f768129f268e530707be4f825ebf62a51fbeca17889d0fdce5f08a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/delianides/git-rt/releases/download/v1.0.3/git-rt-aarch64-unknown-linux-musl.tar.xz"
      sha256 "cbc160aa9d7a0c18ccf54eda2fdd53e1d7a6f74d9efb9fa0c95a84187118278d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/delianides/git-rt/releases/download/v1.0.3/git-rt-x86_64-unknown-linux-musl.tar.xz"
      sha256 "3cb51bc7cbcad306538a46ee58352edf1aac5849ef90c35d002a81d15022ed24"
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
