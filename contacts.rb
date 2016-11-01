require 'sinatra'
require 'tilt/erubis'
require 'sinatra/content_for'

require_relative 'data_persistence'

configure do
  enable :sessions
  set :session_secret, 'secret'
  set :erb, :escape_html => true
end

configure(:development) do
  require 'sinatra/reloader'
  also_reload 'data_persistence.rb'
end

helpers do
  # extracts the contact credentials from request.params hash
  def contact_credentials(data)
    data.values[0..3].map!(&:strip)
  end

  # extracts group data from request.params hash
  def query_group_data(data)
    data.keys.drop(4)
  end

  def empty_input?(data)
    contact_credentials(data).any?(&:empty?)
  end

  def non_numeric?(inpt)
      !(inpt.to_i.to_s == inpt)
      !('0' + inpt.to_i.to_s == inpt) if inpt.chars.first == '0'
  end

  def full_name(name)
    name[:first_name] + ' ' + name[:last_name]
  end
end

before do
  @storage = DataPersistence.new(logger)
end

get '/' do
  erb :index
end

get '/add/contact' do
  erb :contact_new
end

get '/add/group' do
  erb :group_new
end

post '/add/group/new' do
  name = params[:group].strip

  if name.empty?
    session[:message] = 'Input is empty.'
    status 422
    erb :group_new
  elsif !@storage.find_group(name).empty?
    session[:message] = "#{name} already exsists."
    status 422
    erb :group_new
  else
    @storage.create_new_group(name)
    session[:message] = "Added new group: #{name}."
    redirect '/'
  end
end

post '/add/contact/new' do
  if !@storage.find_contact(params[:first_name], params[:last_name]).empty?
    session[:message] = 'Contact already exsists.'
    status 422
    erb :contact_new
  elsif empty_input?(request.params)
    session[:message] = 'You must fill in all the fields.'
    status 422
    erb :contact_new
  elsif non_numeric?(params[:number])
    session[:message] = 'Input in the number field has to be a number.'
    status 422
    erb :contact_new
  else
    @storage.create_new_contact(
      contact_credentials(request.params), query_group_data(request.params)
    )
    session[:message] =
      "#{params[:first_name]} #{params[:last_name]} added."
    redirect '/'
  end
end

post '/contacts/:full_name/edit' do
  first_name, last_name = params[:full_name].split(' ')

  @contact = @storage.find_contact(first_name, last_name).first
  @contact_groups = @storage.groups_by_contact(first_name, last_name)
  id = @contact[:id]

  if empty_input?(request.params) || non_numeric?(params[:number])
    session[:message] = 'You must fill in all the fields.'
    status 422
    erb :contact_edit
  else
    @storage.update_contact(
      id, contact_credentials(request.params), query_group_data(request.params)
    )
    session[:message] =
      "Contact: #{params[:first_name]} #{params[:last_name]} saved."
    redirect '/'
  end
end

post '/contacts/:full_name/delete' do
  first_name, last_name = params[:full_name].split(' ')
  id = @storage.find_contact(first_name, last_name).first[:id]
  @storage.delete_contact(id, first_name, last_name)

  session[:message] = "#{first_name} #{last_name} deleted."
  redirect '/'
end

get '/contacts/:full_name' do
  first_name, last_name = params[:full_name].split(' ')
  redirect not_found if @storage.find_contact(first_name, last_name).empty?

  @contact = @storage.find_contact(first_name, last_name).first
  @contact_groups = @storage.groups_by_contact(first_name, last_name)
  erb :contact_edit
end

post '/groups/:name/delete' do
  name = params[:name]

  @storage.delete_group(name)
  session[:message] = "Group: #{name} deleted."
  redirect '/'
end

get '/groups/:name' do
  @group = @storage.contacts_by_group(params[:name])
  redirect not_found if @storage.find_group(params[:name]).empty?
  erb :group_view
end

not_found do
  erb :not_found
end
