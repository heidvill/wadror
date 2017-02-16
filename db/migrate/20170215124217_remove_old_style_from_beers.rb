class RemoveOldStyleFromBeers < ActiveRecord::Migration[5.0]
  def change
    remove_column :beers, :old_style, :string
  end
end
