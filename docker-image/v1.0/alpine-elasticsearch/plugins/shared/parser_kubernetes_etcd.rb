#
# Fluentd
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
#

# The following Fluentd parser plugin is based on "parser_kubernets.rb", aims to simplify the parsing of multiline
# etcd logs found in Kubernetes nodes. Since etcd log files are different from others and
# in order to simplify the configuration, this plugin provides a 'kubernetes_etcd' format
# parser (built on top of MultilineParser).
#
# When tailing files, this 'kubernetes_etcd' format should be applied to the following
# log file sources:
#
#  - /var/log/etcd*.log
#
# Usage:
#
# ---- fluentd.conf ----
#
# <source>
#    type tail
#    format kubernetes_etcd
#    path ./kubelet.log
#    read_from_head yes
#    tag kubelet
# </source>
#
# ----   EOF       ---

require 'fluent/plugin/parser'

module Fluent
  module Plugin
    class KubernetesParseretcd < Fluent::Plugin::TextParser::MultilineParser
      Fluent::Plugin.register_parser("kubernetes_etcd", self)
      CONF_FORMAT_FIRSTLINE = %q{/^\d[^\s]*\s[^\s]*/}
      CONF_FORMAT2 = %q{/^(?<time>\d[^\s]*\s[^\s]*)\s(?<severity>\w)\s[/|]\s(?<source>[^\s]*[\:])[\s]*(?<message>.*[/\/n])([\W]*[\w]*){3}[\W]{3}(?<logdate>[\d]*\-[\d]*\-[\d]*)\w(?<logtime>[\d]*\:[\d]*\:[\d]*\.[\d]*)/}
      CONF_TIME_FORMAT = "%Y-%m-%d %H:%M:%S.%N"
    def configure(conf)
      conf['format_firstline'] = CONF_FORMAT_FIRSTLINE
      conf['format2'] = CONF_FORMAT2
      conf['time_format'] = CONF_TIME_FORMAT
      super
    end
  end
end
