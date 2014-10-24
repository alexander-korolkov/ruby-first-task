require 'open-uri'


class BuildSubsite
  #include Testcase

  def get_html_by_url(url)
    @html = open(url).read
  end

  def get_array_of_sublinks(url, html)
    @links = html.scan(Regexp.new(/<a[^>]+href="(?:(?:#{url.scheme}:)?\/\/#{url.host})?((?:#{url.path}[\/\w\d-]*))/)).flatten.uniq
  end

  #path is something like '/contacts' or '/about'
  def get_subsite_url(origin_url, path)
    URI.parse("#{origin_url.scheme}://#{origin_url.host}#{path}").normalize
  end

  def count_indegree_in_subsite(subsite, url)
    links = get_array_of_sublinks.call( open(url).read )
    links.reduce(subsite) do |hash, link|
      if subsite.has_key?(link)
        subsite[link] += 1
      else
        subsite[link] = 0
        count_indegree_in_subsite.call(subsite, link)
      end
      subsite
    end
  end

end


url = URI.parse(ARGV[0]).normalize
unless url.absolute?()
  raise 'Invalid url. Need absolute url'
end

new_site = BuildSubsite.new
html = new_site.get_html_by_url(url)
links = new_site.get_array_of_sublinks(url, html)

p links
