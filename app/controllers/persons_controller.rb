class PersonsController < ApplicationController
  before_action :find_person, only: [:show, :edit]
  def index
    @persons = get_sql("select * from person") do |objects|
      objects.map{ Struct.new("Person", *_1.keys).new(*_1.values) }
    end
  end

  def show; end

  def new; end

  def create
    # curl -X POST -d 'person[lname]=linux&person[fname]=linux' localhost:3000/persons
    begin
      @person = insert_sql(params.keys.first, person_params)
      if !!@person
        redirect_to persons_path
      else
        render status: 500
      end

    rescue Exception => e
      render json: e.to_json, status: 500
    end
  end

  def edit; end

  def update
    # curl --request PATCH localhost:3000/persons/1?person[lname]=Тучкин
    begin
      @person = update_sql(params.keys.first, person_params.to_h, params['id'].to_i)
      if !!@person
        redirect_to person_path(params['id'])
      else
        render status: 500
      end

    rescue Exception => e
      render json: e.to_json, status: 500
    end
  end

  def destroy
    # curl -X "DELETE" localhost:3000/persons/8
    begin
      @res = query_sql("Delete from person where id=#{params[:id]}")
      if !!@res
        redirect_to persons_path
      else
        render status: 500
      end

    rescue Exception => e
      render json: e.to_json, status: 500
    end
  end

  private

  def find_person
    @person = get_sql("select * from person where id=#{params[:id]}") do |objects|
      objects.map{ Struct.new("Person", *_1.keys).new(*_1.values) }
    end[0]
  end

  def person_params
    params.require(:person).permit(:fname, :lname, :gender, :state, :birth_date)
  end
end
