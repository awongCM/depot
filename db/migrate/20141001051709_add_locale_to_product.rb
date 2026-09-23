class AddLocaleToProduct < ActiveRecord::Migration[4.2]
  def change
    add_column :products, :locale, :string
  end
end
