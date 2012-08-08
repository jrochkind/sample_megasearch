class SearchController < ApplicationController
  @@foreground_engines = $foreground_engines || []
  @@ajax_engines = $background_engines || []# ["jhsearch"]
  @@per_page = 10
  def index
    if params[:q]
      searcher = BentoSearch::MultiSearcher.new(*@@foreground_engines)
      searcher.start(params[:q], :per_page => @@per_page, :semantic_search_field => params[:field])
      
      @results = searcher.results
      @ajax_engines = @@ajax_engines
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
  
end
