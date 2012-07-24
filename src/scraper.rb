require "rubygems"
require "bundler/setup"
require "nokogiri"
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
		url = get_calendar_url date
		doc = download_page url
		puts doc
	end
end

class Date
	def iterate_monthly to, &block
		# Get the first of each month
		months = self.step(to).select { |date| date.day == 1 }
		months.each do |date| 
			yield(date)
		end
	end
end

class Scraper
	def initialize years, download_dir
		@years = years.to_i
		@download_dir = download_dir
		@flickr_util = FlickrUtil.new 
	end

	def scrape
		to = Date.today
		from = Date.new(to.year-@years)
		from.iterate_monthly(to) { |date| @flickr_util.scrape_calendar(date) }
	end

end


raise "Usage: 'ruby scraper.rb <years to download> <directory>'" if ARGV.size != 2 

scraper = Scraper.new ARGV[0], ARGV[1]
scraper.scrape
