require_relative 'test_helper'
require_relative '../lib/sales_engine'
require_relative '../lib/transaction'
require 'time'

class TransactionTest < Minitest::Test

  def test_transaction_attribute_matches
    data = {
      id:                          1,
      invoice_id:                  1,
      credit_card_number:          4654405418249632,
      credit_card_expiration_date: "",
      result:                      "success",
      created_at:                  Time.parse("2012-03-27 14:54:09 UTC"),
      updated_at:                  Time.parse("2012-03-27 14:54:09 UTC")
    }
    transaction = Transaction.new(data, nil)
    assert_equal 1, transaction.id
    assert_equal 1, transaction.invoice_id
    assert_equal 4654405418249632, transaction.credit_card_number
    assert_equal "", transaction.credit_card_expiration_date
    assert_equal 'success', transaction.result
    assert_equal Time.parse('2012-03-27 14:54:09 UTC'), transaction.created_at
    assert_equal Time.parse('2012-03-27 14:54:09 UTC'), transaction.updated_at
  end

  def setup
    @engine = SalesEngine.new("test/data")
    @engine.startup
    @repo = @engine.transaction_repository
    @transaction = @repo.instances.first
  end

  def test_transaction_invoice_returns_proper_invoice
    assert_equal @transaction.invoice_id, @transaction.invoice.id
  end

  def test_transaction_invoice_returns_nil_if_no_invoice
    data = {
      id:                          "-1",
      invoice_id:                  "-1",
      credit_card_number:          "4654477418249632",
      credit_card_expiration_date: "",
      result:                      "success",
      created_at:                  "2012-03-27 14:54:09 UTC",
      updated_at:                  "2012-03-27 14:54:09 UTC"
    }
    bad_transaction = Transaction.new(data, @repo)
    assert_equal nil, bad_transaction.invoice
  end
end
