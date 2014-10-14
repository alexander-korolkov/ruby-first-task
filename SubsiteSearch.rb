begin

  require ('open-uri')

  def look_for_subsite(url)
    subsite = open(url).read.
      scan(/(?<=href=")#{url}\/[\w\d\-]+/).uniq
    subsite << url
  end

  #Count Indegree. 
  count_indegree = lambda do |array_of_subsites| 
    hash_of_indegree = {}
    array_of_subsites.map do |url|
      array_of_subsites.map do |item|
         if(item != url)
           check = open(url).read =~ /(?<=href=")#{item}[\/]?(?=")"/
           unless check.nil?
             hash_of_indegree[item] ||= 0
             hash_of_indegree[item] = hash_of_indegree[item] + 1
           end 
         end
      end
    end
    hash_of_indegree
  end

  #Validate URL. Generate Exception if user to input not URL.
  #param url - string
  validate_url = lambda do |url|
    check_url = url =~ /^(http|https):\/\/|(www.)([\w-]+\.)+[\w-]+/
    if(check_url.nil?) 
      raise Exception, "Not valid URL: #{url}"
    end 
  end

  #Gets the URL string from user
  p "Please, input URL address the following format 'http://test.com':"
  url = gets
  url = url.chomp.to_s

  validate_url.call(url)
  rescue Exception => e 
    puts e.message  
  else

  #Remove trailing slash
  url = url.gsub(/\/$/,"") 

  array_of_subsites = look_for_subsite(url)

  p Hash[count_indegree.(array_of_subsites).sort_by{ |key, value| -value }]

end
