require "sequel"
require "pry"

DB = Sequel.connect("postgres://localhost/crm_sys")
class SequelDatastore

  def all_students 
    DB[:students]
  end

  def all_invoicees
    DB[:invoicees]
  end

  def new_student(first_name, last_name)
    DB[:students].insert([:first_name, :last_name], [first_name, last_name])
  end

  def fetch_student_invoicee_details
    results = DB[:students].left_join(:invoicees, id: :invoicee_id).
    
    select do 
      [ students__first_name.as(students_fn),
         students__last_name.as(students_ln),
        students__id.as(students_id),
        students__invoicee_id.as(invoicee_id) ]
    end.
    
    select_append do
      [ invoicees__first_name.as(invoicees_fn),
        invoicees__last_name.as(invoicees_ln),
        invoicees__telephone.as(invoicees_tel),
        invoicees__email.as(invoicees_email) ]
    end
    results
  end

  def all_student_invoicee_details
    fetch_student_invoicee_details.all
  end
  
  def single_student_invoicee_details(id)
    fetch_student_invoicee_details.first(students__id: id)
  end

  def fetch_invoicee_details 
    all_invoicees.all
  end

  def fetch_invoicee_ids
    all_invoicees.select(:id).all
  end

  def invoicee_and_addresses
    DB[:invoicees].join(:addresses, id: :address_id).all
  end








  def session_data 
    DB[:sessions].select do
      [ invoicees__id,
        Sequel.join([students__first_name, students__last_name],' ').as(student),
        Sequel.join([invoicees__first_name, invoicees__last_name], ' ').as(invoicee),
        SequelDatastore.calc_duration(sessions__start_time, sessions__end_time).as(duration), 
        SequelDatastore.calc_cost(sessions__start_time, sessions__end_time, fee_per_hour).as(cost) ]

    end.
      join(:students, id: :student_id).
      join(:invoicees, id: :students__invoicee_id)
  end
  
  def all_sessions
    session_data.all
  end
  
  def single_invoicee_sessions(id)
    session_data.select(:students__first_name).where(invoicees__id: id)
  end


  def self.calc_duration(start_timestamp, end_timestamp)
    hours = Sequel.extract(:hour, end_timestamp - start_timestamp)
    minutes = Sequel.extract(:minute, end_timestamp - start_timestamp)
    return (hours + minutes) if  minutes == 0
    return (hours + (minutes / 60))
  end

  def self.calc_cost(start_timestamp, end_timestamp, fee)
    SequelDatastore.calc_duration(start_timestamp, end_timestamp) * fee
  end


  def invoicee_balances
    DB[:invoicees].distinct.select do
      [ invoicees__first_name,
        invoicees__last_name,
        students__first_name ]
    end.
    left_join(:students, invoicee_id: :id).
    left_join(:sessions, student_id: :students__id)
  end 

end

@storage = SequelDatastore.new

puts "============="
puts ""

p @storage.invoicee_balances.all



def calc_total_balance
  balance = 0
  @storage.session_data.each do |row|
    balance += row[:cost]
  end
  balance
 end

 
def calc_single_balance(id)
  balance = 0
  data = @storage.session_data.where(invoicees__id: id)
  data.each do |row|
    binding.pry
    balance += row[:cost]
  end
  balance
 end

  def invoicee_balances
    DB[:invoicees].distinct.select do
      [ invoicees__first_name,
        invoicees__last_name,
        students__first_name ]
    end.
    left_join(:students, invoicee_id: :id).
    left_join(:sessions, student_id: :students__id)
  end 












