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
  class Widget
    attr_reader :title

    def initialize(title, extras = {})
      @title  = title
      @extras = extras
    end

    def method_missing(method, *args, &block)
      if respond_to_missing? method
        @extras[method.to_sym]
      else
        super
      end
    end

    def respond_to_missing?(method, include_private = false)
      @extras.has_key? method.to_sym
    end

    def to_s
      "Widget Title: #{title}\n       Attributes: #{@extras.inspect}"
    end
  end
end
