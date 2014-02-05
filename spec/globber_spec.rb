require 'rgr/globber'
require 'tmpdir'
require 'fileutils'

describe Rgr::Globber do
  include FileUtils

  around :each do |spec|
    Dir.mktmpdir do |temp_dir|
      Dir.chdir temp_dir, &spec
    end
  end

  def glob(*paths)
    ignore_prefixes = []
    ignore_prefixes = Array(paths.pop.fetch :ignore) if paths.last.kind_of? Hash
    globber         = described_class.new paths: paths, ignore_prefixes: ignore_prefixes
    globber.each_file.to_a
  end

  before do
    # dir structure
    mkdir 'dir1/'
    mkdir 'dir1/subdir1/'
    mkdir 'dir2/'

    # nested files to find
    touch 'current_dir.rb'
    touch 'dir1/ends_in_dot.rb'
    touch 'dir1/subdir1/deep_file.rb'

    # file to not find b/c invalid name
    touch 'dir1/does_not_end_in_dot_rb'

    # files to find or not find depending on ignore
    touch 'dir1/match.rb'
    touch 'dir2/match.rb'
  end

  # untested behaviour: defaults to Dir['**/*.rb']
  # didn't add a test for it b/c I'd rather remove it, just not sure how atm
  # maybe globber should strip leading "./"

  it 'raises an ArgumentError if given an invalid key' do
    described_class.new paths: [], ignore_prefixes: []
    expect { described_class.new abc: [] }.to raise_error ArgumentError, /:abc/
  end

  it 'finds all files that end with .rb recursively within its list of paths' do
    found_files = glob '.'
    expect(found_files).to     include './current_dir.rb'
    expect(found_files).to     include './dir1/ends_in_dot.rb'
    expect(found_files).to     include './dir1/subdir1/deep_file.rb'
    expect(found_files).to_not include './dir1/does_not_end_in_dot_rb'
  end

  it 'can glob a different path than CWD' do
    found_files = glob './dir1'
    expect(found_files).to     include './dir1/ends_in_dot.rb'
    expect(found_files).to_not include './current_dir.rb'
  end

  it 'omits results that start with one of its ignored prefixes' do
    found_files = glob '.'
    expect(found_files).to include './dir1/match.rb'
    expect(found_files).to include './dir2/match.rb'

    found_files = glob '.', ignore: './dir2'
    expect(found_files).to     include './dir1/match.rb'
    expect(found_files).to_not include './dir2/match.rb'
  end
end
