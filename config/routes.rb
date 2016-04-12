Rails.application.routes.draw do
  post 'words/avg_len' => 'words#avg_len', :defaults => { :format => 'json' }
  post 'words/most_com' => 'words#most_com', :defaults => { :format => 'json' }
  post 'words/median' => 'words#median', :defaults => { :format => 'json' }
  post 'sentences/avg_len' => 'sentences#avg_len', :defaults => { :format => 'json' }
  post 'phones' => 'phones#find_numbers', :defaults => { :format => 'json' }
end
