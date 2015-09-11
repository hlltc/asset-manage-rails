class Api::V1::VariantController < Api::V1::BaseController
  # GET /variant
  # GET /variant.json
  # todo: when conditions not specified, query would set them to "all", instead of not specifying.
  def index
    @order_by = params[:_sortField] ? params[:_sortField] : "created_at"
    @order_dir = params[:_sortDir] ? params[:_sortDir] : "DESC"
    @order = @order_by+" "+@order_dir
    @page = (params[:_page] && params[:_page].class=="Fixnum" && params[:_page]>0) ? params[:_page] : 1
    @page_size = (params[:_perPage] && params[:_perPage].class=="Fixnum" && params[:_perPage]>0) ? params[:_perPage] : 20

    #:asset_id specified, alternate query needed if not matched
    if params[:asset_id]
      @asset = Asset.find(params[:asset_id])

      #try to find matched items
      @variants = @asset.variants
                        .where(query_params)
                        .order(@order)
                        .limit(@page_size)
                        .offset(@page_size*(@page-1))
      #if [] && :language specified, :language => "all"
      if @variants.length < 1 && params[:language] != nil && params[:language] != "all"
        params[:language] = "all"
        @variants = @asset.variants
                        .where(query_params)
                        .order(@order)
                        .limit(@page_size)
                        .offset(@page_size*(@page-1))
      end
      #if [] && :size specified, :size => "all" (:language => "all")
      if @variants.length < 1 && params[:size] != nil && params[:size] != "all"
        params[:size] = "all"
        @variants = @asset.variants
                        .where(query_params)
                        .order(@order)
                        .limit(@page_size)
                        .offset(@page_size*(@page-1))
      end
      #if [] && :device specified, :device => "all" (:size => "all" :language => "all")
      if @variants.length < 1 && params[:device] != nil && params[:device] != "all"
        params[:device] = "all"
        @variants = @asset.variants
                        .where(query_params)
                        .order(@order)
                        .limit(@page_size)
                        .offset(@page_size*(@page-1))
      end

      render json: @variants.map {|variant| variant.info_to_json}

    #:asset_id not specified, just match query_params
    else
      @variants = Variant.where(query_params)
                        .order(@order)
                        .limit(@page_size)
                        .offset(@page_size*(@page-1))
      render json: @variants.map {|variant| variant.info_to_json}
    end
  end

  # GET /variant/1
  # GET /variant/1.json
  def show
    @variant = Variant.find(params[:id])
    render json: @variant.info_to_json
  end


  # POST /variant
  # POST /variant.json
  # todo: notify clients creation of new variant
  def create
    @variant = Variant.create(variant_params)
    if @variant.save
      render json: @variant.info_to_json
      puts "---------asset variant creation notify---------"
      puts @variant.info_to_json
      puts "-----------------------------------------------"
    else
      render json: @variant.errors, status: :unprocessable_entity
    end
  end

  # PUT /variant/1
  # PUT /variant/1.json
  # todo: notify clients updating of variant
  def update
    @variant = Variant.find(params[:id])
    if @variant.update_attributes(variant_params)
      puts "---------asset variant updating notify---------"
      puts @variant.info_to_json
      puts "-----------------------------------------------"
      head :no_content
    else
      render json: @variant.errors, status: :unprocessable_entity
    end
  end

  # DELETE /variant/1
  # DELETE /variant/1.json
  def destroy
    @variant = Variant.find(params[:id])
    @variant.destroy

    head :no_content
  end


  private

  def variant_params
    params.require(:variant).permit(:device, :size, :language, :description, :asset_id, :attach)
  end

  def query_params
    params.permit(:device, :size, :language)
  end
end
