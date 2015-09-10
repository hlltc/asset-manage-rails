class Api::V1::VariantController < Api::V1::BaseController
  # GET /variant
  # GET /variant.json
  # todo: when conditions not specified, query would set them to "all", instead of not specifying.
  def index
    @asset = Asset.find(params[:asset_id])

    @device = params[:device]? params[:device] : "all"
    @size = params[:size]? params[:size] : "all"
    @language = params[:language]? params[:language] : "all"
    
    #try to find matched items
    @variants = @asset.variants.where(:device => @device, :size => @size, :language => @language).order("created_at DESC")
    #if [], :language => "all"
    if @variants.length < 1
      @variants = @asset.variants.where(:device => @device, :size => @size, :language => "all").order("created_at DESC")
    end
    #if [], :language => "all", :size => "all"
    if @variants.length < 1
      @variants = @asset.variants.where(:device => @device, :size => "all", :language => "all").order("created_at DESC")
    end
    #if [], :language => "all", :size => "all", :device => "all"
    if @variants.length < 1
      @variants = @asset.variants.where(:device => "all", :size => "all", :language => "all").order("created_at DESC")
    end

    render json: {variants: @variants.map {|variant| variant.info_to_json}}
  end

  # GET /variant/1
  # GET /variant/1.json
  def show
    @asset = Asset.find(params[:asset_id])
    @variant = @asset.variants.find(params[:id])
    render json: {variant: @variant.info_to_json}
  end


  # POST /variant
  # POST /variant.json
  def create
    @asset = Asset.find(params[:asset_id])
    @variant = @asset.variants.create(variant_params)
    if @variant.save
      render json: {variant: @variant.info_to_json}
    else
      render json: @variant.errors, status: :unprocessable_entity
    end
  end

  # PUT /variant/1
  # PUT /variant/1.json
  def update
    @asset = Asset.find(params[:asset_id])
    @variant = @asset.variants.find(params[:id])
    if @variant.update_attributes(variant_params)
      head :no_content
    else
      render json: @variant.errors, status: :unprocessable_entity
    end
  end

  # DELETE /variant/1
  # DELETE /variant/1.json
  def destroy
    @asset = Asset.find(params[:asset_id])
    @variant = @asset.variants.find(params[:id])
    @variant.destroy

    head :no_content
  end


  private

  def variant_params
    params.require(:variant).permit(:device, :size, :language, :description, :attach)
  end
end
