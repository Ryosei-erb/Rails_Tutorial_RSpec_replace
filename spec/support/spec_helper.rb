module SpecHelper
    
    def is_logged_in?
        !session[:user_id].nil?
    end
end
