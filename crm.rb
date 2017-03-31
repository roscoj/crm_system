require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"
require_relative "sequel_datastore"
also_reload "sequel_datastore.rb"



before do
  @storage = SequelDatastore.new(logger)
end

get "/" do
  erb :home
end

get "/admin" do
  @invoicee_data = @storage.all_invoicees_and_addresses
  @student_data = @storage.all_students_and_invoicees
  erb :admin
end

get "/admin/new_student" do
  erb :new_student
end

post "/admin/new_student" do
  first_name = params[:first_name]
  last_name = params[:last_name]
  @storage.add_new_student(first_name, last_name)
  redirect "/admin"
end

get "/admin/students/:id" do
  @id = params[:id]
  @student_data = @storage.single_student_and_invoicee(@id)
  erb :student
end

get '/admin/students/:id/edit' do
  @id = params[:id]
  @student_data = @storage.single_student_and_invoicee(@id)
  @invoicees_data = @storage.invoicees_and_addresses
  @invoicee_ids = @storage.invoicee_ids.map { |row| row.values }.flatten
  erb :edit_student
end

post "/admin/students/:id/edit" do
  id = params[:id]
  first_name = params[:student_fn]
  last_name = params[:student_ln]
  assigned_invoicee = params[:assigned_invoicee]
  @storage.update_student(id, first_name, last_name, assigned_invoicee)
  redirect "/students/#{id}"
end

get "/admin/new_address" do
  erb :new_address
end

post "/admin/new_address" do
  line1 = params[:address_line_1]
  line2 = params[:address_line_2]
  town = params[:town]
  postcode = params[:postcode]
  @storage.add_new_address(line1, line2, town, postcode)
  redirect "/admin"
end

get "/admin/new_invoicee" do
  @address_info = @storage.all_addresses_info
  erb :new_invoicee
end

post "/admin/new_invoicee" do
  fname = params[:first_name]
  lname = params[:last_name]
  tel = params[:telephone]
  email = params[:email]
  pay_method = params[:payment_method]
  address_id = params[:address_id]
  @storage.add_new_invoicee(fname, lname, tel, email, pay_method, address_id)
  redirect "/admin"
end

get "/admin/invoicees/:id" do
  id = params[:id]
  @invoicee_data = @storage.single_invoicee_and_address(id)
  erb :invoicee
end

get "/admin/invoicees/:id/edit" do
  id = params[:id]
  @payment_methods = ['DD', 'CASH', 'BACS']
  @invoicee_data = @storage.single_invoicee_and_address(id)
  @addresses = @storage.all_addresses_info
  erb :edit_invoicee
end

post "/admin/invoicees/:id/edit" do
  id = params[:id]
  first_name = params[:first_name]
  last_name = params[:last_name]
  telephone = params[:telephone]
  email = params[:email]
  payment_method = params[:payment_method]
  address_id = params[:address_id]
  @storage.update_invoicee(id, first_name, last_name, telephone, email, payment_method, address_id) 
  redirect "/admin"
end

get "/invoicing" do
  @student_data = @storage.all_students_and_invoicees
  @balance_data = @storage.invoicee_balances
  @invoicee_data = @storage.invoicees_and_addresses
  @session_data = @storage.all_session_data
  erb :invoicing
end

get "/invoicing/new_session" do
  @student_data = @storage.all_students_and_invoicees
  erb :new_session
end

def format_timestamp(date, time)
  date, month, year = date.split('/')
  "#{year}-#{month}-#{date} #{time} +0000"
end

post "/invoicing/new_session" do
  @student_data = @storage.all_students_and_invoicees
  student_id = params[:student]
  date = params[:session_date]
  start_time = format_timestamp(date, params[:start_time])
  end_time = format_timestamp(date, params[:end_time])

  @storage.add_new_session(student_id, start_time, end_time)
  redirect "/invoicing"
end

post "route_for_creating_invoice" do
  invoice = InvoiceCreator.new(@acme_data)
  # then insert invoice into database
end

