require 'csv'
require 'bigdecimal'
require 'bigdecimal/util'
require 'time'

class ItemCSVReader
  attr_reader :directory

  def initialize(directory)
    @directory = directory
  end

  def read(file)
    file_path = File.join(directory, file)
    csv = CSV.open(file_path, headers: true, header_converters: :symbol)
    csv.map do |row|
      {
        id:          row[:id].to_i,
        name:        row[:name],
        description: row[:description],
        unit_price:  row[:unit_price].to_d/100,
        merchant_id: row[:merchant_id].to_i,
        created_at:  Time.parse(row[:created_at]),
        updated_at:  Time.parse(row[:updated_at])
      }
    end
  end
end
