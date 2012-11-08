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
  class WookieConnectorService

    attr_reader :user, :connection

    def initialize(host, apiKey, sharedDataKey, userName)
      @connection = WookieServerConnection.new host, apiKey, sharedDataKey
      @user       = User.new userName
    end

    def widgets
      connection.widgets
    end

    def find_or_create_widget(guid)
      connection.find_or_create_widget guid, user
    end
  end
end
