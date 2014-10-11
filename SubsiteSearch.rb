begin

  require ('open-uri')

  #Gets the URL string from user
  p "Please, input URL address the following format 'http://test.com':"
  url = gets
  url = url.chomp.to_s

  #Validate URL. Generate Exception if user to input not URL.
  #param url - string
  validate_url = lambda do |url|
    check_url = url =~ /^(http|https):\/\/|(www.)([\w-]+\.)+[\w-]+/
    if(check_url.nil?) 
      raise Exception, "Not valid URL: #{url}"
    end 
  end

  def look_for_subsite(url)
    subsite = open(url).read.
      scan(/#{url}\/[\w\d]+/).uniq
    print subsite
  end

  validate_url.call(url)
  rescue Exception => e 
    puts e.message  
  else

  look_for_subsite(url)

end
