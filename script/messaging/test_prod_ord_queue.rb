#!/usr/bin/env jruby

require 'rubygems'
require 'torquebox-messaging'

queue = TorqueBox::Messaging::Queue.new(
  '/queues/trade/prod_ord',
  host: 'localhost',
  port: 5445
)

10.times.each do |group_id|
  3.times.each do |index|
    queue.publish "Message index: #{index} group: #{group_id}",
      properties: { 'JMSXGroupID' => "#{group_id}", '_HQ_GROUP_ID' => "#{group_id}" }
  end
end
