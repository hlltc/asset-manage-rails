require 'test_helper'

class VariantTest < ActiveSupport::TestCase
    #list variant
  test "list should return 4 variants" do
    variants = Variant.all
    assert_equal 5*20, variants.length, "length of variant list wrong"
  end

  #create fail
  test "should not save variant without device" do
    variant = Variant.new size: "all", language: "all", asset_id: 0
    assert_not variant.save, "save variant without device"
  end
  test "should not save variant with wrong device" do
    variant = Variant.new device: "winPhone", size: "all", language: "all", asset_id: 0
    assert_not variant.save, "save variant wrong device"
  end
  test "should not save variant without size" do
    variant = Variant.new device: "all", language: "all", asset_id: 0
    assert_not variant.save, "save variant without size"
  end
  test "should not save variant with wrong size" do
    variant = Variant.new device: "all", size: "1x1", language: "all", asset_id: 0
    assert_not variant.save, "save variant with wrong size"
  end
  test "should not save variant without language" do
    variant = Variant.new device: "all", size: "all", asset_id: 0
    assert_not variant.save, "save variant without language"
  end
  test "should not save variant with wrong language" do
    variant = Variant.new device: "all", size: "all", language: "arab", asset_id: 0
    assert_not variant.save, "save variant with rong language"
  end
  test "should not save variant without asset_id" do
    variant = Variant.new device: "all", size: "all", language: "all"
    assert_not variant.save, "save variant without asset_id"
  end

  #create succeed
  test "should save variant" do
    variant = Variant.new device: "all", size: "all", language: "all", asset_id: 0
    assert variant.save, "save variant with all required fields"
  end

  #read variant
  test "read variant" do
    variant = Variant.find_by device: "all", size: "all", language: "all"
    assert_not_nil variant, "read variant"
  end

  #update variant
  test "update variant" do
    variant = Variant.find_by device: "all", size: "all", language: "all"
    assert variant.update_attributes(device: "Android"), "update variant"
  end

  #destroy variant
  test "destroy variant" do
    variant = Variant.find_by device: "all", size: "all", language: "all"
    assert variant.destroy, "destroy variant"
  end
end
