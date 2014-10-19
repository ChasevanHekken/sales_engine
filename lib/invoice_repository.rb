require_relative 'invoice'
require_relative 'repository_methods'
require_relative 'invoice_item'
require 'time'
require 'bigdecimal'
require 'bigdecimal/util'

class InvoiceRepository
  include RepositoryMethods

  attr_reader :instances, :engine

  def attributes
    [
      'id',
      'customer_id',
      'merchant_id',
      'status',
      'created_at',
      'updated_at'
    ]
  end

  def initialize(data, engine)
    @instances =  data.map { |row| Invoice.new(row, self) }
    @engine = engine
    define_finder_methods
  end

  def transactions_for(id)
    engine.transactions_for_invoice(id)
  end

  def invoice_items_for(id)
    engine.invoice_items_for_invoice(id)
  end

  def items_for(id)
    engine.items_for_invoice(id)
  end

  def customer_for(customer_id)
    engine.customer_for_invoice(customer_id)
  end

  def merchant_for(merchant_id)
    engine.merchant_for_invoice(merchant_id)
  end

  def create(args)
    customer = args.fetch(:customer)
    merchant = args.fetch(:merchant)
    items = args.fetch(:items)
    create_invoice(customer, merchant, items)
  end

  def create_invoice(customer, merchant, items)
    data = {
      id:          instances.last.id.to_i + 1,
      customer_id: customer.id,
      merchant_id: merchant.id,
      status:      "shipped",
      created_at:  Time.now.utc,
      updated_at:  Time.now.utc
    }
    invoice = Invoice.new(data, self)
    instances << invoice
    create_invoice_item(customer, merchant, items)
    invoice
  end

  def create_invoice_item(customer, merchant, items)
    inv_item_repo = engine.invoice_item_repository
    items.uniq.each do |item|
      data = {
        id:         inv_item_repo.instances.last.id.to_i + 1,
        item_id:    item.id,
        invoice_id: instances.last.id,
        quantity:   items.count(item),
        unit_price: item.unit_price,
        created_at: Time.now.utc,
        updated_at: Time.now.utc
      }
      inv_item_repo.add_instance(InvoiceItem.new(data, inv_item_repo))
    end
  end

  def average_revenue(date=false)
    average_by(:revenue, date)
  end

  def average_items(date=false)
    average_by(:sold_items, date)
  end

  def average_by(criteria, date)
    invoice_set = date ? invoices_by(date) : successful_invoices
    result = invoice_set.reduce(0) do |sum, invoice|
      sum + invoice.send(criteria)
    end
    (result.to_d / invoice_set.size).round(2)
  end

  def invoices_by(date)
    successful_invoices.select { |invoice| date == invoice.created_at.to_date }
  end

  def pending
    instances.reject(&:success?)
  end

  def successful_invoices
    @si ||= instances - pending
  end
end
