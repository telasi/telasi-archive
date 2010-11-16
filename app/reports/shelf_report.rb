class ShelfReport < Prawn::Document
  def to_pdf(place, books)
    self.font_size = 10
    repeat :all do
      draw_text Time.now.strftime("%d-%b-%Y %H:%M"), :at => bounds.bottom_left
    end
    font "#{Rails.root}/public/fonts/Arial Unicode.ttf"
    name1 = place.parent ? "#{place.parent.name} >" : ''
    text( "#{name1} #{place.name}", :size => 15 )
    stroke_line( [bounds.left,  bounds.top - 20], [bounds.right, bounds.top - 20] )
    move_down(30)
    if books.any?
      books_table(books)
    else
      text "სია ცარიალეი", :size => 10
    end
    render
  end
  
  def books_table(books)
    widths = [20, 500]
    count = 0
    items = books.map do |book|
      count += 1
      [ 
        count.to_s, 
        book.name
      ]
    end
    items.insert(0, %w[№ დასახელება])
    table(items, :header => true, :column_widths => widths, :row_colors => %w[cccccc ffffff])
    number_pages "გვერდი <page> / <total>-დან ", [bounds.right - 100, 0]
  end
  
end