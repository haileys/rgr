require "rgr/coloured_reporter"
require "rgr/globber"
require "rgr/plain_reporter"
require "rgr/searcher"

module Rgr
  def self.search(search_term, files)
    searcher = Searcher.new(search_term)

    files.lazy.map { |file|
      [file, searcher.search_file(file)]
    }.select { |file, matches|
      matches.any?
    }
  end

  def self.reporter
    if $stdout.tty?
      ColouredReporter
    else
      PlainReporter
    end
  end
end
