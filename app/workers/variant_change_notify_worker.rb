class VariantChangeNotifyWorker
  include Sidekiq::Worker

  def perform(variant_id)
    variant = Variant.find(variant_id)
    puts "---------asset variant changes notify---------"
    puts variant.info_to_json
    puts "----------------------------------------------"
  end
end