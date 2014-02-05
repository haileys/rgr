require "parser"
require "parser/current"

module Rgr
  class Searcher
    attr_reader :search_ast

    def initialize(search)
      @search_ast = parser_class.parse(search)
    end

    def search_file(file)
      if ast = parse_file(file)
        search_node_rec(ast, search_ast)
      else
        []
      end
    end

  private
    def parse_file(file)
      parser.parse(Parser::Source::Buffer.new(file).read)
    rescue => e
      $stderr.puts "Error parsing `#{file}':"
      $stderr.puts e.message
    end

    def parser_class
      Parser::CurrentRuby
    end

    def parser
      @parser ||= parser_class.new
      @parser.reset
      @parser
    end

    def search_node_rec(node, search, results = [])
      node.to_a.grep(Parser::AST::Node).each do |child|
        search_node_rec(child, search, results)
      end

      if match?(node, search)
        results << node.loc
      end

      results
    end

    def match?(node, search)
      return true if wildcard?(search)

      if node.type == search.type
        node.to_a.zip(search.to_a).all? { |n, s|
          if n.is_a?(Parser::AST::Node) && s.is_a?(Parser::AST::Node)
            match?(n, s)
          else
            n == s
          end
        }
      end
    end

    def wildcard?(search_node)
      search_node.type == :send && search_node.to_a == [nil, :_]
    end
  end
end
