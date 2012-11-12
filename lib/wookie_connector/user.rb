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
  class User
    attr_reader :login_name, :screen_name

    def initialize(user, screen_name = nil)
      if user.is_a? User
        @login_name  = user.login_name
        @screen_name = user.screen_name
      else
        @login_name  = user
        @screen_name = screen_name.nil? ? user : screen_name
      end
    end
  end
end
