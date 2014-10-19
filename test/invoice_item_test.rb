require_relative 'test_helper.rb'
require_relative '../lib/invoice_item'
require_relative '../lib/sales_engine'
require 'bigdecimal'
require 'bigdecimal/util'
require 'time'

class InvoiceItemTest < Minitest::Test

  def test_invoice_item_attribute_matches
    data = {
      id:           1,
      item_id:      4,
      invoice_id:   3,
      quantity:     34,
      unit_price:   75107,
      created_at:   Time.parse('2012-03-27 14:53:59 UTC'),
      updated_at:   Time.parse('2012-03-27 14:53:59 UTC')
    }
    invoice_item = InvoiceItem.new(data, nil)
    assert_equal 3, invoice_item.invoice_id
    assert_equal 4, invoice_item.item_id
    assert_equal Time.parse('2012-03-27 14:53:59 UTC'), invoice_item.created_at
    assert_equal Time.parse('2012-03-27 14:53:59 UTC'), invoice_item.updated_at
  end

  def setup
    @engine ||= SalesEngine.new("test/data")
    @engine.startup
    @repo = @engine.invoice_item_repository
    @invoice_item = @repo.instances.first
  end

  def test_invoice_item_attribute_matches_from_loaded_file
    assert_equal 1, @invoice_item.id
    assert_equal 539, @invoice_item.item_id
    assert_equal 1, @invoice_item.invoice_id
    assert_equal 5, @invoice_item.quantity
    assert_equal 13635.to_d/100, @invoice_item.unit_price
    assert_equal Time.parse('2012-03-27 14:54:09 UTC'), @invoice_item.created_at
    assert_equal Time.parse('2012-03-27 14:54:09 UTC'), @invoice_item.updated_at
  end

  def test_returns_correct_invoice_for_invoice_item
    assert_equal @invoice_item.invoice_id, @invoice_item.invoice.id
  end

  def test_returns_correct_item_for_invoice_item
    assert_equal @invoice_item.item_id, @invoice_item.item.id
  end

  def test_invoice_id_invoices_returns_nil_if_no_match
    data = {
      id:           '1',
      item_id:      '4',
      invoice_id:   '47473',
      quantity:     '34',
      unit_price:   '75107',
      created_at:   '2012-03-27 14:53:59 UTC',
      updated_at:   '2012-03-27 14:53:59 UTC'
    }
    bad_invoice_item = InvoiceItem.new(data, @repo)
    assert_equal nil, bad_invoice_item.invoice
  end

  def test_item_id_returns_nil_if_no_match
    data = {
      id:           '1',
      item_id:      '47574838838',
      invoice_id:   '3',
      quantity:     '34',
      unit_price:   '75107',
      created_at:   '2012-03-27 14:53:59 UTC',
      updated_at:   '2012-03-27 14:53:59 UTC'
    }
    bad_invoice_item = InvoiceItem.new(data, @repo)
    assert_equal nil, bad_invoice_item.item
  end

end
