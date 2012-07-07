module Postgrep
  module Searchable
    def self.included(model)
      model.send(:extend, ClassMethods)
    end
    
    module ClassMethods
      attr_accessor :search_indexes
      search_indexes = []
      
      def conditions(query)
        conds = search_indexes.map{|idx| "#{idx}_search_index @@ plainto_tsquery(?)" }
        conds_array = [conds.join(" OR ")]
        search_indexes.size.times{ conds_array << escape_string(query) }
        conds_array
      end
      
      def search(query, options = {}, *limit)
        conds_array = conditions query
        results = all(options.merge(:conditions => conds_array))
        case limit.length
        when 0
          results
        when 1
          results[limit[0]]
        else
          results[limit[0],limit[1]]
        end
      end
      
      private      
      def escape_string(str)
        str.gsub(/([\0\n\r\032\'\"\\])/) do
          case $1
          when "\0" then "\\0"
          when "\n" then "\\n"
          when "\r" then "\\r"
          when "\032" then "\\Z"
          when "'"  then "''"
          else "\\"+$1
          end
        end
      end
    end
  end
end
