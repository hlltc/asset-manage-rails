class Api::V1::AssetController < Api::V1::BaseController
  # GET /asset
  # GET /asset.json
  def index
    @assets = Asset.all
    render json: {assets: @assets.map {|asset| asset.info_to_json}}
  end

  # GET /asset/1
  # GET /asset/1.json
  def show
    @asset = Asset.find(params[:id])
    render json: {asset: @asset.info_to_json}
  end


  # POST /asset
  # POST /asset.json
  def create
    @asset = Asset.new(asset_params)
    if @asset.save
      render json: {asset: @asset.info_to_json}
    else
      render json: @asset.errors, status: :unprocessable_entity
    end
  end

  # PUT /asset/1
  # PUT /asset/1.json
  def update
    @asset = Asset.find(params[:id])
    if @asset.update_attributes(asset_params)
      head :no_content
    else
      render json: @asset.errors, status: :unprocessable_entity
    end
  end

  # DELETE /asset/1
  # DELETE /asset/1.json
  def destroy
    @asset = Asset.find(params[:id])
    @asset.destroy

    head :no_content
  end


  private

  def asset_params
    params.require(:asset).permit(:title, :description)
  end
end
