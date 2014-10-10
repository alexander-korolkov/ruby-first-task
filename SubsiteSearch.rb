require ('open-uri')

url = "http://www.yandex.ru"

def look_for_subsite(url)
  subsite = open(url).read.
    scan(/#{url}\/[\w\d]+/).uniq
  print subsite
end

look_for_subsite(url)


