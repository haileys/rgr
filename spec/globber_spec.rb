require 'rgr/globber'
require 'tmpdir'
require 'fileutils'

describe Rgr::Globber do
  include FileUtils

  around :each do |spec|
    Dir.mktmpdir do |temp_dir|
      Dir.chdir temp_dir do
        spec.call
      end
    end
  end

  def glob(*paths)
    globber = described_class.new
    paths.each &globber.method(:add_path)
    globber.each_file.to_a
  end

  it 'finds all files that end with .rb recursively within its list of paths' do
    touch 'current_dir.rb'
    mkdir 'dir1/'
    touch 'dir1/does_not_end_in_dot_rb'
    touch 'dir1/ends_in_dot.rb'
    mkdir 'dir1/subdir1/'
    touch 'dir1/subdir1/deep_file.rb'

    found_files = glob '.'

    expect(found_files.size).to eq 3
    expect(found_files).to include './current_dir.rb'
    expect(found_files).to include './dir1/ends_in_dot.rb'
    expect(found_files).to include './dir1/subdir1/deep_file.rb'

    # kinda redundant, given we checked the size, but nice to be explicit
    expect(found_files).to_not include 'dir1/does_not_end_in_dot_rb'
  end

  it 'omits results that start with one of its ignored prefixes'
end
