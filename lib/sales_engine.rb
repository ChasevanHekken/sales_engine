require_relative 'item_repository'
require_relative 'merchant_repository'
require_relative 'customer_repository'
require_relative 'invoice_item_repository'
require_relative 'transaction_repository'
require_relative 'invoice_repository'
require_relative 'item_csv_reader'
require_relative 'merchant_csv_reader'
require_relative 'customer_csv_reader'
require_relative 'invoice_item_csv_reader'
require_relative 'transaction_csv_reader'
require_relative 'invoice_csv_reader'

class SalesEngine
  attr_reader :item_repository,
              :merchant_repository,
              :customer_repository,
              :invoice_item_repository,
              :transaction_repository,
              :invoice_repository,
              :dir

  def initialize(dir='data')
    @dir = dir
  end

  def startup
    item_dat = ItemCSVReader.new(dir).read('items.csv')
    merchant_dat = MerchantCSVReader.new(dir).read('merchants.csv')
    customer_dat = CustomerCSVReader.new(dir).read('customers.csv')
    invoice_item_dat = InvoiceItemCSVReader.new(dir).read('invoice_items.csv')
    transaction_dat = TransactionCSVReader.new(dir).read('transactions.csv')
    invoice_dat = InvoiceCSVReader.new(dir).read('invoices.csv')
    @item_repository = ItemRepository.new(item_dat, self)
    @merchant_repository = MerchantRepository.new(merchant_dat, self)
    @customer_repository = CustomerRepository.new(customer_dat, self)
    @invoice_item_repository = InvoiceItemRepository.new(invoice_item_dat, self)
    @transaction_repository = TransactionRepository.new(transaction_dat, self)
    @invoice_repository = InvoiceRepository.new(invoice_dat, self)
  end

  def invoices_for_customer(id)
    invoice_repository.find_all_by_customer_id(id)
  end

  def items_for_merchant(id)
    item_repository.find_all_by_merchant_id(id)
  end

  def invoices_for_merchant(id)
    invoice_repository.find_all_by_merchant_id(id)
  end

  def invoice_for_transaction(id)
    invoice_repository.find_by_id(id)
  end

  def transactions_for_invoice(id)
    transaction_repository.find_all_by_invoice_id(id)
  end

  def invoice_items_for_invoice(id)
    invoice_item_repository.find_all_by_invoice_id(id)
  end

  def items_for_invoice(id)
    ids = invoice_items_for_invoice(id).map do |invoice_item|
      invoice_item.item_id
    end
    ids.map{ |id| item_repository.find_by_id(id) }
  end

  def customer_for_invoice(id)
    customer_repository.find_by_id(id)
  end

  def merchant_for_invoice(id)
    merchant_repository.find_by_id(id)
  end

  def item_for_invoice_item(id)
    item_repository.find_by_id(id)
  end

  def invoice_for_invoice_item(id)
    invoice_repository.find_by_id(id)
  end

  def invoice_item_for_item(id)
    invoice_item_repository.find_all_by_item_id(id)
  end

  def merchant_for_item(id)
    merchant_repository.find_by_id(id)
  end

  def all_dates
    invoice_repository.instances.map do |invoice|
      invoice.created_at.to_date
    end.uniq
  end
end
