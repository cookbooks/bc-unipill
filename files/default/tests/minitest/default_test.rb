require File.expand_path('../support/helpers', __FILE__)

describe 'ruby_from_source::default' do

  include Helpers::Betterplace

  it "should install the unicorn configuration in the shared folder" do
    file('/var/apps/unipill/shared').must_exist
  end

  it "should create the bluepill directory" do
    file('/opt/local/bluepill/Gemfile').must_exist
  end

  it "should install the pills" do
    file('/opt/local/bluepill/pills/unicorn.pill').must_exist
  end

  it "should install the bpill executable" do
    file('/opt/local/bin/bpill').must_exist
  end

  it "should be possible to run bluepill" do
    assert `/opt/local/bin/bpill --help` =~ /Usage: bluepill/
  end

  it "should install the process kill script" do
    file('/opt/local/bin/process_killer').must_exist
  end

end