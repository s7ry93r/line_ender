Gem::Specification.new do |s|
  s.name = "line_ender"
  s.version = "0.0.3"
  s.summary = "Mixin to fix line endings of files"
  s.date = "2014-06-28"
  s.description = "A little mixin to change the line endings of files. Supports Mac, Unix, and Windows line ending conversions."
  s.author = "Rich Krueger"
  s.email = ["rkrueger@gmail.com"]
  s.homepage = "http://www.hqual.net"
  s.files = ["lib/line_ender.rb", "lib/test_line_ender.rb", "lib/le"]
  s.requirements << 'trollop, v2.0'
end