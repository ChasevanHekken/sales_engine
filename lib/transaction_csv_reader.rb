require 'csv'
require 'time'

class TransactionCSVReader
  attr_reader :directory

  def initialize(directory)
    @directory = directory
  end

  def read(file)
    file_path = File.join(directory, file)
    csv = CSV.open(file_path, headers: true, header_converters: :symbol)
    csv.map do |row|
      {
        id:                          row[:id].to_i,
        invoice_id:                  row[:invoice_id].to_i,
        credit_card_number:          row[:credit_card_number].to_i,
        credit_card_expiration_date: row[:credit_card_expiration_date],
        result:                      row[:result],
        created_at:                  Time.parse(row[:created_at]),
        updated_at:                  Time.parse(row[:updated_at])
      }
    end
  end
end
