TorqueBox.configure do

  # DSL calls go here

  web do
    context '/'
  end

  ruby do
    version '1.9'
  end

  queue '/queues/trade/prod_ord' do
    create true
    processor ProdOrdMessageProcessor, concurrency: 4
  end

  queue '/queues/trade/acc_pos' do
    create true
    processor AccPosMessageProcessor, concurrency: 4
  end

end
