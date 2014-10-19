require_relative 'merchant'
require_relative 'repository_methods'
require 'csv'

class MerchantRepository
  include RepositoryMethods

  attr_reader :instances, :engine

  def attributes
    [
      'id',
      'name',
      'created_at',
      'updated_at'
    ]
  end

  def initialize(data, engine)
    @instances =  data.map { |row| Merchant.new(row, self) }
    @engine = engine
    define_finder_methods
  end

  def items_for(id)
    engine.items_for_merchant(id)
  end

  def invoices_for(id)
    engine.invoices_for_merchant(id)
  end

  def dates_by_revenue(number = 0)
    dates = engine.all_dates.sort_by{ |date| revenue(date) }.reverse
    dates[0..number - 1]
  end

  def revenue(date)
    instances.reduce(0) { |sum, merchant| sum + merchant.revenue(date) }
  end

  def most_revenue(number)
    rank_instances(number, :revenue)
  end

  def most_items(number)
    rank_instances(number, :sold_items)
  end
end
