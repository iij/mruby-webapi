# mruby-webapi

"mruby-webapi" is a WebAPI client library.


## API

 - WebAPI.new url, opts={}
   - Make an WebAPI object to be used to call APIs whose base url is `url`
   - Supported keys in `opts`:
     - :accept_encoding => str (mruby-zlib is required)
       - acceptable response encoding
         (supported type: "gzip" or "deflate")
     - :certs => str
       - pathname of the file contains trusted root CA certificate(s)
     - :content_encoding => str (mruby-zlib is required)
       - type of request body encoding
         (supported type: "gzip" or "deflate")
     - :content_type => str
       - "Content-Type" of the request body (if any)
     - :headers => Hash
       - arbitrary header fields.
     - :ignore_certificate_validity => boolean
       - ignore "Not Before" and "Not After" fields of certificates
         (see https://github.com/iij/mruby-tls-openssl)
     - :proxy => str
       - URL of HTTPS proxy
     - :sni => false (default) | true | String
       - use Server Name Indication (SNI)
         (see https://github.com/iij/mruby-tls-openssl)

 - WebAPI#get resource
 - WebAPI#post resource, data
 - WebAPI.urlencode pairs
   - `pairs` can be Hash or Array (like `[[key1, value1], [key2, value2], ...]`)
 - WebAPI.urldecode str


## Example

```Ruby
api = WebAPI.new "https://api.github.com/", {
  :certs => "digicert.crt",
  :content_type => "application/json",
  :headers => {
    "X-AnyHeader" => "Some Text"
  }
}
md = JSON.generate({
  "text" => "Hello world github/linguist#1 **cool**, and #1!",
  "mode" => "gfm",
  "context" => "github/gollum"
})
# or md = '{"text":"Hello world"}'
puts "* Request Message (for debug):"
puts api.post_str "/markdown", md

puts
puts "* API Response Body:"
response = api.post "/markdown", md
html = response.body
puts html
```

```
* Request Message (for debug):
POST /markdown HTTP/1.1
Host: api.github.com:443
Connection: close
User-Agent: mruby-webapi
Content-Type: application/json
Content-Length: 97
X-AnyHeader: Some Text

{"text":"Hello world github/linguist#1 **cool**, and #1!","mode":"gfm","context":"github/gollum"}

* API Response Body:
<p>Hello world github/linguist#1 <strong>cool</strong>, and #1!</p>
```

## License

Copyright (c) 2014 Internet Initiative Japan Inc.

Permission is hereby granted, free of charge, to any person obtaining a 
copy of this software and associated documentation files (the "Software"), 
to deal in the Software without restriction, including without limitation 
the rights to use, copy, modify, merge, publish, distribute, sublicense, 
and/or sell copies of the Software, and to permit persons to whom the 
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in 
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
DEALINGS IN THE SOFTWARE.
