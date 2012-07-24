#!/usr/bin/ruby
# Wrapper for getting the URLs of images on flickr

class FlickrInterface 
	def initialize
		@base_url = 'http://www.flickr.com/explore/interesting'
	end

	def get_calendar_url year=nil, month=nil 
		t = Time.now
		year ||= t.year
		month ||= t.month

		# Pad dates
		[@base_url, "%04d" % year, "%02d" % month]
				.join('/')
	end

end

f = FlickrInterface.new
puts f.get_calendar_url
puts f.get_calendar_url 1, 1
