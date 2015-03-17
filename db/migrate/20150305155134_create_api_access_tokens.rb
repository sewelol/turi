class CreateApiAccessTokens < ActiveRecord::Migration
  def change

    create_table :api_access_tokens do |t|
      t.references :user, index: true, required: true
      t.references :trip, index: true, required: true
      t.references :api_provider, index: true, required: true

      t.string :token, null: false
      t.string :item, defaul: ''

      t.timestamps null: false
    end

    add_foreign_key :api_access_tokens, :api_providers
    add_foreign_key :api_access_tokens, :trips
    add_foreign_key :api_access_tokens, :users

    add_index :api_access_tokens, [:user_id, :trip_id, :api_provider_id], :unique => true, :name => 'index_tokens_on_use_and_trip_and_provider'

  end
end
