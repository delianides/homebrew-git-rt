class GitRt < Formula
  desc "A real-time terminal dashboard for git changes with configurable actions"
  homepage "https://github.com/delianides/git-rt"
  version "0.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/delianides/git-rt/releases/download/v0.2.2/git-rt-aarch64-apple-darwin.tar.xz",
      headers: ["Authorization: token #{ENV.fetch(\"HOMEBREW_GITHUB_API_TOKEN\")}"]
      sha256 "6733f13532f2128e8724a1971b51e10d07dd2d7919b9ad76dd6a801445ad2fe1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/delianides/git-rt/releases/download/v0.2.2/git-rt-x86_64-apple-darwin.tar.xz",
      headers: ["Authorization: token #{ENV.fetch(\"HOMEBREW_GITHUB_API_TOKEN\")}"]
      sha256 "89374888cff035fa4bd73962931d37a19a1f7b6e40495848a3cf7fa313c61733"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/delianides/git-rt/releases/download/v0.2.2/git-rt-aarch64-unknown-linux-musl.tar.xz",
      headers: ["Authorization: token #{ENV.fetch(\"HOMEBREW_GITHUB_API_TOKEN\")}"]
      sha256 "887a5e01c39ce6602f8da90274bc08301af7f11ac59d0a5e677964c6a6e05c24"
    end
    if Hardware::CPU.intel?
      url "https://github.com/delianides/git-rt/releases/download/v0.2.2/git-rt-x86_64-unknown-linux-musl.tar.xz",
      headers: ["Authorization: token #{ENV.fetch(\"HOMEBREW_GITHUB_API_TOKEN\")}"]
      sha256 "162b60be90d8074701adb0ffd4e2542e9330d19548569b1182a83b5461edd1a2"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static": {},
    "x86_64-apple-darwin": {},
    "x86_64-unknown-linux-gnu": {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static": {}
  }

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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "git-rt"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "git-rt"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "git-rt"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "git-rt"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
