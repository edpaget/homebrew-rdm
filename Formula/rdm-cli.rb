class RdmCli < Formula
  desc "CLI for managing project roadmaps, phases, and tasks"
  homepage "https://github.com/edpaget/rdm"
  version "0.11.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/edpaget/rdm/releases/download/v0.11.0/rdm-cli-aarch64-apple-darwin.tar.xz"
      sha256 "2b87c2c169b1450720adb618d9773ceaaaa4718edc724f6382b9560e9c970477"
    end
    if Hardware::CPU.intel?
      url "https://github.com/edpaget/rdm/releases/download/v0.11.0/rdm-cli-x86_64-apple-darwin.tar.xz"
      sha256 "6a0d183cce126a29425e8a52dc454a983b3a9c66dc75cc59c048c8d30cfbee06"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/edpaget/rdm/releases/download/v0.11.0/rdm-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8faa5c4f654ba3d5f9cf6fafa5e099eec6b4668edd59969cde27b8bd19cc375a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/edpaget/rdm/releases/download/v0.11.0/rdm-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f1b531a4598bd030e5dd14142d93f929dfd2e3701c8aefb264bd96df9ccf186f"
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
