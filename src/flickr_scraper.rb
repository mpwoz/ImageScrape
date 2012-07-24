require "rubygems"
require "bundler/setup"
require "hpricot"
require "open-uri"

class FlickrUtil 
	def initialize
		@base_url = 'http://www.flickr.com/explore/interesting'
	end

	# Get the url for a given Time
	def get_calendar_url date=Date.today
		[@base_url, "%04d" % date.year, "%02d" % date.month]
				.join('/')
	end

	def download_page url
		Hpricot(open(url))
	end

	def scrape_images_from_document doc
		
	end

	def scrape_calendar date=Date.today
		#TODO
		puts date
	end
end

# Todo : make this a Date extension to iterate backwards from today with arbitrary delta
module DateUtil
	def iterate_monthly from, to, &block
		# Get the first of each month
		months = from.step(to).select { |date| date.day == 1 }
		months.each do |date| 
			yield(date)
		end
	end
end

class FlickrScraper
	def initialize years, download_dir
		@years = years.to_i
		@download_dir = download_dir
		@flickr_util = FlickrUtil.new 
	end

	def scrape
		d = Date.today
		DateUtil::iterate_monthly(
					Date.new(d.year - @years), d) do |date| 
							@flickr_util.scrape_calendar(date) end
	end

end


raise "Usage: 'ruby flickr_scraper.rb <years to download> <directory>'" if ARGV.size != 2 

scraper = FlickrScraper.new ARGV[0], ARGV[1]
scraper.scrape
