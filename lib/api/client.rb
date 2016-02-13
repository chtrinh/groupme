module Api
  class Client
    include HTTParty
    base_uri 'https://api.groupme.com/v3'

    # GROUPME_CLIENT_ID = "slUG0uhGiwNHKXWv7lqBi7d37XOd38rF1Qdhw6SeP6ubiAe3"
    MY_ACCESS_TOKEN = "2e949740b36f01339a2761da60ad1c6a"

    # def self.authenticate_url
    #   "https://oauth.groupme.com/oauth/authorize?client_id=#{GROUPME_CLIENT_ID}"
    # end

    # attr_accessor :user

    def initialize
      @options = { query: { token: MY_ACCESS_TOKEN } }
    end

    def groups
      response = self.class.get("/groups", @options)
      json = JSON.parse(response.body)

      @groups = []

      json["response"].each do |group_json|
        @groups << Api::Group.new(group_json)
      end

      @groups
    end

    # GET /groups/:group_id/messages
    def get_messages_text(group_id)
      @options = { query: { limit: 5, token: MY_ACCESS_TOKEN } }
      response = self.class.get("/groups/#{group_id}/messages", @options)
      json = JSON.parse(response.body)

      # @message_text = json["response"]["messages"].map do |message|
      #   message["text"]
      # end
      json["response"]["messages"]
    end

    # POST /groups/:group_id/messages
    def post_message(group_id, msg)
      options = {
        query: { token: MY_ACCESS_TOKEN },
        headers: { 'Content-Type' => 'application/json' },
        body: {
          message: { source_guid: SecureRandom.hex(16), text: msg.to_s }
        }.to_json
      }
      self.class.post("/groups/#{group_id}/messages", options)
    end

    # GET /direct_messages
    def get_direct_message(user_id)
      options = { query: { token: MY_ACCESS_TOKEN, other_user_id: user_id.to_s } }
      direct_message = self.class.get("/direct_messages", options)
      json = JSON.parse(direct_message.body)
    end

    # POST /direct_messages
    def post_direct_message(user_id, msg)
      options = {
        query: { token: MY_ACCESS_TOKEN },
        headers: { 'Content-Type' => 'application/json' },
        body: {
          direct_message: { source_guid: SecureRandom.hex(16),
                            recipient_id: user_id.to_s,
                            text: msg.to_s }
        }.to_json
      }

      direct_message = self.class.post("/direct_messages", options)
    end

    # POST /messages/:conversation_id/:message_id/like
    def like_message(conversation_id, message_id)
      self.class.post("/messages/#{conversation_id}/#{message_id}/like",
                              @options)
    end

    # POST /messages/:conversation_id/:message_id/unlike
    def unlike_message(conversation_id, message_id)
      self.class.post("/messages/#{conversation_id}/#{message_id}/unlike",
                              @options)
    end
  end
end
