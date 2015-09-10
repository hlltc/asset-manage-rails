class Api::V1::VariantController < Api::V1::BaseController
  # GET /variant
  # GET /variant.json
  def index
    @variants = Variant.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @variants.map {|variant| variant.info_to_json}}
    end
  end

  # GET /variant/1
  # GET /variant/1.json
  def show
    @variant = Variant.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: {variant: @variant.info_to_json}}
    end
  end

  # GET /variant/new
  # GET /variant/new.json
  def new
    @variant = Variant.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: {variant: @variant.info_to_json}}
    end
  end

  # GET /variant/1/edit
  def edit
    @variant = Variant.find(params[:id])
  end

  # POST /variant
  # POST /variant.json
  def create

    @variant = Variant.new(variant_params)

    respond_to do |format|
      if @variant.save
        format.html {
          render  :json => [@variant.to_jq_upload].to_json,
                  :content_type => 'text/html',
                  :layout => false
        }
        format.json { render json: {variant: @variant.info_to_json}}
      else
        format.html { render action: "new" }
        format.json { render json: @variant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /variant/1
  # PUT /variant/1.json
  def update
    @variant = Variant.find(params[:id])

    respond_to do |format|
      if @variant.update_attributes(variant_params)
        format.html { redirect_to @variant, notice: 'Attach was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @variant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /variant/1
  # DELETE /variant/1.json
  def destroy
    @variant = Variant.find(params[:id])
    @variant.destroy

    respond_to do |format|
      format.html { redirect_to variant_url }
      format.json { head :no_content }
    end
  end


  private

  def variant_params
    params.require(:variant).permit(:device, :size, :language, :description, :attach)
  end
end
