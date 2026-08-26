class CreateOrder
  class Error < StandardError; end

  def self.call(user:, attributes:)
    new(user: user, attributes: attributes).call
  end

  def initialize(user:, attributes:)
    @user = user
    @attributes = attributes.to_h.with_indifferent_access
  end

  def call
    items = Array(@attributes[:items])
    raise Error, "Order must include at least one item" if items.empty?

    Order.transaction do
      order = @user.orders.create!(
        email: @attributes[:email].presence || @user.email,
        customer_name: @attributes[:customer_name].presence || @user.name,
        shipping_address: @attributes[:shipping_address]
      )

      items.each do |line|
        line = line.to_h.with_indifferent_access
        variant = Variant.lock.find(line.fetch(:variant_id))
        quantity = line.fetch(:quantity).to_i

        raise Error, "#{variant.sku} does not have enough stock" if variant.stock < quantity

        order.order_items.create!(variant: variant, quantity: quantity)
        variant.decrement!(:stock, quantity)
      end

      order.update!(total: order.order_items.sum(&:line_total))
      order
    end
  end
end
