class ApplicationController < ActionController::Base
  protect_from_forgery
  
  # We generate refworks callback URLs to single records, encrypting
  # the record ID to prevent mass downloading of known IDs. Here
  # are our routines to encrypt/decrypt, using a key set as
  # config.refworks_callback_secret_token in config/initializers/secret_token.rb
  #
  # The encrypt one we make a helper method, so that views can generate. 
  
  def encrypt_bento_id(id)
    encrypter = ActiveSupport::MessageEncryptor.new( SampleMegasearch::Application.config.refworks_callback_secret_token )
    return encrypter.encrypt_and_sign(id)
  end
  helper_method :encrypt_bento_id
  
  def decrypt_bento_id(encrypted_id)
    encrypter = ActiveSupport::MessageEncryptor.new( SampleMegasearch::Application.config.refworks_callback_secret_token )
    return encrypter.decrypt_and_verify(encrypted_id)
  end
  
  
end
