module ActionController
  module Routing #:nodoc:
    class RouteSet #:nodoc:
      alias_method :draw_without_fluorida_routes, :draw
      def draw
        draw_without_fluorida_routes do |map|
          map.connect 'fluorida/report',
            :controller => 'fluorida', :action => 'report'
          map.connect 'fluorida/open',
            :controller => 'fluorida', :action => 'open'
          map.connect 'fluorida/*filename',
            :controller => 'fluorida', :action => 'load_file'
          
          yield map
        end
      end
    end
  end
end
