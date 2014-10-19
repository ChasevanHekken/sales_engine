require_relative 'test_helper.rb'
require_relative '../lib/sales_engine'

class SalesEngineTest < Minitest::Test
  def setup
    @engine = SalesEngine.new("test/data")
    @engine.startup
  end

  def test_item_repo_created_on_startup
    assert_kind_of ItemRepository, @engine.item_repository
  end

  def test_merchant_repo_created_on_startup
    assert_kind_of MerchantRepository, @engine.merchant_repository
  end

  def test_customer_repo_created_on_startup
    assert_kind_of CustomerRepository, @engine.customer_repository
  end

  def test_invoice_repo_created_on_startup
    assert_kind_of InvoiceRepository, @engine.invoice_repository
  end

  def test_transaction_repo_created_on_startup
    assert_kind_of TransactionRepository, @engine.transaction_repository
  end

  def test_invoice_item_repo_created_on_startup
    assert_kind_of InvoiceItemRepository, @engine.invoice_item_repository
  end

end
