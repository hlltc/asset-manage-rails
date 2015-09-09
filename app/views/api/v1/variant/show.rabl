collection [@variant] => :variants

attributes :id, :device, :size, :language, :description, :attach_file_name, :attach_file_size, :attach_content_type

node :links do |variant|
  links = {}
  links[:show_variant] = api_v1_variant_url(variant.id)
  links
end
