class RdmCli < Formula
  desc "CLI for managing project roadmaps, phases, and tasks"
  homepage "https://github.com/edpaget/rdm"
  version "0.10.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/edpaget/rdm/releases/download/v0.10.2/rdm-cli-aarch64-apple-darwin.tar.xz"
      sha256 "2225473056bb6dfe1fb0e17f04d9350debfbf33d6965740feda5faac09ab110e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/edpaget/rdm/releases/download/v0.10.2/rdm-cli-x86_64-apple-darwin.tar.xz"
      sha256 "efff40c5dd1f7c6d56475c5d0f7431fb6ef7d2671b54f66178835088030581fc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/edpaget/rdm/releases/download/v0.10.2/rdm-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c1b5bc29a371ad572afb8422b6db3c9112f4c87225d77b9a95ccc012c6c6ac1a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/edpaget/rdm/releases/download/v0.10.2/rdm-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5395620f59be5f7d945b7ca7424b01d01523a8aaef5025835474da6c944722e4"
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
