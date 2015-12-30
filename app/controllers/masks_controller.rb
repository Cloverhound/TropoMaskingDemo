class MasksController < ApplicationController
  before_action :set_mask, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token


   def transfer 
    puts 'transferring...'

    from = params[:session][:from][:id]
    to = params[:session][:to][:id]

    puts 'from: ' + from
    puts 'to: ' + to 

    mask = Mask.find_by phone_number: Phonelib.parse(to).e164
    number = mask.number.phone_number

    t = Tropo::Generator.new  
    t.transfer(:to => number, :from => from)

    render :json => (t.response)
  end



  # GET /masks
  # GET /masks.json
  def index
    @masks = Mask.all
  end

  # GET /masks/1
  # GET /masks/1.json
  def show
  end

  # GET /masks/new
  def new
    @mask = Mask.new
  end

  # GET /masks/1/edit
  def edit
  end

  # POST /masks
  # POST /masks.json
  def create
    @mask = Mask.new(mask_params)

    respond_to do |format|
      if @mask.save
        format.html { redirect_to @mask, notice: 'Mask was successfully created.' }
        format.json { render :show, status: :created, location: @mask }
      else
        format.html { render :new }
        format.json { render json: @mask.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /masks/1
  # PATCH/PUT /masks/1.json
  def update
    respond_to do |format|
      if @mask.update(mask_params)
        format.html { redirect_to @mask, notice: 'Mask was successfully updated.' }
        format.json { render :show, status: :ok, location: @mask }
      else
        format.html { render :edit }
        format.json { render json: @mask.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /masks/1
  # DELETE /masks/1.json
  def destroy
    @mask.destroy
    respond_to do |format|
      format.html { redirect_to masks_url, notice: 'Mask was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mask
      @mask = Mask.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mask_params
      params.require(:mask).permit(:phone_number, :number_id)
    end
end
