class MonthlyLineItem
  include ActionView::Helpers::NumberHelper

  vattr_initialize :subscription

  def title
    case @subscription.plan.name
    when "Personal"
      "Private Personal Repos"
    when "Private"
      "Private Repos"
    when "Organization"
      "Private Org Repos"
    else
      @subscription.plan.name
    end
  end

  def base_price
    "#{number_to_currency(amount_in_dollars, precision: 0)}/mo."
  end

  def quantity
    "x#{@subscription.quantity}"
  end

  def subtotal
    number_to_currency(subtotal_in_dollars, precision: 0)
  end

  def subtotal_in_dollars
    @subscription.quantity * amount_in_dollars
  end

  private

  def amount_in_dollars
    amount = (@subscription.plan.amount - discounted_amount) / 100
    amount * discounted_percent_multiplier
  end

  def discounted_percent_multiplier
    1.0 - (discounted_percent / 100)
  end

  def discounted_amount
    coupon.amount_off || 0
  end

  def discounted_percent
    (coupon.percent_off || 0).to_f
  end

  def discount
    @subscription.discount || PaymentGatewayCustomer::NullDiscount.new
  end

  def coupon
    if discount.coupon.valid
      discount.coupon
    else
      PaymentGatewayCustomer::NullCoupon.new
    end
  end
end
