require 'test_helper'
 
class VariantMatchTest < ActionDispatch::IntegrationTest
  fixtures :assets, :variants

  def setup
    @asset_1 = assets(:asset_1)
  end

  test "random condition variants match sampling test" do
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

  #for any asset, variant(iPad, 768x1024, it) does not exist
  test "language compromise condition variants match test" do
    #list variants for @asset_1
    get '/v1/variant?asset_id='+@asset_1.id.to_s
    assert_response :success
    variants = assigns(:variants)
    assert_not_nil variants
    assert_not_equal 0, variants.length, "none variant for asset_1"

    #compromise test
    if variants && variants.length>0
      #get real variants that match (device, size, all)
      _variants = variants.select{|item| item.language=='all'}
      #test
      20.times do |t|
        variant = _variants[rand(_variants.length)]
        device = variant.device
        size = variant.size
        language = 'it'
        fetch_variant(@asset_1.id, device, size, language)
      end
    end
  end

  #for any asset, variant(iPad, 768x1024, it) does not exist
  test "language size compromise condition variants match test" do
    #list variants for @asset_1
    get '/v1/variant?asset_id='+@asset_1.id.to_s
    assert_response :success
    variants = assigns(:variants)
    assert_not_nil variants
    assert_not_equal 0, variants.length, "none variant for asset_1"

    #compromise test
    if variants && variants.length>0
      #get real variants that match (device, size, all)
      _variants = variants.select{|item| item.language=='all'&&item.size='all'}
      #test
      20.times do |t|
        variant = _variants[rand(_variants.length)]
        device = variant.device
        size = '768x1024'
        language = 'it'
        fetch_variant(@asset_1.id, device, size, language)
      end
    end
  end

  #for any asset, variant(iPad, 768x1024, it) does not exist
  test "language size device compromise condition variants match test" do
    #list asset
    get '/v1/asset'
    assert_response :success
    assets = assigns(:assets)
    assert_not_nil assets
    assert_not_equal 0, assets.length, "asset list length is 0"

    #compromise test
    100.times do |t|
      asset_id = assets[rand(assets.length)].id
      device = 'iPad'
      size = '768x1024'
      language = 'it'
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