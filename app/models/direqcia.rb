class Direqcia < ActiveRecord::Base
  has_many :nomenclatures
  validates_presence_of :code, :name
  validates_uniqueness_of :code
end
