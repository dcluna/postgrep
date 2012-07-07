require 'dm-core'
require 'postgrep'

class Article
  include DataMapper::Resource
  include Postgrep::Searchable

  property :author, String
  property :text, Text
  property :description, Text

  self.search_indexes = [:text, :description]
end
 

class PostgrepTest < Test::Unit::TestCase
  def setup
    DataMapper.setup(:default, "abstract::")
  end

  def test_basic_search
    assert Article.search 'datamapper'
  end
end
