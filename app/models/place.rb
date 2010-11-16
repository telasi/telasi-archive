class Place < ActiveRecord::Base
  belongs_to :parent, :class_name => 'Place'
  has_many :children, :foreign_key => 'parent_id', :class_name => 'Place', :order => :name
  has_many :books
  validates_presence_of :name
end
