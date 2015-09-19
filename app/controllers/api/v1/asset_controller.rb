class Api::V1::AssetController < Api::V1::BaseController
  http_basic_authenticate_with name: "admin", password: "admin", except: [:index, :show]

  # GET /asset
  # GET /asset.json
  def index
    @order_by = params[:_sortField] ? params[:_sortField] : "created_at"
    @order_dir = params[:_sortDir] ? params[:_sortDir] : "DESC"
    @order = @order_by+" "+@order_dir
    @page = (params[:_page] && params[:_page].class=="Fixnum" && params[:_page]>0) ? params[:_page] : 1
    @page_size = (params[:_perPage] && params[:_perPage].class=="Fixnum" && params[:_perPage]>0) ? params[:_perPage] : 20

    @assets = Asset.where({})
                  .order(@order)
                  .limit(@page_size)
                  .offset(@page_size*(@page-1))
    render json: @assets
  end

  # GET /asset/1
  # GET /asset/1.json
  def show
    @asset = Asset.find(params[:id])
    render json: @asset
  end


  # POST /asset
  # POST /asset.json
  def create
    @asset = Asset.new(asset_params)
    if @asset.save
      render json: @asset
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
