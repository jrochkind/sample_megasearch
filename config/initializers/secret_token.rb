# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
SampleMegasearch::Application.config.secret_token = '9f0bc51b53be7f6ec0919b47a1038322caef0b4117e910c2fe5ee24755e374634965cc73edae2a47c8ee0f487dfdaeddbdeef4b318dc853fef31a8eca5c8b90b'

# Using a seperate secret token for our refworks callback encryption,
# so if it gets compromised, it won't compromise our main secret token. 
# This hex secret can be, and was, generated with `rake secret` in a rails app.
#
# In an actual production app, you would need to keep all these secret
# tokens OUT of a public repo, and different local implementations of
# the app would need different secret tokens! 
SampleMegasearch::Application.config.refworks_callback_secret_token = 'dae6a8c7bca0ab87fa44ad36dd5e74821adae2a862fbe9b298361ef99a41033911ad6b263cc75809972464bb40e3569e9f6b117255a6075adc07827c74273a4c'
