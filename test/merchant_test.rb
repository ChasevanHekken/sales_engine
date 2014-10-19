require_relative 'test_helper.rb'
require_relative '../lib/sales_engine'
require_relative '../lib/merchant'
require 'time'

class MerchantTest < Minitest::Test

  def test_merchant_attribute_matches
    data = {
      id:         4,
      name:       "mary jones",
      created_at: Time.parse("2013-08-17 11:41:34 UTC"),
      updated_at: Time.parse("2013-08-17 11:41:32 UTC")
    }
    merchant = Merchant.new(data, nil)
    assert_equal 4, merchant.id
    assert_equal "mary jones", merchant.name
    assert_equal Time.parse('2013-08-17 11:41:34 UTC'), merchant.created_at
    assert_equal Time.parse('2013-08-17 11:41:32 UTC'), merchant.updated_at
  end

  def setup
    @engine = SalesEngine.new("test/data")
    @engine.startup
    @repo = @engine.merchant_repository
    @merchant = @repo.instances.first
  end

  def test_merchant_attribute_matches
    assert_equal 1, @merchant.id
    assert_equal 'Schroeder-Jerde', @merchant.name
    assert_equal Time.parse('2012-03-27 14:53:59 UTC'), @merchant.created_at
    assert_equal Time.parse('2012-03-27 14:53:59 UTC'), @merchant.updated_at
  end

  def test_returns_correct_array_of_invoices_for_merchant
    assert_equal @merchant.id, @merchant.invoices.first.merchant_id
  end

  def test_returns_correct_array_of_items_for_merchant
    assert_equal @merchant.id, @merchant.items.first.merchant_id
  end

  def test_merchant_invoices_returns_empty_array_if_no_invoice
    data = {
      id:         '84',
      name:       'joe bob',
      created_at: '2012-03-27 14:54:09 UTC',
      updated_at: '2012-03-27 14:54:09 UTC'
    }
    bad_merchant = Merchant.new(data, @repo)
    assert_equal [], bad_merchant.invoices
  end

  def test_merchant_items_returns_empty_array_if_no_items
    data = {
      id:         '73',
      name: 'billy bob',
      created_at: '2012-03-27 14:54:09 UTC',
      updated_at: '2012-03-27 14:54:09 UTC'
    }
    bad_merchant = Merchant.new(data, @repo)
    assert_equal [], bad_merchant.items
  end

  def test_revenue_returns_proper_revenue
    assert_equal 0, @merchant.revenue
  end

  def test_revenue_with_date_returns_proper_revenue
    assert_equal 0, @merchant.revenue(Time.parse('2012-03-23 05:55:39 UTC'))
  end

  def test_favorite_customer
  end

  def test_customers_with_pending_invoices
  end
end
