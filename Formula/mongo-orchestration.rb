class MongoOrchestration < Formula
  include Language::Python::Virtualenv

  desc "REST API to manage MongoDB configurations on a single host"
  homepage "https://github.com/10gen/mongo-orchestration"
  url "https://files.pythonhosted.org/packages/6d/b5/624a02d5f6cbfa8eb3c6554f5387c4739ad283bac7efb27ee99434a4d314/mongo-orchestration-0.6.11.tar.gz"
  sha256 "7a09706d36e94ae767e90646fed98a52b426a4d14b0f4f724b185e292ac8f425"
  revision OS.mac? ? 3 : 4
  head "https://github.com/10gen/mongo-orchestration.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ca2f1aa5e42d7034892714d40e880b55c2c600c41340469a0c7920f5745ee318" => :catalina
    sha256 "74f0f48ec48f2e52b4ce7787ba03b4dd67673bc434f90ab0f209eea1cae05a57" => :mojave
    sha256 "fbb1f7ae46b230e912072383e54150c2a48ded086fa25f3f5a4c030dd92458d4" => :high_sierra
    sha256 "5eec292d866859478452bced19fae1b21c1a1ddf1fcad59b653a8bd83999ed6f" => :x86_64_linux
  end

  depends_on "python@3.8"

  resource "bottle" do
    url "https://files.pythonhosted.org/packages/bd/99/04dc59ced52a8261ee0f965a8968717a255ea84a36013e527944dbf3468c/bottle-0.12.13.tar.gz"
    sha256 "39b751aee0b167be8dffb63ca81b735bbf1dd0905b3bc42761efedee8f123355"
  end

  resource "CherryPy" do
    url "https://files.pythonhosted.org/packages/50/c6/6c3d7a3221b0f098f8684037736e5604ea1586a3ba450c4a52b48f5fc2b4/CherryPy-7.0.0.tar.gz"
    sha256 "faead7c5c7ca2526aff8f179a24d699127ed307c3393eeef9610a33b93650bef"
  end

  resource "pymongo" do
    url "https://files.pythonhosted.org/packages/a8/f6/f324f5c669478644ac64594b9d746a34e185d9c34d3f05a4a6a6dab5467b/pymongo-3.5.1.tar.gz"
    sha256 "e820d93414f3bec1fa456c84afbd4af1b43ff41366321619db74e6bc065d6924"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  def install
    virtualenv_install_with_resources
  end

  plist_options :startup => true, :manual => "#{HOMEBREW_PREFIX}/opt/mongo-orchestration/bin/mongo-orchestration -b 127.0.0.1 -p 8889 --no-fork start"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>mongo-orchestration</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/mongo-orchestration</string>
            <string>-b</string>
            <string>127.0.0.1</string>
            <string>-p</string>
            <string>8889</string>
            <string>--no-fork</string>
            <string>start</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
        </dict>
      </plist>
    EOS
  end

  test do
    system "#{bin}/mongo-orchestration", "-h"
  end
end
