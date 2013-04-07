class CreateProviders < ActiveRecord::Migration
	def change
    create_table :providers do |t|
      t.string :uid
      t.string :user_provider
      t.references :user

      t.timestamps
    end
  end
end
