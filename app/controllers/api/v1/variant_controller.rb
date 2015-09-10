class Api::V1::VariantController < Api::V1::BaseController
  # GET /variant
  # GET /variant.json
  def index
    @asset = Asset.find(params[:asset_id])
    @variants = @asset.variants.all
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
