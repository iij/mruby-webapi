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

if Object.const_defined? :Zlib
  assert('WebAPI::Response response with Content-Encoding') do
    text =  "HTTP/1.1 200 OK\r\n"
    text += "Content-Encoding: gzip\r\n"
    text += "\r\n"
    text += "#{Zlib.gzip("mruby-webapi")}"
    r = WebAPI::Response.new text
    assert_equal "mruby-webapi", r.body
  end

  assert('WebAPI::Response broken response with Content-Encoding') do
    text =  "HTTP/1.1 200 OK\r\n"
    text += "Content-Encoding: gzip\r\n"
    text += "\r\n"
    text += "It is not a gzip"
    assert_raise(WebAPI::ResponseError) do
      WebAPI::Response.new text
    end
  end
else
  assert('WebAPI.new without mruby-zlib') do
    assert_raise(WebAPI::UnSupportedOptionError) do
      WebAPI.new("http://expample.com", {:content_encoding => "gzip"})
    end
    assert_raise(WebAPI::UnSupportedOptionError) do
      WebAPI.new("http://expample.com", {:accept_encoding => "gzip"})
    end
  end

  assert('WebAPI::Response with Content-Encoding but no mruby-zlib') do
    text =  "HTTP/1.1 200 OK\r\n"
    text += "Content-Encoding: gzip\r\n"
    text += "\r\n"
    # Zlib.gzip("mruby-webapi")
    text += "\037\213\b\000\000\000\000\000\000\003\313-*M\252\324-OMJ,\310\004\000s\216x\220\f\000\000\000"
    r = WebAPI::Response.new text
    assert_equal("\037\213\b\000\000\000\000\000\000\003\313-*M\252\324-OMJ,\310\004\000s\216x\220\f\000\000\000",
                 r.body) #passthrough
    assert_equal r.headers["content-encoding"], "gzip"
  end
end
