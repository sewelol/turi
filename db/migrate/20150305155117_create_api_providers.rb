class CreateApiProviders < ActiveRecord::Migration
  def change

    create_table :api_providers do |t|
      t.string :name
    end

    add_index :api_providers, [:name], :unique => true

  end
end
