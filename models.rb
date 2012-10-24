require 'redis'
require 'json'
require 'digest'

class DB
  def self.connection
    DB.connection ||= Redis.new
  end
end

# stored in redis:
# fin:DD.MM.YYYY (List)
# "{titile: <title>, price: <price>}"
class Item
  def self.get_all(date)
    items = DB.connection.lrange "fin:#{date}", 0, -1
    items.map do |item|
      JSON.parse(item)
    end
  end

  def self.create(date, item)
    current_balance = DB.connection.get("fin:balance").to_f
    DB.connection.set("fin:balance", current_balance - item["price"].to_f)
    DB.connection.rpush "fin:#{date}", JSON.dump(item)
  end
end

class Balance
  def self.current(username)
    DB.connection.get("fin:#{username}:balance").to_f.round(2)
  end
end

class User
  def self.valid?(name, pass)
    DB.connection.get("fin:users:#{name}:pass") == Digest::MD5.hexdigest(pass)
  end

  def self.register(name, pass)
    if DB.connection.get("fin:users:#{name}").nil?
      DB.connection.set "fin:users:#{name}:pass", Digest::MD5.hexdigest(pass)
    end
  end
end

class Validator
  def self.validate_login(login)
  end

  def self.validate_password(password)
  end
end
