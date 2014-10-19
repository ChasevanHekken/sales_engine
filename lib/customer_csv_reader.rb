require 'csv'
require 'time'

class CustomerCSVReader
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
        first_name: row[:first_name],
        last_name:  row[:last_name],
        created_at: Time.parse(row[:created_at]),
        updated_at: Time.parse(row[:updated_at])
      }
    end
  end
end
