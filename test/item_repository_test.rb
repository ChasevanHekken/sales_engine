require_relative 'test_helper.rb'
require_relative '../lib/item_repository'
require 'bigdecimal'
require 'bigdecimal/util'
require 'time'

class ItemRepositoryTest < Minitest::Test
  def setup
    data1 = {
      id:           1,
      name:         "item 1",
      description:  "stuff about 1",
      unit_price:   "75107".to_d,
      merchant_id:  3,
      created_at:   Time.parse("2012-03-27 14:53:59 UTC"),
      updated_at:   Time.parse("2012-03-27 14:53:59 UTC")
    }

    data2 = {
      id:           2,
      name:         "item 2",
      description:  "stuff about 2",
      unit_price:   "56789".to_d,
      merchant_id:  3,
      created_at:   Time.parse("2013-04-17 14:53:59 UTC"),
      updated_at:   Time.parse("2013-04-17 14:53:59 UTC")
    }

    data3 = {
      id:           3,
      name:         "item 3",
      description:  "stuff about 3",
      unit_price:   "56789".to_d,
      merchant_id:  5,
      created_at:   Time.parse("2013-04-17 14:53:59 UTC"),
      updated_at:   Time.parse("2013-04-17 14:53:59 UTC")
    }

    data = [data1, data2, data3]
    @repo = ItemRepository.new(data, nil)
  end

  def test_find_by_id
    assert_equal 1, @repo.find_by_id("1").id
  end

  def test_find_by_name
    assert_equal 2, @repo.find_by_name("item 2").id
  end

  def test_find_by_description
    assert_equal 1, @repo.find_by_description("stuff about 1").id
  end

  def test_find_by_unit_price
    assert_equal 1, @repo.find_by_unit_price(75107.to_d).id
  end

  def test_find_by_created_at
    assert_equal 1, @repo.find_by_created_at("2012-03-27 14:53:59 UTC").id
  end

  def def_find_by_updated_at
    assert_equal 2, @repo.find_by_updated_at("2013-04-17 14:53:59 UTC").id
  end

  def test_find_returns_nil_if_no_match
    assert_nil @repo.find_by_id(17)
  end

  def test_find_all_by_id
    result = @repo.find_all_by_id(1)
    assert_equal 1, result.size
  end

  def test_find_all_by_merchant_id
    result = @repo.find_all_by_merchant_id(3)
    assert_equal 2, result.size
  end

  def test_find_all_by_unit_price
    result = @repo.find_all_by_unit_price(56789.to_d)
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
    assert_equal [], @repo.find_all_by_id(47473)
  end

  def test_random_method_returns_one_instance
    result = @repo.random
    assert_equal Item, result.class
  end

  def test_all_method_returns_all_instances
    result = @repo.all
    assert_equal 3, result.size
  end

  def test_find_returns_nil_if_no_match
    assert_nil @repo.find_by_name("no name")
  end

  def test_find_all_returns_empty_array_if_no_match
    assert_equal [], @repo.find_all_by_name("no name")
  end
  
  def test_inspect_returns_string
    assert_equal String, @repo.inspect.class
  end
end
