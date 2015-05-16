require 'capybara'
require 'pry'
require 'nokogiri'

class Crawler
  include Capybara::DSL

  def initialize
    Capybara.current_driver = :selenium
  end

  def crawl
    (0..9).each do |option_num|
      visit "http://wa.nccu.edu.tw/QryTor/"
      first('option[value="1031"]').select_option
      first("select[name=\"t_colLB\"] option[value=\"#{option_num}\"]").select_option
      first(:link, '送出查詢').click
      first('#numberpageRBL_4').click

      page_count = 1
      while @prev_html != html
        # doc = Nokogiri::HTML(html)

        @prev_html = html
        File.open("1031/#{option_num}_#{page_count}.html", 'w') { |f| f.write(html) }
        # 解析

        sleep 0.5
        first('#nextLB').click
        page_count = page_count + 1
      end
      # last page
    end


  end


end

crawler = Crawler.new
crawler.crawl

# binding.pry