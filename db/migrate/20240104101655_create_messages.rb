class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.references :sender, foreign_key: { to_table: :users }
      t.references :recipient, polymorphic: true, index: true
      t.text :content

      t.timestamps
    end
  end
end
