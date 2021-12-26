class DropSnsCredential < ActiveRecord::Migration[5.2]
  def change
    drop_table :sns_credentials
  end
end
