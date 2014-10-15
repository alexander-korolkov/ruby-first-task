# ss is subsite search

require('open-uri')

url = URI.parse($stdin.gets).normalize

unless url.absolute?() then raise "url is not absolute" end 

gen_parse_links = ->(url) do
  ->(text) do
    text.scan(Regexp.new(/<a[^>]+href="(?:#{url.scheme}:)?(?:\/\/#{url.host})?([^?"]+)/))
  end
end

text = "<a http://"

gen_parse_link.call(url).call(text)
