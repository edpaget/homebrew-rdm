class RdmCli < Formula
  desc "CLI for managing project roadmaps, phases, and tasks"
  homepage "https://github.com/edpaget/rdm"
  version "0.20.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/edpaget/rdm/releases/download/v0.20.0/rdm-cli-aarch64-apple-darwin.tar.xz"
      sha256 "3a2c9b6e005a2c227b81dd370baa439331b1c64f5b4994240dcdc43282cc0a68"
    end
    if Hardware::CPU.intel?
      url "https://github.com/edpaget/rdm/releases/download/v0.20.0/rdm-cli-x86_64-apple-darwin.tar.xz"
      sha256 "3600b920babcedb646b5738d251cc02b003c51000eeeac43da9c0ae7470425b4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/edpaget/rdm/releases/download/v0.20.0/rdm-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3bb42e1c97194a40b81283fe045c6b481b68690c036cf60bab88c3fc6675bd67"
    end
    if Hardware::CPU.intel?
      url "https://github.com/edpaget/rdm/releases/download/v0.20.0/rdm-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "785e4dfe7b229c2952370ace1e4bb601d9f10511aecdb0b37eb5d8230f657cad"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "rdm"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "rdm"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "rdm"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "rdm"
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
