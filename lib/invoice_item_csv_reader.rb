require 'csv'
require 'bigdecimal'
require 'bigdecimal/util'
require 'time'

class InvoiceItemCSVReader
  attr_reader :directory

  def initialize(directory)
    @directory = directory
  end

  def read(file)
    file_path = File.join(directory, file)
    csv = CSV.open(file_path, headers: true, header_converters: :symbol)
    csv.map do |row|
      {
        id:         row[:id].to_i,
        item_id:    row[:item_id].to_i,
        invoice_id: row[:invoice_id].to_i,
        quantity:   row[:quantity].to_i,
        unit_price: row[:unit_price].to_d/100,
        created_at: Time.parse(row[:created_at]),
        updated_at: Time.parse(row[:updated_at])
      }
    end
  end
end
