require 'csv'
require 'time'

class InvoiceCSVReader
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
        customer_id: row[:customer_id].to_i,
        merchant_id: row[:merchant_id].to_i,
        status:      row[:status],
        created_at:  Time.parse(row[:created_at]),
        updated_at:  Time.parse(row[:updated_at])
      }
    end
  end
end
