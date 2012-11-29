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
  class Server

    attr_reader :host

    def initialize(host, api_key, shared_data_key)
      @host            = host.gsub %r{/$}, ''
      @api_key         = api_key
      @shared_data_key = shared_data_key
      @cache           = {}
    end

    def widgets
      xml_data = Net::HTTP.get_response(URI.parse "#@host/widgets?all=true").body
      REXML::Document.new(xml_data).elements.collect('widgets/widget') do |widget|
        extras = {
          guid:        widget.attributes['id'],
          description: widget.elements['description'].text,
        }
        icon = widget.elements['icon'] and extras[:icon] = icon.attributes['src']

        Widget.new widget.elements['name'].text, extras
      end
    end

    def find_or_create_widget(guid, user)
      key = :"#{guid}:#{user.login_name}"
      @cache[key] ||= begin
                        xml_data = Net::HTTP.post_form(URI.parse("#@host/widgetinstances"),
                                                       {'api_key' => @api_key,
                                                        'userid' => user.login_name,
                                                        'widgetid' => guid}).body

                        widget = REXML::Document.new(xml_data).elements['widgetdata']
                        Widget.new(widget.elements['title'].text, {
                          url: widget.elements['url'].text,
                          id_key: widget.elements['identifier'].text,
                          width: widget.elements['width'].text,
                          height: widget.elements['height'].text
                        }).tap do |w|
                          set_participant w, guid, user
                        end
                      rescue REXML::ParseException => ex
                        puts "ParseException: #{ex.message}"
                        nil
                      end
    end

    def test
      w = widgets
      !w.nil? && w.length > 0
    rescue REXML::ParseException => ex
      puts "ParseException: #{ex.message}"
      false
    end

    private

    def set_participant(widget, guid, user)
      Net::HTTP.post_form URI.parse("#@host/participants"),
        {'api_key' => @api_key,
         'shareddatakey' => @shared_data_key,
         'userid' => user.login_name,
         'id_key' => widget.id_key,
         'widgetid' => guid,
         'participant_role' => nil,
         'participant_display_name' => user.screen_name,
         'participant_id' => user.login_name,
         'participant_thumbnail_url' => nil}
    end
  end
end
