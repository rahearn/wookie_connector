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

$:.push File.expand_path('../wookie', __FILE__)

require 'wookie_connector_service'

service = WookieConnectorService.new("http://localhost:8080/wookie/", "TEST", "ruby_localhost", "demo_ruby_user")

puts service.user.screen_name

alive = service.connection.test
if alive
  puts service.connection.host

  widgetInstance = service.find_or_create_widget service.widgets.first.guid
  puts widgetInstance.title
  puts widgetInstance.url
  puts widgetInstance.width
  puts widgetInstance.height
else
  puts "Connection failed!"
end
