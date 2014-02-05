module Rgr
  class Globber
    def initialize(options={})
      options               = options.dup
      self.paths            = options.delete(:paths)           { [] }
      self.ignored_prefixes = options.delete(:ignore_prefixes) { [] }
      options.any? && raise(ArgumentError, "Unknown keys: #{options.keys.inspect}")
    end

    def each_file
      return enum_for(:each_file) unless block_given?

      unfiltered_files.each do |file|
        next if ignored?(file)
        yield file
      end
    end

    private

    attr_accessor :paths, :ignored_prefixes


    def ignored?(file)
      ignored_prefixes.any? { |prefix|
        file.start_with?(prefix)
      }
    end

    def unfiltered_files
      if paths.empty?
        Dir["**/*.rb"]
      else
        paths.flat_map { |path|
          glob_path(path)
        }
      end
    end

    def glob_path(path)
      if File.file?(path)
        [path]
      else
        Dir["#{path}/**/*.rb"]
      end
    end
  end
end
