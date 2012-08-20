#!/usr/bin/env jruby

require 'rubygems'
require 'torquebox-messaging'

queue = TorqueBox::Messaging::Queue.new(
  '/queues/trade/prod_ord',
  host: 'localhost',
  port: 5445
)

group_id = 1
count = 0
10.times.each do |batch|
  3.times.each do |index|
    count += 1
    side = count % 2 == 0 ? 'buy' : 'sell'
    message = { type: 'new_orders', side: side, price: 0.50, quantity: 100 }
    queue.publish message,
      properties: { 'JMSXGroupID' => "#{group_id}", '_HQ_GROUP_ID' => "#{group_id}" }
  end
end
