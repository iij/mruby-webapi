MRuby::Gem::Specification.new('mruby-webapi') do |spec|
  spec.license = 'MIT'
  spec.author  = 'Internet Initiative Japan'

  spec.add_dependency 'mruby-io'
  spec.add_dependency 'mruby-socket'
  spec.add_dependency 'mruby-sprintf'
  spec.add_dependency 'mruby-string-ext'
  spec.add_dependency 'mruby-tls-openssl'
  #spec.add_dependency 'mruby-zlib' # Optional
end
