require 'rubygems'
require 'nokogiri'
  require "faster_csv"
  CSV = FCSV

csv_string = CSV.generate() do |csv| #options={:col_sep => "\t" }

  doc = Nokogiri::HTML(ARGF.read)

  # Read only the table
  doc.css('div.data-table').each do |x|
    # This is necessary because of the shitty HTML, else nokogiri doesn't constrain its search
    table = Nokogiri::HTML(x.to_s)

    # Read the header row in and count how many columns
    columns = 0
    header = []
    table.xpath('//th').each do |cell|
      header << cell.content
      columns += 1
    end

    csv << header

    # Read column number of rows and add then as a column
    cells_read = 0
    row = []
    table.xpath('//td').each do |cell|
      row << cell.content
      cells_read += 1
      if cells_read == columns
        csv << row
        cells_read = 0
        row = []
      end
    end


  end

end

puts csv_string.gsub(/&nbsp/, "")
