Spree::Core::Engine.routes.draw do
  match 'robokassa/:action',
    via: [:get, :post],
    controller: 'robokassa',
    constraints: { action: /result|success|failure/ }
end
