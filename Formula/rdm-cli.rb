class RdmCli < Formula
  desc "CLI for managing project roadmaps, phases, and tasks"
  homepage "https://github.com/edpaget/rdm"
  version "0.10.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/edpaget/rdm/releases/download/v0.10.3/rdm-cli-aarch64-apple-darwin.tar.xz"
      sha256 "5f6451b42d2a4a8cbafaf8f42dda86636723483f3a97a5c145f14e1ef2f4c3fb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/edpaget/rdm/releases/download/v0.10.3/rdm-cli-x86_64-apple-darwin.tar.xz"
      sha256 "af11284be69f62facc7633c5259b016cebb0ba6458ef81f7a26df1a1763c974f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/edpaget/rdm/releases/download/v0.10.3/rdm-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ba09c744979cf61113bd75a42e8667b1cbd8b17071d10e73063b0e6ac11f4bdf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/edpaget/rdm/releases/download/v0.10.3/rdm-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0c7f8228fbc127d9fdfa81ec7603dc2ac48b9d952f8b86a7d0d8d7246db914b5"
    end
  end
  license "GPL-3.0-or-later"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "rdm" if OS.mac? && Hardware::CPU.arm?
    bin.install "rdm" if OS.mac? && Hardware::CPU.intel?
    bin.install "rdm" if OS.linux? && Hardware::CPU.arm?
    bin.install "rdm" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
