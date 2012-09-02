#!/usr/bin/env jruby

require 'rubygems'
require 'torquebox-messaging'

queue = TorqueBox::Messaging::Queue.new(
  '/queues/trade/acc_pos',
  host: 'localhost',
  port: 5445
)

group_id = 1
count = 0
2.times.each do |batch|
  3.times.each do |index|
    count += 1
    side = count % 2 == 0 ? 'buy' : 'sell'
    account_id = (count % 2) + 1
    message = {type: 'sent', orders: [{account_id: account_id, product_id: 1, order_type: 'L', side: side, price: 0.50, quantity: 100}]}
    queue.publish message,
      properties: { 'JMSXGroupID' => "#{account_id}", '_HQ_GROUP_ID' => "#{account_id}" }
  end
end
