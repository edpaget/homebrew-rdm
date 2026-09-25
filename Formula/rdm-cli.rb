class RdmCli < Formula
  desc "CLI for managing project roadmaps, phases, and tasks"
  homepage "https://github.com/edpaget/rdm"
  version "0.22.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/edpaget/rdm/releases/download/v0.22.2/rdm-cli-aarch64-apple-darwin.tar.xz"
      sha256 "28070bb77b34e91b61d31b6140d8809105b2254376ceda59d920d067d82df978"
    end
    if Hardware::CPU.intel?
      url "https://github.com/edpaget/rdm/releases/download/v0.22.2/rdm-cli-x86_64-apple-darwin.tar.xz"
      sha256 "53df0110e4b58c618bc2f17b5288827c5580ecf163ebcadbf8b88401736f2b98"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/edpaget/rdm/releases/download/v0.22.2/rdm-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "97cdf30c976ac30c4687c53a7b8d8a49ac4e293112ebe4c3667a9e89624e923f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/edpaget/rdm/releases/download/v0.22.2/rdm-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "188096b5e13f2b2116aafca46a7df8d8f60dd662e90c4b183f288b005c7fc94f"
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
