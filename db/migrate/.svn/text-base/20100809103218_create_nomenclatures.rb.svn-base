class CreateNomenclatures < ActiveRecord::Migration
  def self.up
    create_table :nomenclatures do |t|
      t.references :direqcia
      t.string :code
      t.string :name

      t.timestamps
    end
    add_index :nomenclatures, :direqcia_id
    add_index :nomenclatures, :code
  end

  def self.down
    drop_table :nomenclatures
  end
end
