# ss is subsite search

require('open-uri')

url = URI.parse($stdin.gets).normalize

unless url.absolute?() then raise "url is not absolute" end 

read_page = ->(url) do
  url.read
end

parse_all_links = ->(url) do
  read_page.call(url).scan(/<a[^>]+href="([^?\#"]+)"/).uniq
end

p parse_all_links.call(url)

gen_parse_links = ->(url) do 
  ->(smth) do
    smth.to_s.gsub(/"(?:(?<path>\/[\.\w\d-]+)+)/, "#{url.scheme}://#{url.host}#{url.path}" << '\k<path>').
      gsub(/"(\/\/)/, "http://").
      scan(/#{url.scheme}:\/\/#{url.host}[\w\d\/-]+/)
  end  
end

p gen_parse_links.call(url).call(parse_all_links.call(url))
