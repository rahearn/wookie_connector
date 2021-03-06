#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
# limitations under the License.
#

module WookieConnector
  class WookieService

    attr_reader :user, :server

    def initialize(host, apiKey, sharedDataKey, user)
      @server = Server.new host, apiKey, sharedDataKey
      @user   = User.new user
    end

    def find_or_create_widget(guid)
      server.find_or_create_widget guid, user
    end

    def method_missing(method, *args, &block)
      if respond_to_missing? method
        server.send method, *args, &block
      else
        super
      end
    end

    def respond_to_missing?(method, include_private = false)
      server.respond_to? method, include_private
    end
  end
end
