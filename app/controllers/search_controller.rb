class SearchController < ApplicationController
  @@foreground_engines = $foreground_engines || []
  @@ajax_bg_engines = $background_engines || []
  @@ajax_triggered_engines = $triggered_engines || []
  
  @@per_page = 10
  def index
    if params[:q]
      searcher = BentoSearch::MultiSearcher.new(*@@foreground_engines)
      searcher.start(params[:q], :per_page => @@per_page, :semantic_search_field => params[:field])
      
      @results = searcher.results
      @ajax_bg_engines = @@ajax_bg_engines
      @ajax_triggered_engines = @@ajax_triggered_engines
    end    
  end
  
  def single_search
    begin
      @engine = BentoSearch.get_engine(params[:engine])
    rescue BentoSearch::NoSuchEngine => e    
      render :status => 404, :text => e.message
      return
    end
    
    if params[:q]
      args = {}
      args[:query] = params[:q]
      args[:page] = params[:page]
      args[:semantic_search_field] = params[:field]
      args[:per_page] = 10
      args[:sort] = params[:sort]
      args[:per_page] = params[:per_page]
      
      @results = @engine.search(params[:q], args)
    end
  end
  
  # Action used in URLs given to refworks as callback for single
  # item exports. 
  #
  # Important this URL is _not_ access control protected, so refworks
  # can get in!
  #
  # Some RefWorks export docs at http://www.refworks.com/DirectExport.htm
  def refworks_callback
    begin
      @engine = BentoSearch.get_engine(params[:engine])
    rescue BentoSearch::NoSuchEngine => e    
      render :status => 404, :text => e.message
      return
    end
    
    item = @engine.get(params[:id].to_s)
    unless item    
      render :status => 404
    end
    
    # Decorate with configured decorator, so any custom link manipulation
    # (or other custom decoration) is reflected in RIS export. Or you could
    # write your own logic to use a different decorator for RIS exports
    # than you do for ordinary HTML display; or choose to use no decorator;
    # whatever meets your needs. 
    decorated = BentoSearch::DecoratorBase.decorate(item, self)
    
    # I don't trust refworks to send the right content-type
    # in request, we deliver this for any content type requested.
    render :text => BentoSearch::RISCreator.new(decorated).export, :content_type => "application/x-research-info-systems"
  end
  
end
