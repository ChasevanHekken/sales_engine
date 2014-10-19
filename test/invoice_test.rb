require_relative 'test_helper.rb'
require_relative '../lib/invoice'
require_relative '../lib/sales_engine'
require 'time'

class InvoiceTest < Minitest::Test
  def test_item_attribute_matches
    data = {
      id:           1,
      customer_id:  2,
      merchant_id:  3,
      status:       'shipped',
      created_at:   Time.parse('2012-03-27 14:53:59 UTC'),
      updated_at:   Time.parse('2012-03-27 14:53:59 UTC')
    }
    invoice = Invoice.new(data, nil)
    assert_equal 1, invoice.id
    assert_equal 2, invoice.customer_id
    assert_equal 3, invoice.merchant_id
    assert_equal Time.parse('2012-03-27 14:53:59 UTC'), invoice.created_at
    assert_equal Time.parse('2012-03-27 14:53:59 UTC'), invoice.updated_at
  end

  def setup
    @engine = SalesEngine.new("test/data")
    @engine.startup
    @repo = @engine.invoice_repository
    @invoice = @repo.instances.first
    @bad_data = {
      id:           9999999999999999,
      customer_id:  9999999999999999,
      merchant_id:  9999999999999999,
      status:       'fuck yourself',
      created_at:   Time.parse('2012-03-27 11:11:11 UTC'),
      updated_at:   Time.parse('2012-03-27 11:11:11 UTC')
    }
    @bad_invoice = Invoice.new(@bad_data, @repo)
  end

  def test_transactions_returns_collection_of_asscoiated_transactions
    assert_equal @invoice.id, @invoice.transactions.first.invoice_id
  end

  def test_invoice_items_returns_collection_of_associated_invoice_items
    assert_equal @invoice.id, @invoice.invoice_items.first.invoice_id
  end

  def test_items_returns_collection_of_associated_items
    assert_equal Item, @invoice.items.first.class
  end

  def test_customer_returns_an_associated_customer
    assert_equal @invoice.customer_id, @invoice.customer.id
  end

  def test_merchant_returns_an_associated_merchant
    assert_equal @invoice.merchant_id, @invoice.merchant.id
  end

  def test_transactions_returns_empty_array_if_no_match
    assert_equal [], @bad_invoice.transactions
  end

  def test_invoice_items_returns_empty_array_if_no_match
    assert_equal [], @bad_invoice.invoice_items
  end

  def test_items_returns_empty_array_if_no_match
    assert_equal [], @bad_invoice.items
  end

  def test_customer_returns_nil_if_no_match
    assert_equal nil, @bad_invoice.customer
  end

  def test_merchant_returns_nil_if_no_match
    assert_equal nil, @bad_invoice.customer
  end
end
