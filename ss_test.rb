# test #1 to parse links

load './ss.rb'

gen_parse_all_links = ->(url) do
  ->(text) do
    # text.to_s.scan(Regexp.new(/<a[^>]+href="(?:(?:#{url.scheme}:)?\/\/#{url.host})?((?:#{url.path}[\/\w\d-]*))/)).flatten.uniq
    text.to_s.scan(Regexp.new(/<a[^>]+href="(?:(?:#{url.scheme}:)?\/\/#{url.host})?((?:#{url.path}(?<!\/)[\/\w\d-]*))/)).flatten.uniq
  end
end

test_url = URI.parse('http://site.ru').normalize
parse_links = gen_parse_all_links.call(test_url)
test_string = {
    '<a href="http://site.ru/sub/sub1">' => ['/sub/sub1'],
    '<a href="//site.ru/sub/sub1/sub2">' => ['/sub/sub1/sub2'],
    '<a href="/sub/sub1">' => ['/sub/sub1'],
    '<a href="/">' => ['/'],
    '<a attr="" href="http://site.ru/sub-123134?query#fragment">' => ['/sub-123134'],
    '<a attr="" href="http://siteeee.ru/sub">' => [],
    '<a attr="" href="//tune.site.ru/">' => []
}



require 'minitest/unit'

include Minitest::Assertions
test_string.each do |test, expected|
  print test
  begin
    print actual = parse_links.call(test)
    assert actual == expected
  rescue Minitest::Assertion
    p '   FAIL'
  else
    p '   OK'
  end
end
