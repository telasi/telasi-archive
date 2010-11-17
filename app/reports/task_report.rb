class TaskReport < Prawn::Document
  def to_pdf(task)
    self.font_size = 10
    font "#{Rails.root}/public/fonts/Arial Unicode.ttf"

    repeat :all do
      draw_text Time.now.strftime("%d-%b-%Y %H:%M"), :at => bounds.bottom_left
    end

    text( "#{task.subject}", :size => 15 )
    stroke_line( [bounds.left,  bounds.top - 20], [bounds.right, bounds.top - 20] )
    move_down(10)

    widths = [100, 420]

    task.bodies.each do |body|
      move_down(10)
      items = []
      items.push([body.created_at.strftime("%d-%b-%Y"), body.from.full_name])
      items.push(['', body.body])
      table items, :column_widths => widths, :row_colors => %w[cccccc ffffff]
    end

    number_pages "გვერდი <page> / <total>-დან ", [bounds.right - 100, 0]
    render
  end 
end