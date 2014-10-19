require_relative 'test_helper.rb'
require_relative '../lib/invoice_repository'
require 'bigdecimal'
require 'bigdecimal/util'
require 'time'

class InvoiceRepositoryTest < Minitest::Test
  def setup
    data1 = {
      id:           1,
      customer_id:  2,
      merchant_id:  3,
      status:       'shipped',
      created_at:   Time.parse('2012-03-27 14:53:59 UTC'),
      updated_at:   Time.parse('2012-03-27 14:53:59 UTC')
    }
    data2 = {
      id:           2,
      customer_id:  2,
      merchant_id:  3,
      status:       'shipped',
      created_at:   Time.parse('2012-03-27 14:54:59 UTC'),
      updated_at:   Time.parse('2012-03-27 14:54:59 UTC')
    }
    data = [data1, data2]
    @repo = InvoiceRepository.new(data, nil)
  end

  def test_find_by_id
    assert_equal 1, @repo.find_by_id("1").id
  end

  def test_find_by_customer_id
    assert_equal 1, @repo.find_by_customer_id("2").id
  end

  def test_find_by_merchant_id
    assert_equal 1, @repo.find_by_merchant_id("3").id
  end

  def test_find_by_status
    assert_equal 1, @repo.find_by_status("shipped").id
  end

  def test_find_by_created_at
    assert_equal 1, @repo.find_by_created_at("2012-03-27 14:53:59 UTC").id
  end

  def def_find_by_updated_at
    assert_equal 1, @repo.find_by_updated_at("2012-03-27 14:53:59 UTC").id
  end

  def test_find_returns_nil_if_no_match
    assert_nil @repo.find_by_id("99")
  end

  def test_find_all_by_id
    result = @repo.find_all_by_id("1")
    assert_equal 1, result.size
  end

  def test_find_all_by_customer_id
    result = @repo.find_all_by_customer_id("2")
    assert_equal 2, result.size
  end

  def test_find_all_by_merchant_id
    result = @repo.find_all_by_merchant_id("3")
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
    assert_equal [], @repo.find_all_by_id("99")
  end

  def test_find_all_returns_empty_array_if_no_match
    assert_equal [], @repo.find_all_by_id("99")
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
