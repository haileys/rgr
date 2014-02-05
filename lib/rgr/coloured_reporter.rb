require "coderay"

module Rgr
  class ColouredReporter
    attr_reader :output

    def initialize(output = $stdout)
      @output = output
    end

    def report_file_matches(file, matches)
      output.puts "\e[32;1m#{file}\e[0m"

      line_number_places = line_number_places(matches)

      matches.each do |match|
        expr = match.expression
        highlighted_source = highlight_source(expr.source)
        output.printf "\e[33;1m%#{line_number_places}d\e[0m: %s\n", expr.line, highlighted_source
      end
    end

    def line_number_places(matches)
      highest_line_number = matches.map { |match| match.expression.line }.max
      highest_line_number.to_s.length
    end

    def highlight_source(source)
      CodeRay.scan(source, :ruby).terminal
    end
  end
end
