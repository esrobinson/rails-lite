module CSRF
  def generate_csrf_token(session, secret)
    (session.hash + secret.hash).hash
  end

  def compare_csrf_token(session, secret, token)
    token == generate_csrf_token(session, secret)
  end
end