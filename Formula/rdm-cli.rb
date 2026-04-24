class RdmCli < Formula
  desc "CLI for managing project roadmaps, phases, and tasks"
  homepage "https://github.com/edpaget/rdm"
  version "0.7.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/edpaget/rdm/releases/download/v0.7.1/rdm-cli-aarch64-apple-darwin.tar.xz"
    sha256 "a3b08a6a9ae7eb8337bfabef09d4120b2d5286d136cdb76baf786df0259eaf44"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/edpaget/rdm/releases/download/v0.7.1/rdm-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "9209976d1e4bce73a5c4d5d1dbadc033213cba314f381462895f0eaafb18ce8b"
  end
  license "GPL-3.0-or-later"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-unknown-linux-gnu": {},
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
