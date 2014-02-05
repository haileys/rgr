## rgr

rgr is a Ruby-aware search tool designed to make exploring large codebases easier.

```
λ rgr ' _ + _ '
lib/better_errors/code_formatter.rb
59:       max = [line + context, source_lines.count].min
lib/better_errors/error_page.rb
110:       str + "\n" + char*str.size
110:       str + "\n" + char*str.size
lib/better_errors/middleware.rb
137:       "<h1>No errors</h1><p>No errors have been recorded yet.</p><hr>" +
lib/better_errors/stack_frame.rb
70:       filename[(BetterErrors.application_root.length+1)..-1]
λ rgr '_.to_s'
lib/better_errors/middleware.rb
112:       !env["HTTP_ACCEPT"].to_s.include?('html')
lib/better_errors/rails.rb
8:         BetterErrors.application_root = Rails.root.to_s
lib/better_errors/rails2.rb
9:   BetterErrors.application_root = Rails.root.to_s
lib/better_errors/repl/basic.rb
16:         "!! #{e.inspect rescue e.class.to_s rescue "Exception"}\n"
lib/better_errors/stack_frame.rb
118:             hash[name] = frame_binding.eval(name.to_s)
130:         [x, frame_binding.eval(x.to_s)]
```
