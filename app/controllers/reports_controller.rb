class ReportsController < ApplicationController

  # რეპორტების საწყისი გვერდი
  def index
    @title = 'რეპორტები'
  end

  # წიგნების რაოდენობა დირექციების მიხედვით
  def by_direqcia
    @title = 'წიგნების რაოდენობა დირექციების მიხედვით'
    @data = []
    @count = 0
    direqcias = Direqcia.all(:order => :code)
    direqcias.each do |d|
      cnt = Book.count(:conditions => ['nomenclatures.direqcia_id = ?', d.id], :include => :nomenclature)
      @data.push [d, cnt]
      @count += cnt
    end
  end

  # წიგნების რაოდენობა დირექციების და წლების მიხედვით
  def by_direqcia_and_year
    @title = 'წიგნების რაოდენობა დირექციების და წლების მიხედვით'
    @raw_data = Book.find_by_sql("SELECT
      b.book_year as year, count(*) AS count, n.direqcia_id AS direqcia_id
      FROM books b
      INNER JOIN nomenclatures n ON n.id = b.nomenclature_id
      INNER JOIN direqcias d ON d.id = n.direqcia_id
      GROUP BY b.book_year, n.direqcia_id
      ORDER BY b.book_year, d.code, n.code")
    @total_count = 0
    @data = []
    prev_year = nil
    year_data = []
    year_count = 0
    @raw_data.each do |row|
      if prev_year.nil? or prev_year != row.year
        unless prev_year.nil?
          @data.push({:year => prev_year, :year_data => year_data, :count => year_count})
        end
        prev_year = row.year 
        year_data = []
        year_count = 0       
      end
      year_datum = {:year => row.year, :direqcia => Direqcia.find(row.direqcia_id), :count => row.count}
      year_data.push year_datum
      year_count += row.count.to_i
      @total_count += row.count.to_i
    end
    unless prev_year.nil?
      @data.push({:year => prev_year, :year_data => year_data, :count => year_count})
    end
  end

  # წიგნების რაოდენობა დირექციების და შემოსვლის წლების მიხედვით
  def by_direqcia_and_enter_year
    @title = 'წიგნების რაოდენობა დირექციების და შემოსვლის წლების მიხედვით'
    @raw_data = Book.find_by_sql("SELECT
      b.enter_year as year, count(*) AS count, n.direqcia_id AS direqcia_id
      FROM books b
      INNER JOIN nomenclatures n ON n.id = b.nomenclature_id
      INNER JOIN direqcias d ON d.id = n.direqcia_id
      GROUP BY b.enter_year, n.direqcia_id
      ORDER BY b.enter_year, d.code, n.code")
    @total_count = 0
    @data = []
    prev_year = nil
    year_data = []
    year_count = 0
    @raw_data.each do |row|
      if prev_year.nil? or prev_year != row.year
        unless prev_year.nil?
          @data.push({:year => prev_year, :year_data => year_data, :count => year_count})
        end
        prev_year = row.year 
        year_data = []
        year_count = 0       
      end
      year_datum = {:year => row.year, :direqcia => Direqcia.find(row.direqcia_id), :count => row.count}
      year_data.push year_datum
      year_count += row.count.to_i
      @total_count += row.count.to_i
    end
    unless prev_year.nil?
      @data.push({:year => prev_year, :year_data => year_data, :count => year_count})
    end
  end

end