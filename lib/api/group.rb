module Api
  class Group
    PROPERTIES = ["id", "group_id", "name", "phone_number", "type",
                  "description", "image_url", "creator_user_id", "created_at",
                  "updated_at", "office_mode", "share_url", "members",
                  "messages", "max_members"]
    attr_accessor :raw_hash
    attr_accessor *PROPERTIES.map { |item| item.to_sym }

    def initialize(hash)
      @raw_hash = hash
      PROPERTIES.each do |property|
        self.instance_variable_set(:"@#{property}", @raw_hash[property])
      end
    end
  end
end
