module Legebiltzarra
  class Topic
    BASE_URL = "http://www.parlamento.euskadi.net"
    attr_accessor :url, :size, :name
    PAGE_SIZE = 50

    def initiatives
      initiatives = Array.new
      current = 1
      while current <= self.size.to_i
        initiatives += paginated_initiatives(current)
        current += PAGE_SIZE
      end
      initiatives
    end
    
    protected 
    
      def paginated_initiatives(from)
        begin
          #"Initiative.new( p.content.match(/[0-9\\]+/)[0] )"
          ini_url = "#{BASE_URL}#{self.url}&M=#{from}&R=Y"
          ini_list ||= Nokogiri::HTML(open(ini_url).read)
          ini_list.search('table[@class="tablaBD"]/tr[@class="tabla_SUM"]/td[@class="tabla_SUM_member"]').map{ |p| Initiative.new(p.content.match(/[0-9\\]+/)[0]) if p.content.size > 5 }.compact!
        rescue 
          []
        end        
      end
  end
end