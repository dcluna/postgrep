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
    DataMapper.setup(:default, "postgres://test:test@localhost/text_search_demo")
    DataMapper.finalize
  end

  def test_basic_search
    assert Article.search 'postgrep'
  end
  
  def test_search_with_options
    assert Article.search 'spider-man', {:author => 'J. Jameson'}
  end

  def test_migrations
    assert_equal [:text, :description], Article.search_indexes
    Postgrep::Migrations.add Article
    assert_equal 1, Postgrep::Migrations.length
    assert !Postgrep::Migrations[0].empty?
    assert !Postgrep::Migrations[0].up.empty?
    assert !Postgrep::Migrations[0].down.empty?
  end
end
