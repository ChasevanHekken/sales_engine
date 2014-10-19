require_relative 'test_helper.rb'
require_relative '../lib/customer_repository'
require 'time'

class CustomerRepositoryTest < Minitest::Test
  def setup
    data1 = {
      id:         1,
      first_name: "john",
      last_name:  "smith",
      created_at: Time.parse("2012-03-27 14:54:09 UTC"),
      updated_at: Time.parse("2012-03-27 14:54:09 UTC")
    }
    data2 = {
      id:         2,
      first_name: "paul",
      last_name:  "jones",
      created_at: Time.parse("2012-03-27 14:54:09 UTC"),
      updated_at: Time.parse("2012-03-27 14:54:09 UTC")
    }
    data = [data1, data2]
    @repo = CustomerRepository.new(data, nil)
  end

  def test_find_by_id
    assert_equal 1, @repo.find_by_id("1").id
  end

  def test_find_by_first_name
    assert_equal 1, @repo.find_by_first_name("john").id
  end

  def test_find_by_last_name
    assert_equal 1, @repo.find_by_last_name("smith").id
  end

  def test_find_by_created_at
    assert_equal 1, @repo.find_by_created_at("2012-03-27 14:54:09 UTC").id
  end

  def def_find_by_updated_at
    assert_equal 1, @repo.find_by_updated_at("2012-03-27 14:54:09 UTC").id
  end

  def test_find_returns_nil_if_no_match
    assert_nil @repo.find_by_id("99")
  end

  def test_find_all_by_id
    result = @repo.find_all_by_id("1")
    assert_equal 1, result.size
  end

  def test_find_all_by_first_name
    result = @repo.find_all_by_first_name("john")
    assert_equal 1, result.size
  end

  def test_find_all_by_last_name
    result = @repo.find_all_by_last_name("smith")
    assert_equal 1, result.size
  end

  def test_find_all_by_created_at
    result = @repo.find_all_by_created_at("2012-03-27 14:54:09 UTC")
    assert_equal 2, result.size
  end

  def def_find_all_by_updated_at
    result = @repo.find_all_by_updated_at("2012-03-27 14:54:09 UTC")
    assert_equal 2, result.size
  end

  def test_find_all_returns_empty_array_if_no_match
    assert_equal [], @repo.find_all_by_id("99")
  end

  def test_find_all_returns_empty_array_if_no_match
    assert_equal [], @repo.find_all_by_id("99")
  end

  def test_random_method_returns_one_instance
    assert_equal Customer, @repo.random.class
  end

  def test_all_method_returns_all_instances
    result = @repo.all
    assert_equal 2, result.size
  end

  def test_inspect_returns_string
    assert_equal String, @repo.inspect.class
  end
end
