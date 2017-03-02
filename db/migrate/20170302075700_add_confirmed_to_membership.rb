class AddConfirmedToMembership < ActiveRecord::Migration[5.0]
  def change
    add_column :memberships, :confirmed, :boolean
  end
end
