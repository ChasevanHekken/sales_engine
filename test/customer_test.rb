require_relative 'test_helper.rb'
require_relative '../lib/sales_engine'
require_relative '../lib/customer'
require 'time'

class CustomerTest < Minitest::Test
  def test_customer_attribute_matches
    data = {
      id:         1,
      first_name: "john",
      last_name:  "smith",
      created_at: Time.parse('2012-03-27 14:54:09 UTC'),
      updated_at: Time.parse('2012-03-27 14:54:09 UTC')
    }
    customer = Customer.new(data, nil)
    assert_equal 1, customer.id
    assert_equal "john", customer.first_name
    assert_equal "smith", customer.last_name
    assert_equal Time.parse('2012-03-27 14:54:09 UTC'), customer.created_at
    assert_equal Time.parse('2012-03-27 14:54:09 UTC'), customer.updated_at
  end

  def setup
    @engine = SalesEngine.new("data")
    @engine.startup
    @repo = @engine.customer_repository
    @customer = @repo.instances.first
  end

  def test_invoices_returns_collection_of_associated_invoices
    assert_equal @customer.id, @customer.invoices.first.customer_id
  end

  def test_customer_invoices_returns_empty_array_if_no_invoices
    data = {
      id: '99',
      first_name: 'al',
      last_name:  'k',
      created_at: '2012-03-27 14:54:09 UTC',
      updated_at: '2012-03-27 14:54:09 UTC'
    }
    bad_customer = Customer.new(data, @repo)
    assert_equal [], bad_customer.invoices
  end
end
