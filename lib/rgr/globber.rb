module Rgr
  class Globber
    attr_reader :paths, :ignored_prefixes

    def initialize(options={})
      options = options.dup
      @paths            = options.delete(:paths)           { [] }
      @ignored_prefixes = options.delete(:ignore_prefixes) { [] }
      options.any? && raise(ArgumentError, "Unknown keys: #{options.keys.inspect}")
    end

    def add_path(path)
      paths << path
    end

    def ignore_prefix(prefix)
      ignored_prefixes << prefix
    end

    def each_file
      return enum_for(:each_file) unless block_given?

      unfiltered_files.each do |file|
        next if ignored?(file)
        yield file
      end
    end

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
