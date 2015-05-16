require 'nokogiri'
require 'pry'
require 'json'
require 'rest-client'

@courses = []
Dir.glob('./1031/*.html') do |file_1031|
	string = File.read(file_1031)
	document = Nokogiri::HTML(string.to_s)

	(0..49).each do |tr_number|
		table =  document.css("#qryresult#{tr_number}_QryTr")
			datas = table.css('td')
			#count = 10
			hash =  {
				semester: datas[1] && datas[1].text.strip,
				class_id: datas[2] && datas[2].text.strip.gsub(/\s+/, ' '),
				lecturer: datas[3] && datas[3].text.strip,
				credit: datas[4] && datas[4].text.strip,
				class_time: datas[5] && datas[5].text.strip.gsub(/\s+/, ' '),
				classroom: datas[6] && datas[6].text.strip,
				# 要把gif檔抓出 outline: datas[7] && datas[7].text.strip,
				language: datas[10] && datas[10].text.strip,
				department: datas[14] && datas[14].text.strip,
				semester_time: datas[15] && datas[15].text.strip.gsub(/\s+/, ' '),
			}
		table =  document.css("html table tr#qryresult#{tr_number}_Qrytt")
			
			datas = table.css('td')
			hash.merge!({
				name: datas[0] && datas[0].text.strip,
				name_ref: datas[0] && datas[0].css('a')[0] && datas[0].css('a')[0][:href],				
				note: datas[1] && datas[1].text.strip.gsub(/\s+/, ' '),
			})	

			@courses << hash
	end

	
end

File.open('courses.json','w'){|file| file.write(JSON.pretty_generate(@courses))}