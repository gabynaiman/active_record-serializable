require 'coverage_helper'
require 'minitest/autorun'
require 'minitest/colorin'
require 'minitest/line/describe_track'
require 'pry-nav'
require 'active_record'
require 'active_record-serializable'

module AuthorHelper
  def author
    user.name
  end
end

class User < ActiveRecord::Base
  has_one :avatar
  has_many :posts
  has_and_belongs_to_many :groups

  serializable_define_method :hi do
    "Hi, my name is #{name}"
  end
end

class Avatar < ActiveRecord::Base
  belongs_to :user
end

class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  serializable_include AuthorHelper
end

class Comment < ActiveRecord::Base
  belongs_to :post
end

class Group < ActiveRecord::Base
  has_and_belongs_to_many :users
end

class Minitest::Spec

  def setup
    ActiveRecord::Base.establish_connection adapter: :sqlite3, database: ':memory:'

    ActiveRecord::Schema.define do
      self.verbose = false

      create_table :users do |t|
        t.string :name
      end

      create_table :avatars do |t|
        t.belongs_to :user
        t.string :image_url
      end

      create_table :posts do |t|
        t.belongs_to :user
        t.string :title
        t.string :body
      end

      create_table :comments do |t|
        t.belongs_to :post
        t.string :text
      end

      create_table :groups do |t|
        t.string :name
      end

      create_table :groups_users do |t|
        t.belongs_to :group
        t.belongs_to :user
      end
    end
  end

end