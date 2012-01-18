# encoding: utf-8
class Book < ActiveRecord::Base
  cattr_reader :per_page
  @@per_page = 25

  validates_presence_of :name, :nomenclature, :place, :start_date, :end_date
  validates_numericality_of :order_by, :page_count
  belongs_to :nomenclature
  belongs_to :place

  def start_date2
    self.start_date.strftime("%d-%b-%Y") if self.start_date
  end

  def start_date2=(dt)
    self.start_date = dt
  end

  def end_date2
    self.end_date.strftime("%d-%b-%Y") if self.end_date
  end

  def end_date2=(dt)
    self.end_date = dt
  end
end
