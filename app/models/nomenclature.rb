class Nomenclature < ActiveRecord::Base
  belongs_to :direqcia
  has_many :books
  validates_presence_of :direqcia, :code, :name
  
  def to_s
    self.direqcia.code + '/' + self.code
  end
end
