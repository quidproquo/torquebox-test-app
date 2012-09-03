#!/usr/bin/env jruby

require 'rubygems'
require 'torquebox-messaging'
require "./lib/messaging/order_messager"

class MyOrderMessager
  include OrderMessager
end

messager = MyOrderMessager.new
messager.acc_pos_queue = TorqueBox::Messaging::Queue.new(
  '/queues/trade/acc_pos',
  host: 'localhost',
  port: 5445
)

orders = []
count = 0
2.times.each do |batch|
  3.times.each do |index|
    count += 1
    side = count % 2 == 0 ? 'buy' : 'sell'
    account_id = (count % 2) + 1
    orders << Order.new(
      account_id: account_id,
      product_id: 1,
      order_type: 'L',
      side: side,
      price: 0.50,
      quantity: 100
    )
  end
end

messager.send_sent_orders(orders)
