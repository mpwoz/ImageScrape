require "rubygems"
require "bundler/setup"
require "nokogiri"
require "open-uri"

class FileDownloader
	def initialize download_dir
	end

	def download url
	end
end

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
		Nokogiri::HTML(open(url))
	end

	def scrape_images_from_document doc
		lines = doc.to_s.split("\n").collect do |line| 
			/thumb:'(.+jpg)?/.match(line)
		end

		lines.compact!.map! { |li| li[1] }
	end

	def scrape_calendar date=Date.today
		url = get_calendar_url date
		doc = download_page url
		scrape_images_from_document(doc)
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
		@file_downloader = FileDownloader.new download_dir
	end

	def scrape
		to = Date.today
		from = Date.new(to.year-@years)
		from.iterate_monthly(to) { |date| download_date(date) }
	end

	def download_date date
		puts "Downloading #{date}"

		image_urls = @flickr_util.scrape_calendar(date)
		num = image_urls.count - 1

		image_urls.each_with_index do |imgurl, index| 
				# Update with percentage progress
				puts "#{index*100/num}%" if index % 20 == 0
				download_image imgurl
			end
	end

	def download_image url
		@file_downloader.download url
	end

end


raise "Usage: 'ruby scraper.rb <years to download> <directory>'" if ARGV.size != 2 

scraper = Scraper.new ARGV[0], ARGV[1]
scraper.scrape
