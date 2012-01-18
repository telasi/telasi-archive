# encoding: utf-8
class Direqcia < ActiveRecord::Base
  set_table_name :direqcias
  has_many :nomenclatures
  validates_presence_of :code, :name
  validates_uniqueness_of :code
end
