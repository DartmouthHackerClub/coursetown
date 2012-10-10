require 'csv'
require 'nokogiri'

csv_string = CSV.generate do |csv|

  doc = Nokogiri::HTML(ARGF.read)
  
  current_row = []
  
  # This is necessary because it makes things work nicely
  table = Nokogiri::HTML(doc.xpath('//table')[6].to_s)
  
  table.xpath('//tr').each do |row|
    row.xpath('td').each do |cell|
      current_row << cell.content.gsub(/\n/, "") unless cell.content == "&nbsp"
    end
    csv << current_row unless current_row.empty?
    current_row = []
  end
    
end

puts csv_string.gsub(/\"\"/, "").strip