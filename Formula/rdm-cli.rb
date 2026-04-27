class RdmCli < Formula
  desc "CLI for managing project roadmaps, phases, and tasks"
  homepage "https://github.com/edpaget/rdm"
  version "0.8.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/edpaget/rdm/releases/download/v0.8.0/rdm-cli-aarch64-apple-darwin.tar.xz"
    sha256 "15b52242b2e790f5442346ecbc6ed800e734d2f66d586309e8802427e160cccc"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/edpaget/rdm/releases/download/v0.8.0/rdm-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "4475cd88f1e8d22e04ae049b8b5e444ff88443104ad68b1dbca0cdf4a26a9f58"
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
