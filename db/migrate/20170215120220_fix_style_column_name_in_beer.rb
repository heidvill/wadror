class FixStyleColumnNameInBeer < ActiveRecord::Migration[5.0]
  def change
    rename_column :beers, :style, :old_style
  end
end
