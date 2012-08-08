A demo/sample Rails application using functionality from 
[bento_search](http://github.com/jrochkind/bento_search)

This is neither supported nor maintained nor suggested for production use, 
it is simply sample/demo code. 

To run it yourself, you'll want to look at `config/initializers/bento_search.rb`
to customize the bento_search engines being used: Their auth credentials, 
their other configuration, which engines are included in the list. You'll
want to change their item decorators, as they currently have decorators
set up to change links to jrochkind's institutional link resolver, you'll
want to remove or change those. It's all in the initializer. 
