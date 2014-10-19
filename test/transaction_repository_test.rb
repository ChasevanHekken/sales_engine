require_relative 'test_helper.rb'
require_relative '../lib/transaction_repository'
require 'time'

class TransactionRepositoryTest < Minitest::Test
  def setup
    data1 = {
      id:                          1,
      invoice_id:                  1,
      credit_card_number:          4654405418249632,
      credit_card_expiration_date: "",
      result:                      "success",
      created_at:                  Time.parse("2012-03-27 14:54:09 UTC"),
      updated_at:                  Time.parse("2012-03-27 14:54:09 UTC")
    }
    data2 = {
      id:                          2,
      invoice_id:                  1,
      credit_card_number:          4654405418249632,
      credit_card_expiration_date: "",
      result:                      "success",
      created_at:                  Time.parse("2012-03-27 14:53:09 UTC"),
      updated_at:                  Time.parse("2012-03-27 14:53:09 UTC")
    }
    data = [data1, data2]
    @repo = TransactionRepository.new(data, nil)
  end

  def test_find_by_id
    assert_equal 1, @repo.find_by_id("1").id
  end

  def test_find_by_invoice_id
    assert_equal 1, @repo.find_by_invoice_id("1").id
  end

  def test_find_by_credit_card_number
    assert_equal 1, @repo.find_by_credit_card_number("4654405418249632").id
  end

  def test_find_by_credit_card_expiration_date
    assert_equal 1, @repo.find_by_credit_card_expiration_date("").id
  end

  def test_find_by_created_at
    assert_equal 1, @repo.find_by_created_at(Time.parse("2012-03-27 14:54:09 UTC")).id
  end

  def def_find_by_updated_at
    assert_equal 1, @repo.find_by_updated_at(Time.parse("2012-03-27 14:54:09 UTC")).id
  end

  def test_find_returns_nil_if_no_match
    assert_nil @repo.find_by_id("99")
  end

  def test_find_all_by_id
    match = @repo.find_all_by_id("1")
    assert_equal 1, match.size
  end

  def test_find_all_by_invoice_id
    match = @repo.find_all_by_invoice_id("1")
    assert_equal 2, match.size
  end

  def test_find_all_by_credit_card_number
    match = @repo.find_all_by_credit_card_number("4654405418249632")
    assert_equal 2, match.size
  end

  def test_find_all_by_credit_card_expiration
    match = @repo.find_all_by_credit_card_expiration_date("")
    assert_equal 2, match.size
  end

  def test_find_all_by_result
    match = @repo.find_all_by_result("success")
    assert_equal 2, match.size
  end

  def test_find_all_by_created_at
    match = @repo.find_all_by_created_at(Time.parse("2012-03-27 14:54:09 UTC"))
    assert_equal 1, match.size
  end

  def test_find_all_by_updated_at
    match = @repo.find_all_by_updated_at(Time.parse("2012-03-27 14:54:09 UTC"))
    assert_equal 1, match.size
  end

  def test_find_all_returns_empty_array_if_no_match
    assert_equal [], @repo.find_all_by_result("hello")
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
