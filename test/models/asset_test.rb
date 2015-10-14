require 'test_helper'

class AssetTest < ActiveSupport::TestCase
  #list asset
  test "list should return 4 assets" do
    assets = Asset.all
    assert_equal 5, assets.length, "length of asset list wrong"
  end

  #create fail
  test "should not save asset without title" do
    asset = Asset.new
    assert_not asset.save, "save asset without title"
  end

  #create succeed
  test "should save asset" do
    asset = Asset.new title: "asset_new", description: "description of asset new"
    assert asset.save, "save asset with title"
  end

  #read asset
  test "read asset" do
    asset = Asset.find_by title: "asset 0"
    assert_not_nil asset, "read asset by title"
  end

  #update asset
  test "update asset" do
    asset = Asset.find_by title: "asset 0"
    assert asset.update_attributes(title: "asset new", description: "description of asset new"), "update asset"
  end

  #destroy asset
  test "destroy asset" do
    asset = Asset.find_by title: "asset 0"
    assert asset.destroy, "destroy asset"
  end
end
