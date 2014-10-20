# ss - subsitesearch

require 'open-uri'

url = URI.parse($stdin.gets).normalize
unless url.absolute?()
  raise 'Invalid url. Need absolute url'
end

read_page = ->(url) do
  open(url).read
end

gen_parse_all_links = ->(url) do
  ->(text) do
    text.to_s.scan(Regexp.new(/<a[^>]+href="(?:(?:#{url.scheme}:)?\/\/#{url.host})?((?:#{url.path}[\/\w\d-]*))/)).flatten.uniq
  end
end

# p gen_parse_all_links.call(url).call(read_page.call(url))

gen_absolute_url = ->(origin_absolute_url) do
  ->(url) do
    URI.parse("#{origin_absolute_url.scheme}://#{origin_absolute_url.host}#{url}").normalize
  end
end

absolute_url = gen_absolute_url.call(url)

links = ->(all_links, url) do
  unless all_links.has_key?(url)
    all_links[url] = gen_parse_all_links.call(absolute_url.call(url)).
        call(read_page.call(absolute_url.call(url)))
    all_links[url].each do
      |link| links.call(all_links, link)
    end
  end
  all_links
end

# p links.call({}, url)

sort_list_indegrees = ->(list_indegress) do
  list_indegress.to_a.sort do |(_, indegree1), (_, indegree2)|
    indegree1 <=> indegree2
  end.each do |(link, indegree)|
    p "#{link}: #{indegree}"
  end
end

list_indegrees = ->(all_links) do
  indegrees = {}
  all_links.each_value do |links|
    links.each do
      |link| indegrees[link] ||= 0
      indegrees[link] += 1
    end
  end
  indegrees
end

sort_list_indegrees.call(list_indegrees.call(links.call({}, url.path)))
