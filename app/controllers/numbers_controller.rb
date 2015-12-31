class NumbersController < ApplicationController
  before_action :set_number, only: [:show, :edit, :update, :destroy]


  def mask_number
    respond_to do |format|

      provided_number = params[:number]

      puts "number " + provided_number

      if Phonelib.invalid? provided_number
        puts "invalid number"
          format.json {render json: {message: "phone number is invalid"}, status: 500 }
      else
        provided_number = Phonelib.parse(provided_number).e164

        if Number.exists?(:phone_number => provided_number)
          puts "number exists"
          number = Number.find_by phone_number: provided_number
        else
          number = Number.create(phone_number: provided_number);
          if !number.valid?
            puts number.errors.to_json
          end 
        end

        generated_mask = Phonelib.parse(number.generate_mask()).e164
      
        if generated_mask.nil?
          format.json {render json: {message: "unable to generate mask"}, status: 500 }
        else
          mask = Mask.create(phone_number: generated_mask, number: number)
          if !mask.valid?
            puts mask.errors.to_json
          end 
          format.json {render json: {message: generated_mask}}
        end
      end

    end
  end

  

  # GET /numbers
  # GET /numbers.json
  def index
    @numbers = Number.all
  end

  # GET /numbers/1
  # GET /numbers/1.json
  def show
  end

  # GET /numbers/new
  def new
    @number = Number.new
  end

  # GET /numbers/1/edit
  def edit
  end

  # POST /numbers
  # POST /numbers.json
  def create
    @number = Number.new(number_params)

    respond_to do |format|
      if @number.save
        format.html { redirect_to @number, notice: 'Number was successfully created.' }
        format.json { render :show, status: :created, location: @number }
      else
        format.html { render :new }
        format.json { render json: @number.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /numbers/1
  # PATCH/PUT /numbers/1.json
  def update
    respond_to do |format|
      if @number.update(number_params)
        format.html { redirect_to @number, notice: 'Number was successfully updated.' }
        format.json { render :show, status: :ok, location: @number }
      else
        format.html { render :edit }
        format.json { render json: @number.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /numbers/1
  # DELETE /numbers/1.json
  def destroy
    @number.destroy
    respond_to do |format|
      format.html { redirect_to numbers_url, notice: 'Number was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_number
      @number = Number.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def number_params
      params.require(:number).permit(:phone_number)
    end
end
