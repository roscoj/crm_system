require "sequel"

DB = Sequel.connect("postgres://localhost/crm_sys")

class SequelDatastore
  def initialize(logger)
    DB.logger = logger
  end

  def all_students 
    DB[:students]
  end

  def all_invoicees
    DB[:invoicees]
  end

  def all_addresses
    DB[:addresses]
  end

  def add_new_student(first_name, last_name)
    DB[:students].insert([:first_name, :last_name], [first_name, last_name])
  end

  def students_and_invoicees
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
        invoicees__email.as(invoicees_email), 
        invoicees__id.as(inv_id) ]
    end
    results
  end

  def all_students_and_invoicees
    students_and_invoicees.all
  end

  def single_student_and_invoicee(id)
    students_and_invoicees.first(students__id: id)
  end

  def invoicees_and_addresses
    results = DB[:invoicees].join(:addresses, id: :address_id).


      select do
        [ invoicees__id.as(id),
          invoicees__first_name,
          invoicees__last_name,
          invoicees__telephone,
          invoicees__email,
          invoicees__payment_method,
          invoicees__address_id ]
      end.

     select_append do
        [ addresses__address_line_1,
          addresses__address_line_2,
          addresses__town,
          addresses__postcode ]
      end
      results
  end
  
  def all_invoicees_and_addresses
    invoicees_and_addresses.all
  end

  def single_invoicee_and_address(id)
    invoicees_and_addresses.first(invoicees__id: id)
  end

  def invoicee_ids
    all_invoicees.select(:id).all
  end

  def update_student(id, first_name, last_name, assigned_invoicee)
    DB[:students].where(id: id).update(first_name: first_name, last_name: last_name, invoicee_id: assigned_invoicee)
  end

  def add_new_invoicee(fname, lname, tel, email, pay_method, address_id)
    DB[:invoicees].insert(
      first_name: fname,
      last_name: lname,
      telephone: tel,
      email: email,
      payment_method: pay_method,
      address_id: address_id)
  end

  def update_invoicee(id, fname, lname, tel, email, pay_method, address_id)
      DB[:invoicees].where(id: id).update(
        first_name: fname,
        last_name: lname,
        telephone: tel,
        email: email,
        payment_method: pay_method,
        address_id: address_id)
  end

  def all_addresses_info
    all_addresses.all
  end

  def add_new_address(line1, line2, town, postcode)
    all_addresses.insert(address_line_1: line1, address_line_2: line2, town: town, postcode: postcode)
  end


  def add_new_session(student_id, start_time, end_time)
    DB[:sessions].insert(student_id: student_id, start_time: start_time, end_time: end_time)
  end

  def session_data 
    DB[:sessions].select do
      [ Sequel.join([students__first_name, students__last_name],' ').as(student),
        Sequel.join([invoicees__first_name, invoicees__last_name], ' ').as(invoicee),
        #Sequel.extract(:date, sessions__start_time).as(date),
        sessions__start_time.as(date),
        SequelDatastore.calc_duration(sessions__start_time, sessions__end_time).as(duration), 
        SequelDatastore.calc_cost(sessions__start_time, sessions__end_time, fee_per_hour).as(cost) ]
    end.
      join(:students, id: :student_id).
      join(:invoicees, id: :students__invoicee_id).
      order(:date)
  end

  def all_session_data
    session_data.all
  end

  def single_invoicee_session_data(id)
    session_data.where(invoicee__id: id).limit(1)
  end
  
  def invoicee_balances
    DB[:invoicees].distinct(:id).select do
      [ invoicees__id.as(id),
        Sequel.join([invoicees__first_name, invoicees__last_name], ' ').as(invoicee),
        sum(SequelDatastore.calc_duration(sessions__start_time, sessions__end_time) * students__fee_per_hour).as(balance)]
    end.
    left_join(:students, invoicee_id: :id).
    left_join(:sessions, student_id: :students__id).
    group(:invoicees__id)
  end 

  private

  def self.calc_duration(start_timestamp, end_timestamp)
    hours = Sequel.extract(:hour, end_timestamp - start_timestamp)
    minutes = Sequel.extract(:minute, end_timestamp - start_timestamp)
    return (hours + minutes) if  minutes == 0
    return (hours + (minutes / 60))
  end

  def self.calc_cost(start_timestamp, end_timestamp, fee)
    SequelDatastore.calc_duration(start_timestamp, end_timestamp) * fee
  end

end

