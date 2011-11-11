#!/usr/bin/env ruby

require 'json'

def import_nro
  filename = 'nro.json'
  File.open(filename, 'r') do |f|
    data = JSON.parse(f.read)
    puts data
  end

end

import_nro
