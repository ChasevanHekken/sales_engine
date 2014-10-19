require_relative 'invoice_item'
require_relative 'repository_methods'
require 'csv'

class InvoiceItemRepository
  include RepositoryMethods

  attr_reader :instances, :engine

  def attributes
    [
      'id',
      'item_id',
      'invoice_id',
      'quantity',
      'unit_price',
      'created_at',
      'updated_at'
    ]
  end

  def initialize(data, engine)
    @instances =  data.map { |row| InvoiceItem.new(row, self) }
    @engine = engine
    define_finder_methods
  end

  def item_for(item_id)
    engine.item_for_invoice_item(item_id)
  end

  def invoice_for(invoice_id)
    engine.invoice_for_invoice_item(invoice_id)
  end
end
