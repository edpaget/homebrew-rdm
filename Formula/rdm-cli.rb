class RdmCli < Formula
  desc "CLI for managing project roadmaps, phases, and tasks"
  homepage "https://github.com/edpaget/rdm"
  version "0.17.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/edpaget/rdm/releases/download/v0.17.0/rdm-cli-aarch64-apple-darwin.tar.xz"
      sha256 "93b7d490839cc554b6d61e815a88be5b04f5cbaa996f8c1f2e0a56fa64a4665a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/edpaget/rdm/releases/download/v0.17.0/rdm-cli-x86_64-apple-darwin.tar.xz"
      sha256 "e9851154a98b6459bd819bf6135f7e15609e17e51b65ac766fefc0001a7c1fb7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/edpaget/rdm/releases/download/v0.17.0/rdm-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "764ce2def3530dc25237726f4bac20b243e57d51592465f815ec413c28daf281"
    end
    if Hardware::CPU.intel?
      url "https://github.com/edpaget/rdm/releases/download/v0.17.0/rdm-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b6bc2adc50497ce88699b57a189ae638e112d9eda0b8453b66a8b671f9354efb"
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
