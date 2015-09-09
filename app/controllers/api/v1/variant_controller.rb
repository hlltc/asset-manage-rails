class Api::V1::VariantController < Api::V1::BaseController
  # GET /variant
  # GET /uploads.json
  def index
    @variant = Variant.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @variant.map{|variant| variant.to_jq_upload } }
    end
  end

  # GET /uploads/1
  # GET /uploads/1.json
  def show
    @variant = Variant.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @variant }
    end
  end

  # GET /uploads/new
  # GET /uploads/new.json
  def new
    @variant = Variant.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @variant }
    end
  end

  # GET /uploads/1/edit
  def edit
    @variant = Variant.find(params[:id])
  end

  # POST /uploads
  # POST /uploads.json
  def create
    @variant = Variant.new(variant_params)

    respond_to do |format|
      if @variant.save
        format.html {
          render :json => [@variant.to_jq_upload].to_json,
          :content_type => 'text/html',
          :layout => false
        }
        format.json { render json: {files: [@variant.to_jq_upload]}, status: :created, location: @variant }
      else
        format.html { render action: "new" }
        format.json { render json: @variant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /uploads/1
  # PUT /uploads/1.json
  def update
    @variant = Variant.find(params[:id])

    respond_to do |format|
      if @variant.update_attributes(params[:upload])
        format.html { redirect_to @variant, notice: 'Upload was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @variant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /uploads/1
  # DELETE /uploads/1.json
  def destroy
    @variant = Variant.find(params[:id])
    @variant.destroy

    respond_to do |format|
      format.html { redirect_to uploads_url }
      format.json { head :no_content }
    end
  end


  private

  def variant_params
    params.require(:variant).permit(:device, :size, :language, :description, :file)
  end
end
