Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '127.0.0.1:3000', 'localhost:3000'

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      headers: :any,
      credentials: true
  end
end
