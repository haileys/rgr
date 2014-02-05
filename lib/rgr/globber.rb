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

      unfiltered_file_names.each do |file_name|
        next if ignored?(file_name)
        yield file_name
      end
    end

    private

    attr_accessor :paths, :ignored_prefixes

    def ignored?(file_name)
      ignored_prefixes.any? { |prefix| file_name.start_with? prefix }
    end

    def unfiltered_file_names
      if paths.empty?
        # Ideally, this would be passed in
        # but that changes behaviour, b/c what path can you pass in to do this?
        # if passing ".", then all paths are prefixed with "./"
        Dir["**/*.rb"]
      else
        paths.flat_map { |path| glob path }
      end
    end

    def glob(path)
      if File.file?(path)
        [path]
      else
        Dir["#{path}/**/*.rb"]
      end
    end
  end
end
