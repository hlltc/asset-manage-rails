class AssetControllerTest < ActionController::TestCase
  def setup
    @controller = (Api::V1::AssetController).new

    @asset_1 = assets(:asset_1)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:assets)
  end

  test "should get show" do
    get :show, id: @asset_1.id
    assert_response :success
    assert_not_nil assigns(:asset)
  end

  test "should create asset" do
    post :create, asset: {title: "asset new", description: "description of asset new"}
    assert_response :success
    assert_not_nil assigns(:asset)
  end
  test "should not create asset" do
    post :create, asset: {description: "description of asset new"}
    assert_response 422
  end

  test "should put update" do
    put :update, id: @asset_1.id, asset: {title: "asset new", description: "description of asset new"}
    assert_response :success
    assert_not_nil assigns(:asset)
  end

  test "should delete destroy" do
    delete :destroy, id: @asset_1.id
    assert_response :success
  end
end