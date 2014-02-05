Gem::Specification.new do |s|
  s.name = "rgr"
  s.version = "0.0.1"

  s.summary = "Ruby Grep"
  s.description = "Grep tool for large Ruby codebases"
  s.author = "Charlie Somerville"
  s.email = "charlie@charliesomerville.com"
  s.license = "MIT"
  s.homepage = "https://github.com/charliesome/rgr"

  s.files = Dir["{bin,lib}/**/*"]
  s.executables = ["rgr"]

  s.add_dependency "parser", "~> 2.1"
  s.add_dependency "coderay", "~> 1.1"
end
