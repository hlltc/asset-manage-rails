class VariantControllerTest < ActionController::TestCase
  def setup
    @controller = (Api::V1::VariantController).new

    @variant_1 = variants(:variant_1_asset_1)
    @asset_1 = assets(:asset_1)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:variants)
  end
  test "should get index by asset_id" do
    get :index, asset_id: @asset_1.id
    assert_response :success
    assert_not_nil assigns(:variants)
  end
  test "should get index by asset_id/device/size/language" do
    get :index, asset_id: @asset_1.id, device: "all", size: "all", language: "all"
    assert_response :success
    assert_not_nil assigns(:variants)
  end
  test "should get index by asset_id, and alternate device/size/language to all" do
    get :index, asset_id: @asset_1.id, device: "iPad", size: "iPad", language: "iPad"
    assert_response :success
    assert_not_nil assigns(:variants)
  end

  test "should get show" do
    get :show, id: @variant_1.id
    assert_response :success
    assert_not_nil assigns(:variant)
  end

  test "should create variant" do
    post :create, variant: {device: "all", size: "all", language: "all", asset_id: @asset_1.id}
    assert_response :success
    assert_not_nil assigns(:variant)
  end
  test "should not create variant without required field" do
    post :create, variant: {description: "description of variant new"}
    assert_response 422
  end
  test "should not create variant with wrong value" do
    post :create, variant: {device: "description of variant new", size: "all", language: "all", asset_id: @asset_1.id}
    assert_response 422
  end

  test "should put update" do
    put :update, id: @variant_1.id, variant: {device: "iPad"}
    assert_response :success
    assert_not_nil assigns(:variant)
  end
  test "should not put update" do
    put :update, id: @variant_1.id, variant: {device: "winPhone"}
    assert_response 422
    assert_not_nil assigns(:variant)
  end

  test "should delete destroy" do
    delete :destroy, id: @variant_1.id
    assert_response :success
  end
end