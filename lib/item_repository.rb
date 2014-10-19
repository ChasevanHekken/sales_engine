require_relative 'item'
require_relative 'repository_methods'
require 'csv'

class ItemRepository
  include RepositoryMethods

  attr_reader :instances, :engine

  def attributes
    [
      'id',
      'name',
      'description',
      'unit_price',
      'merchant_id',
      'created_at',
      'updated_at'
    ]
  end

  def initialize(data, engine)
    @instances =  data.map { |row| Item.new(row, self) }
    @engine = engine
    define_finder_methods
  end

  def invoice_item_for(id)
    engine.invoice_item_for_item(id)
  end

  def merchant_for(merchant_id)
    engine.merchant_for_item(merchant_id)
  end

  def most_revenue(number)
    rank_instances(number, :revenue)
  end

  def most_items(number)
    rank_instances(number, :sold_items)
  end
end
