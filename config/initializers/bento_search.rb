require 'bento_search/openurl_main_link'

# Global variables with key names of registered engines the 
# SearchController will use to search. Modify this list if you
# don't have credentials for some services, or want to use different
# services. These global vars aren't part of the bento_search gem, just
# something this sample app does. 
$foreground_engines = %w{primo eds ebscohost summon scopus}
$background_engines = %w{gbs}
$triggered_engines = %w{google_site}



# Note all the relevant auth details for each service 
# are taken from env variables, and will blank for you. 
# Set them to your own auth credentials, or don't use the engine. 

# Note also we've provided decorators to our own OpenURL link resolver,
# you probably want to change to yours, or remove the decorators. 

BentoSearch.register_engine("gbs") do |conf|
   conf.engine = "BentoSearch::GoogleBooksEngine"
   conf.api_key = ENV["GBS_API_KEY"]
   
   # allow ajax load. 
   conf.allow_routable_results = true
   
   # ajax loaded results with our wrapper template
   # with total number of hits, link to full results, etc. 
   conf.for_display do |display|
     display[:ajax] = {"wrapper_template" => "layouts/bento_box_wrapper"}
   end
end

BentoSearch.register_engine("google_site") do |conf|
   conf.engine = "BentoSearch::GoogleSiteSearchEngine"
   conf.api_key = ENV["GOOGLE_SITE_SEARCH_KEY"]
   conf.cx      = ENV["GOOGLE_SITE_SEARCH_CX"]
   
   # allow ajax load. 
   conf.allow_routable_results = true
   
   # ajax loaded results with our wrapper template
   # with total number of hits, link to full results, etc. 
   conf.for_display do |display|
     display[:ajax] = {"wrapper_template" => "layouts/bento_box_wrapper"}
   end
end

BentoSearch.register_engine("worldcat") do |conf|
  conf.engine = "BentoSearch::WorldcatSruDcEngine"
  
  conf.api_key = ENV["WORLDCAT_API_KEY"]
  # assume all users are affiliates and have servicelevel=full access. 
  conf.auth = true
end

# JH only, hacky demo of Xerxes/Metalib, does not work well, and
# please don't point at our Xerxes install. 
BentoSearch.register_engine("jhsearch") do |conf|
  conf.engine = "BentoSearch::XerxesEngine"
  conf.base_url = "http://jhsearch.library.jhu.edu"
  conf.databases = ['JHU04066', 'JHU06614']
  
  conf.allow_routable_results = true
  
  conf.ajax_load = true
end

BentoSearch.register_engine("scopus") do |conf|
  conf.engine = "BentoSearch::ScopusEngine"
  conf.api_key = ENV["SCOPUS_KEY"]
  
  conf.item_decorators = [ 
    BentoSearch::OpenurlMainLink[:base_url => "http://findit.library.jhu.edu/resolve", :extra_query => "&umlaut.skip_resolve_menu_for_type=fulltext"] ,
    BentoSearch::OpenurlAddOtherLink[:base_url => "http://findit.library.jhu.edu/resolve", :link_name => "Find It @ JH"]    
  ]  
end

BentoSearch.register_engine("summon") do |conf|
  conf.engine     = "BentoSearch::SummonEngine"
  conf.access_id  = ENV["SUMMON_ACCESS_ID"]
  conf.secret_key = ENV["SUMMON_SECRET_KEY"]
  
  conf.lang       = "en"
  

  conf.fixed_params = {
    # These pre-limit the search to avoid certain content-types, you may or may
    # not want to do. 
    "s.cmd" => ["addFacetValueFilters(ContentType,Web Resource:true,Reference:true,eBook:true,Book Chapter:true,Newspaper Article:true,Trade Publication Article:true,Journal:true,Transcript:true,Research Guide:true)"],
    #"s.fvf[]" => ["ContentType,Reference,true"],
    
    
    # because our entire demo app is behind auth, we can hard-code that
    # all users are authenticated. 
    "s.role" => "authenticated"
  } 
  
  # Barnaby, for your purposes you probably do NOT wnat the conf.item_decorators,
  # just use the built-in Summon link. Or you could use the AddOtherLink one to
  # add a link to your link resolver, but leave the MainLink one off, to just
  # use Summon's ordinary link on title for main link. 
  conf.item_decorators = [ 
    BentoSearch::OpenurlMainLink[:base_url => "http://findit.library.jhu.edu/resolve", :extra_query => "&umlaut.skip_resolve_menu_for_type=fulltext"] ,
    BentoSearch::OpenurlAddOtherLink[:base_url => "http://findit.library.jhu.edu/resolve", :link_name => "Find It @ JH"]    
  ]  

