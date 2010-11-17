class Task < ActiveRecord::Base
  cattr_reader :per_page
  @@per_page = 25
    
  validates_presence_of :subject, :last_body, :from
  has_many :bodies, :foreign_key => 'task_id', :class_name => 'TaskBody', :dependent => :destroy
  belongs_to :from, :class_name => 'User'
  def image
    if status == 'O' # ღია სტატუსი
      '16x16/application.png'
    elsif status == 'C' # შესრულებული სტატუსი
      '16x16/clock.png'
    elsif status == 'X' # დახურული სტატუსი
      '16x16/accept.png'
    end
  end
  
  def color
    if status == 'O' # ღია სტატუსი
      '#FCC'
    elsif status == 'C' # შესრულებული სტატუსი
      '#FFC'
    elsif status == 'X' # დახურული სტატუსი
      '#CFC'
    end
  end
end
