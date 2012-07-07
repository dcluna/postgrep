module Postgrep
  class Migrations    
    class << self
      def add(searchable)
        @migrations ||= []
        @migrations << Migration.new(searchable)
      end

      def [](index)
        @migrations[index]
      end

      def length
        @migrations.length
      end
    end    
  end
  
  class Migration
    attr_accessor :up, :down
    
    def initialize(searchable, dict=:english)
      @up, @down = String.new, String.new
      @up << searchable.search_indexes.each do |index|
        up_sql searchable.table_name, index, dict
      end
      @down << searchable.search_indexes.each do |index|
        down_sql searchable.table_name, index
      end
    end
    
    private
    def up_sql(table_name,index,dict)
      ["ALTER TABLE #{table_name} ADD COLUMN #{index}_search_index tsvector;",
       "UPDATE #{table_name} SET #{index}_search_index = to_tsvector(#{dict}, coalesce(#{index},''));",
       "CREATE TRIGGER #{index}_index_update BEFORE INSERT OR UPDATE ON #{table_name} FOR EACH ROW EXECUTE PROCEDURE tsvecotr_update_trigger(#{index}_search_index, 'pg_catalog.#{dict}',#{index})"].join "\n"
    end

    def down_sql(table_name,index)
      ["ALTER TABLE #{table_name} DROP COLUMN #{index}_search_index",
       "DROP TRIGGER #{index}_index_update"].join "\n"
    end
  end
end
