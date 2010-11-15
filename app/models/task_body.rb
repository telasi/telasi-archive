class TaskBody < ActiveRecord::Base
  belongs_to :task
  belongs_to :from, :class_name => 'User'

  def body_text
    self.body.gsub /\n/, '<br/>'
  end
end
