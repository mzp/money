class CreateBankAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :bank_accounts do |t|
      t.string :description
      t.decimal :latest_balance
      t.datetime :modified_at

      t.timestamps
    end

    create_table :bank_transactions do |t|
      t.belongs_to :bank_account
      t.datetime :issued_at
      t.string :description
      t.decimal :amount
      t.decimal :running_balance

      t.timestamps
    end
  end
end
