require_relative 'test_helper.rb'
require_relative '../lib/merchant_repository'
require 'bigdecimal'
require 'bigdecimal/util'
require 'time'

class MerchantRepositoryTest < Minitest::Test
  def setup
    data1 = {
      id:           1,
      name:         "Schroeder-Jerde",
      created_at:   Time.parse("2013-06-09 21:34:12 UTC"),
      updated_at:   Time.parse("2013-06-09 21:34:12 UTC")
    }

    data2 = {
      id:           2,
      name:         "Billy Bob",
      created_at:   Time.parse("2013-06-09 21:34:12 UTC"),
      updated_at:   Time.parse("2013-06-09 21:34:12 UTC")
    }
    data = [data1, data2]
    @repo = MerchantRepository.new(data, nil)
  end

  def test_find_by_id
    assert_equal 1, @repo.find_by_id("1").id
  end

  def test_find_by_name_id1
    assert_equal 1, @repo.find_by_name("Schroeder-Jerde").id
  end

  def test_find_by_name_id2
    assert_equal 2, @repo.find_by_name("Billy Bob").id
  end

  def test_find_by_created_at
    assert_equal 1, @repo.find_by_created_at("2013-06-09 21:34:12 UTC").id
  end

  def test_def_find_by_updated_at
    assert_equal 1, @repo.find_by_updated_at("2013-06-09 21:34:12 UTC").id
  end

  def test_find_returns_nil_if_no_match
    assert_nil @repo.find_by_id("23")
  end

  def test_find_all_by_id
    result = @repo.find_all_by_id("2")
    assert_equal 1, result.size
  end

  def test_find_all_by_name
    result = @repo.find_all_by_name("Billy Bob")
    assert_equal 1, result.size
  end

  def test_find_all_by_name
    result = @repo.find_all_by_name("Schroeder-Jerde")
    assert_equal 1, result.size
  end

  def test_find_all_by_created_at
    result = @repo.find_all_by_created_at("2013-06-09 21:34:12 UTC")
    assert_equal 2, result.size
  end

  def test_def_find_all_by_updated_at
    result = @repo.find_all_by_updated_at("2013-06-09 21:34:12 UTC")
    assert_equal 2, result.size
  end

  def test_find_all_returns_empty_array_if_no_match
    assert_equal [], @repo.find_all_by_id("74")
  end

  def test_find_all_returns_empty_array_if_no_match
    assert_equal [], @repo.find_all_by_id("32")
  end

  def test_random_method_returns_one_instance
    result = @repo.random
  end

  def test_all_method_returns_all_instances
    result = @repo.all
    assert_equal 2, result.size
  end

  def test_inspect_returns_string
    assert_equal String, @repo.inspect.class
  end
end
