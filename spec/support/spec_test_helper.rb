module SpecHelper
    
    def is_logged_in?
        !session[:user_id].nil?
    end
    
    def log_in_as(user)
        session[:user_id] = user.id
    end
    
    def log_in_as(user, password:"password", remember_me: "1")
        post login_path, params: { session: { email: user.email ,
                                        password: user.password,
                                        remember_me: remember_me }}
    end
    def follow(other_user)
        self.active_relationships.create(followed_id: other_user.id)
    end
  
    def unfollow(other_user)
        active_relationships.find_by(followed_id: other_user.id).destroy
    end

    def following?(other_user)
        following.include?(other_user)
    end
end
