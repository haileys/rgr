module Rgr
  class PlainReporter
    attr_reader :output

    def initialize(output = $stdout)
      @output = output
    end

    def report_file_matches(file, matches)
      matches.each do |match|
        output.puts "#{match.expression}: #{match.expression.source}"
      end
    end
  end
end
