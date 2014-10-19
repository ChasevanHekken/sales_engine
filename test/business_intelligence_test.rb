require_relative 'test_helper.rb'
require_relative '../lib/sales_engine'

require_relative '../lib/customer'
require_relative '../lib/invoice'
require_relative '../lib/invoice_item'
require_relative '../lib/merchant'
require_relative '../lib/item'
require_relative '../lib/transaction'

require_relative '../lib/customer_repository'
require_relative '../lib/invoice_repository'
require_relative '../lib/invoice_item_repository'
require_relative '../lib/merchant_repository'
require_relative '../lib/item_repository'
require_relative '../lib/transaction_repository'
require 'time'

class BusinessIntelligeceTest < Minitest::Test
  def setup
    @engine = SalesEngine.new("test/bi_data")
    @engine.startup

    @cust_repo = @engine.customer_repository
    @customer = @cust_repo.instances.first

    @inv_repo = @engine.invoice_repository
    @invoice = @inv_repo.instances.first

    @inv_item_repo = @engine.invoice_item_repository
    @invoice_item = @inv_item_repo.instances.first

    @merch_repo = @engine.merchant_repository
    @merchant = @merch_repo.instances.first

    @item_repo = @engine.item_repository
    @item = @item_repo.instances.first

    @trans_repo = @engine.transaction_repository
    @transaction = @trans_repo.instances.first
  end

  # merchant_repo---------------------------------------------------------------

  def test_merchant_repo_most_revenue
    assert_equal 1, @merch_repo.most_revenue(1).first.id
  end

  def test_merchant_repo_most_items
    assert_equal 1, @merch_repo.most_items(1).first.id
  end

  def test_merchant_repo_revenue_by_date
    assert_equal 21067, @merch_repo.revenue(Date.parse("2012-03-25")).to_i
  end

  # merchant--------------------------------------------------------------------

  def test_merchant_revenue
    assert_equal 22940, @merchant.revenue.to_i
  end

  def test_merchant_revenue_by_date
    assert_equal 21067, @merchant.revenue(Date.parse("2012-03-25")).to_i
  end

  def test_merchant_favorite_customer
    assert_equal 1, @merchant.favorite_customer.id
  end

  def test_merchant_customers_with_pending_invoices
    assert_equal 1, @merchant.customers_with_pending_invoices.first.id
  end

# item_repo---------------------------------------------------------------------

  def test_item_repo_most_revenue
    assert_equal 1, @item_repo.most_revenue(1).first.id
  end

  def test_item_repo_most_items
    assert_equal 1, @item_repo.most_items(1).first.id
  end

# item--------------------------------------------------------------------------

  def test_item_best_day
    assert_equal Date.parse("2012-03-25"), @item.best_day
  end

# customer----------------------------------------------------------------------

  def test_customer_transactions
    assert_equal 1, @customer.transactions.first.id
  end

  def test_customer_favorite_merchant
    assert_equal 1, @customer.favorite_merchant.id
  end

# invoice-----------------------------------------------------------------------

  def test_create_new_invoice
    repo_size = @inv_repo.instances.size
    @inv_repo.create(customer: @customer, merchant: @merchant, items: [@item])
    assert_equal repo_size + 1, @inv_repo.instances.size
  end

  def test_charge_invoice
    cc = '1111444455551111'
    date = '10/14'
    result = 'hi'
    repo_size = @trans_repo.instances.size
    @invoice.charge(credit_card_number: cc,
                    credit_card_expiration_date: date,
                    result: result)
    assert_equal repo_size + 1, @trans_repo.instances.size
  end

# merchant_repo extension-------------------------------------------------------

  def test_merchant_repo_dates_by_revenue
    assert_equal Date.parse("2012-03-07"), @merch_repo.dates_by_revenue.last
  end

  def test_merchant_repo_dates_by_revenue_x
    assert_equal Date.parse("2012-03-25"), @merch_repo.dates_by_revenue(1).last
  end

  def test_merchant_repo_revenue_range_of_dates
    date1 = Date.parse("2012-03-07")
    date2 = Date.parse("2012-03-25")
    assert_equal 22940, @merch_repo.revenue(date1..date2).to_i
  end

# merchant extension------------------------------------------------------------

  def test_merchant_revenue_range_of_dates
    date1 = Date.parse("2012-03-07")
    date2 = Date.parse("2012-03-25")
    assert_equal 22940, @merchant.revenue(date1..date2).to_i
  end

# invoice_repo extension--------------------------------------------------------

  def test_invoice_repo_pending
    assert_equal 3, @inv_repo.pending.last.id
  end

  def test_invoice_repo_average_revenue
    assert_equal 5735, @inv_repo.average_revenue.to_i
  end

  def test_invoice_repo_average_revenue_by_date
    assert_equal 21067, @inv_repo.average_revenue(Date.parse("2012-03-25")).to_i
  end

  def test_invoice_repo_average_items
    assert_equal 14, @inv_repo.average_items.to_i
  end

  def test_invoice_repo_average_items_by_date
    assert_equal 47, @inv_repo.average_items(Date.parse("2012-03-25")).to_i
  end

# customer_repo extension-------------------------------------------------------

  def test_customer_repo_most_items
    assert_equal 1, @cust_repo.most_items.id
  end

  def test_customer_repo_most_revenue
    assert_equal 1, @cust_repo.most_revenue.id
  end

# customer extension------------------------------------------------------------

  def test_customer_days_since_activity
    assert_equal Date.today - Date.parse("2012-03-25"), @customer.days_since_activity
  end

  def test_customer_pending_invoices
    assert_equal 3, @customer.pending_invoices.last.id
  end
end
