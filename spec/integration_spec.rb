require 'open3'

describe 'Integration tests' do
  Invocation = Struct.new :stdout, :stderr, :status

  def something_to_match_against
    abc.zomg
  end

  it 'Smoke test: executes the binary and returns some expected result' do
    # if https://github.com/charliesome/rgr/pull/1 gets merged then simplify this
    root_path  = File.expand_path '../..', __FILE__
    invocation = Invocation.new *Open3.capture3("ruby",
                                                "-I", "#{root_path}/lib",
                                                "-S", "#{root_path}/bin/rgr",
                                                "_.zomg")
    # no errors
    expect(invocation.stderr).to eq ""

    # lists the path
    expect(invocation.stdout).to include "spec/integration_spec.rb"

    # lists the line
    expect(invocation.stdout).to include "abc.zomg"

    # no errors
    expect(invocation.status).to eq 0
  end
end
