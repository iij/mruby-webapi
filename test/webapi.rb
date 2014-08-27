assert('WebAPI.urlencode') do
  # Note: mruby's Hash is not ordered.
  h = { :abc => 123, :space => "s p a c e" }
  str = WebAPI.urlencode(h)
  assert_include ['abc=123&space=s+p+a+c+e', 'space=s+p+a+c+e&abc=123'], str
end

assert('WebAPI.urldecode') do
  # Note: mruby's Hash is not ordered.
  str = 'abc=123&space=s+p+a+c+e'
  a = WebAPI.urldecode(str)
  assert_equal [ ["abc", "123"], ["space", "s p a c e"] ], a
end
