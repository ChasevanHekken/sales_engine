require_relative 'test_helper.rb'
require_relative '../lib/invoice_item_repository'
require 'bigdecimal'
require 'bigdecimal/util'
require 'time'

class InvoiceItemRepositoryTest < Minitest::Test
  def setup
    data1 = {
      id:           1,
      item_id:      4,
      invoice_id:   3,
      quantity:     34,
      unit_price:   75107,
      created_at:   Time.parse('2012-03-27 14:53:59 UTC'),
      updated_at:   Time.parse('2012-03-27 14:53:59 UTC')
    }

    data2 = {
      id:           2,
      item_id:      4,
      invoice_id:   5,
      quantity:     34,
      unit_price:   65803,
      created_at:   Time.parse('2012-03-27 14:54:59 UTC'),
      updated_at:   Time.parse('2012-03-27 14:54:59 UTC')
    }
    data = [data1, data2]
    @repo = InvoiceItemRepository.new(data, nil)
  end

  def test_find_by_id
    assert_equal 1, @repo.find_by_id("1").id
  end

  def test_find_by_item_id
    assert_equal 1, @repo.find_by_item_id("4").id
  end

  def test_find_by_invoice_id
    assert_equal 2, @repo.find_by_invoice_id("5").id
  end

  def test_find_by_quantity
    assert_equal 1, @repo.find_by_quantity("34").id
  end

  def test_find_by_unit_price
    assert_equal 2, @repo.find_by_unit_price("65803").id
  end

  def test_find_by_created_at
    assert_equal 1, @repo.find_by_created_at("2012-03-27 14:53:59 UTC").id
  end

  def def_find_by_updated_at
    assert_equal 2, @repo.find_by_updated_at("2012-03-27 14:54:59 UTC").id
  end

  def test_find_returns_nil_if_no_match
    assert_nil @repo.find_by_id("17")
  end

  def test_find_all_by_id
    result = @repo.find_all_by_id("1")
    assert_equal 1, result.size
  end

  def test_find_all_by_item_id
    result = @repo.find_all_by_item_id("4")
    assert_equal 2, result.size
  end

  def test_find_all_by_quantity
    result = @repo.find_all_by_quantity("34")
    assert_equal 2, result.size
  end

  def test_find_all_by_created_at
    result = @repo.find_all_by_created_at("2012-03-27 14:53:59 UTC")
    assert_equal 1, result.size
  end

  def test_def_find_all_by_updated_at
    result = @repo.find_all_by_updated_at("2012-03-27 14:53:59 UTC")
    assert_equal 1, result.size
  end

  def test_find_all_returns_empty_array_if_no_match
    assert_equal [], @repo.find_all_by_id("45")
  end

  def test_find_all_returns_empty_array_if_no_match
    assert_equal [], @repo.find_all_by_id("39")
  end

  def test_random_method_returns_one_instance
    result = @repo.random
    assert_equal InvoiceItem, result.class
  end

  def test_all_method_returns_all_instances
    result = @repo.all
    assert_equal 2, result.size
  end
  
  def test_inspect_returns_string
    assert_equal String, @repo.inspect.class
  end
end