end

require "#{Rails.root}/config/ebsco_dbs.rb"

BentoSearch.register_engine("ebscohost") do |conf|
  
  conf.engine       = "BentoSearch::EbscoHostEngine"
  
  conf.profile_id         = ENV['EBSCOHOST_PROFILE']
  conf.profile_password   = ENV['EBSCOHOST_PWD']
  conf.databases          = $ebsco_dbs

  #conf.databases          = %w{a9h awn 
  #ofm eft gft bft asf aft ijh hft air flh geh ssf hgh rih cja 22h 20h fmh rph jph}
  
  conf.item_decorators = [ 
    BentoSearch::Ebscohost::ConditionalOpenurlMainLink[:base_url => "http://findit.library.jhu.edu/resolve", :extra_query => "&umlaut.skip_resolve_menu_for_type=fulltext"] ,
    BentoSearch::OpenurlAddOtherLink[:base_url => "http://findit.library.jhu.edu/resolve", :link_name => "Find It @ JH"]    
  ]  
end

#BentoSearch.register_engine("eds_old_api") do |conf|
#  conf.engine = "BentoSearch::EbscoHostEngine"
  
#  conf.profile_id =   ENV['EDS_PROFILE']
#  conf.profile_password = ENV['EBSCOHOST_PWD']
  
#end

BentoSearch.register_engine("eds") do |conf|
  conf.engine = "BentoSearch::EdsEngine"
  
  conf.user_id = 's3555202'
  conf.password = 'password'
  conf.profile = 'edsapi'
  
  # If our app protects all access to any eds search functions to registered
  # users, we can just tell the engine to assume end user auth. 
  conf.auth = true
  
  conf.item_decorators = [ 
    BentoSearch::OnlyPremadeOpenurl, 
    BentoSearch::OpenurlMainLink[:base_url => "http://findit.library.jhu.edu/resolve", :extra_query => "&umlaut.skip_resolve_menu_for_type=fulltext"] ,
    BentoSearch::OpenurlAddOtherLink[:overwrite => true, :base_url => "http://findit.library.jhu.edu/resolve", :link_name => "Find It @ JH"]    
  ]    
  
  # http://support.ebsco.com/knowledge_base/detail.php?id=5382
  conf.only_source_types = [
    "Academic Journals",
    "Magazines",
    "Reviews",
    "Reports",
    "Conference Materials",
    "Dissertations",
    "Biographies",
    "Primary Source Documents",
    "Music Scores"    
  ]
end




BentoSearch.register_engine("primo") do |conf|
  conf.engine       = "BentoSearch::PrimoEngine"
  
  conf.host_port    = ENV['PRIMO_HOST_PORT']
  conf.institution  = ENV['PRIMO_INSTITUTION']
  
  # We're protecting access to auth users outside
  # ourselves, so we tell it assume auth
  conf.auth         = true  
  
  # exclude certain content-types. unclear if we should use
  # rtype or pfilter facet. 
  conf.fixed_params = {
    "query_exc" => "facet_pfilter,exact,books,newspaper_articles,websites,reference_entrys,images,media,audio_video,rare_books,book_chapters"
  }
  
  conf.item_decorators = [ 
    BentoSearch::OpenurlMainLink[:base_url => "http://findit.library.jhu.edu/resolve", :extra_query => "&umlaut.skip_resolve_menu_for_type=fulltext"] ,
    BentoSearch::OpenurlAddOtherLink[:base_url => "http://findit.library.jhu.edu/resolve", :link_name => "Find It @ JH"]    
  ]  
end

  
