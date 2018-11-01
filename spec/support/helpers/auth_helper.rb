def sign_in(user, password)
  post user_session_path, params: { email: user.email, password: password }
  get_auth_headers response.headers
end

def sign_out
  #consider actually sign_out
end

private

def get_auth_headers headers
  headers.select {|k,v|
    [
      "access-token",
      "client",
      #"token-type",
      "uid"
    ].include?(k) }
end
