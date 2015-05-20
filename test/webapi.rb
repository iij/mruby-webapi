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

assert('WebAPI::Response#_join_chunks') do
  text =  "HTTP/1.1 200 OK\r\n"
  text += "Transfer-Encoding: chunked\r\n"
  text += "\r\n"
  text += "5\r\n"
  text += "mruby\r\n"
  text += "1\r\n"
  text += "-\r\n"
  text += "6; ext\r\n"
  text += "webapi\r\n"
  text += "0\r\n"
  text += "\r\n"
  r = WebAPI::Response.new text
  assert_equal "mruby-webapi", r.body
end

assert('WebAPI::Response response with Content-Encoding') do
  text =  "HTTP/1.1 200 OK\r\n"
  text += "Content-Encoding: gzip\r\n"
  text += "\r\n"
  text += "#{Zlib.gzip("mruby-webapi")}\r\n"
  text += "\r\n"
  r = WebAPI::Response.new text
  assert_equal "mruby-webapi", r.body
end

assert('WebAPI::Response broken response with Content-Encoding') do
  text =  "HTTP/1.1 200 OK\r\n"
  text += "Content-Encoding: gzip\r\n"
  text += "\r\n"
  text += "It is not a gzip\r\n"
  text += "\r\n"
  assert_raise(WebAPI::ResponseError) do
    WebAPI::Response.new text
  end
end
