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
    attr_reader :description
    
    def initialize(searchable, description=nil, dict=:english)
      @up, @down = String.new, String.new
      unless searchable.search_indexes.empty?
        @up << searchable.search_indexes.each do |index|
          up_sql searchable.storage_name, index, dict
        end.join("\n")
        @down << searchable.search_indexes.each do |index|
          down_sql searchable.storage_name, index
        end.join("\n")
      end
      @description = description
    end

    def empty?
      @up.empty? && @down.empty?
    end

    def define_migration(number, name)
      raise EmptyMigration if empty?
      migration number, name do
        up do
          DataMapper.repository.adapter.execute @up
        end
        down do
          DataMapper.repository.adapter.execute @up
        end
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
