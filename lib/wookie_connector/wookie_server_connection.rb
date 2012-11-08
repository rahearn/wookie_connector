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

require 'net/http'
require 'rexml/document'

module WookieConnector
  class WookieServerConnection

    attr_reader :host

    def initialize(host, api_key, shared_data_key)
      @host            = host.gsub %r{/$}, ''
      @api_key         = api_key
      @shared_data_key = shared_data_key
    end

    def widgets
      xml_data = Net::HTTP.get_response(URI.parse "#@host/widgets?all=true").body
      REXML::Document.new(xml_data).elements.collect('widgets/widget') do |widget|
        Widget.new widget.elements['name'].text, guid: widget.attributes['id']
      end
    end

    def find_or_create_widget(guid, user)
      xml_data = Net::HTTP.post_form(URI.parse("#@host/widgetinstances"),
                                     {api_key: @api_key,
                                      userid: user.login_name,
                                      widgetid: guid}).body

      widget = REXML::Document.new(xml_data).elements['widgetdata']
      Widget.new(widget.elements['title'].text, {
        url: widget.elements['url'].text,
        width: widget.elements['width'].text,
        height: widget.elements['height'].text
      })
    rescue REXML::ParseException => ex
      puts "ParseException: #{ex.message}"
      nil
    end

    def test
      w = widgets
      !w.nil? && w.length > 0
    rescue REXML::ParseException => ex
      puts "ParseException: #{ex.message}"
      false
    end
  end
end
