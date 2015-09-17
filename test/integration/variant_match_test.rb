require 'test_helper'
 
class VariantMatchTest < ActionDispatch::IntegrationTest
  fixtures :assets, :variants

  test "match asset variants" do
    #list asset
    get '/v1/asset'
    assert_response :success
    assets = assigns(:assets)
    assert_not_nil assets
    assert_not_equal 0, assets.length, "asset list length is 0"

    #match variant
    devices = %w(all Android iPhone iPad)
    sizes = %w(all 320x480 320x568 375x667 414x736 768x1024)
    languages = %w(all en zh de fr it)

    100.times do |t|
      asset_id = assets[rand(assets.length)].id
      device = devices[rand(devices.length)]
      size = sizes[rand(sizes.length)]
      language = languages[rand(languages.length)]
      fetch_variant(asset_id, device, size, language)
    end
  end

  private

  def fetch_variant(asset_id, device, size, language)
    get '/v1/variant?asset_id='+asset_id.to_s+'&device='+device+'&size='+size+'&language='+language
    assert_response :success
    variants = assigns(:variants)
    assert_not_nil variants
    assert_not_equal 0, variants.length, "none variant matched"
  end
end