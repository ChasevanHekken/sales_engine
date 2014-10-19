require_relative 'test_helper.rb'
require_relative '../lib/item'
require_relative '../lib/sales_engine'
require 'bigdecimal'
require 'bigdecimal/util'
require 'time'

class ItemTest < Minitest::Test
  def test_item_attribute_matches_from_passed_in_data
    data = {
      id:           1,
      name:         'Item 43',
      description:  'So much stuff about item 43',
      unit_price:   89574,
      merchant_id:  4,
      created_at:   Time.parse('2012-03-27 14:53:59 UTC'),
      updated_at:   Time.parse('2012-03-27 14:53:59 UTC')
    }
    item = Item.new(data, nil)
    assert_equal 1, item.id
    assert_equal 'Item 43', item.name
    assert_equal 'So much stuff about item 43', item.description
    assert_equal '89574'.to_d, item.unit_price
    assert_equal 4, item.merchant_id
    assert_equal Time.parse('2012-03-27 14:53:59 UTC'), item.created_at
    assert_equal Time.parse('2012-03-27 14:53:59 UTC'), item.updated_at
  end

  def setup
    @engine ||= SalesEngine.new("test/data")
    @engine.startup
    @repo = @engine.item_repository
    @item = @repo.instances.first
  end

  def test_item_attribute_matches_from_loaded_file
    assert_equal 1, @item.id
    assert_equal 'Item 1', @item.name
    assert_equal 'stuff about 1', @item.description
    assert_equal '75107'.to_d/100, @item.unit_price
    assert_equal 1, @item.merchant_id
    assert_equal Time.parse('2012-03-27 14:53:59 UTC'), @item.created_at
    assert_equal Time.parse('2012-03-27 14:53:59 UTC'), @item.updated_at
  end

  def test_returns_correct_invoice_items_collection
    assert_equal @item.id, @item.invoice_items.first.item_id
  end

  def test_returns_correct_merchant
    assert_equal @item.merchant_id, @item.merchant.id
  end

  def test_invoice_item_find_returns_blank_array_if_no_match
    data = {
      id:           475739298283,
      name:         'Item 43',
      description:  'So much stuff about item 43',
      unit_price:   89574,
      merchant_id:  4,
      created_at:   Time.parse('2012-03-27 14:53:59 UTC'),
      updated_at:   Time.parse('2012-03-27 14:53:59 UTC')
    }
    bad_item = Item.new(data, @repo)
    assert_equal [], bad_item.invoice_items
  end

  def test_merchant_find_returns_nil_if_no_match
    data = {
      id:           1,
      name:         'Item 43',
      description:  'So much stuff about item 43',
      unit_price:   89574,
      merchant_id:  573872387387387474,
      created_at:   Time.parse('2012-03-27 14:53:59 UTC'),
      updated_at:   Time.parse('2012-03-27 14:53:59 UTC')
    }
    bad_item = Item.new(data, @repo)
    assert_equal nil, bad_item.merchant
  end
end
