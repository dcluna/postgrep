require 'test/unit'
require 'dm-core'
require 'postgrep'

class Article
  include DataMapper::Resource
  include Postgrep::Searchable

  property :id, Serial
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
    assert Article.search 'postgrep'
  end

  def test_search_with_options
    assert Article.search 'spider-man', {:author => 'J. Jameson'}
  end

  def test_migrations
    assert_equal String, Postgrep::Migrations[0].class
    assert_equal 1, Postgrep::Migrations.length
  end
end
