class BankAccount
  attr_accessor :balance

  def initialize(balance:)
    @balance = balance
  end

  def withdraw(ammount)
    @balance = @balance - ammount
  end

  def deposit(ammount)
    @balance = @balance + ammount
  end
end

bank = BankAccount.new(balance: 40)

puts bank.withdraw(10)
puts bank.deposit(20)
puts bank.balance #=> 50

