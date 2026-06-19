class RdmCli < Formula
  desc "CLI for managing project roadmaps, phases, and tasks"
  homepage "https://github.com/edpaget/rdm"
  version "0.13.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/edpaget/rdm/releases/download/v0.13.0/rdm-cli-aarch64-apple-darwin.tar.xz"
      sha256 "08bbfe59a4a1aca6ea734eebaa67f4ca7cd4bab4791ebf9c1c84b060dbba6ec8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/edpaget/rdm/releases/download/v0.13.0/rdm-cli-x86_64-apple-darwin.tar.xz"
      sha256 "d2b82d0ba38c7c25f9c735f35bd43a153ad2b8d2c2e0a73e3e5ab4b1977c7b48"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/edpaget/rdm/releases/download/v0.13.0/rdm-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "564d95cc9cb40bbdbf366b43856d85b5d852963f531a5f85137dd876babbb1f2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/edpaget/rdm/releases/download/v0.13.0/rdm-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "89b9f04bb0115f43eec1aead8fb43beb92ae3297502301ce65c7ad065fa55897"
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
