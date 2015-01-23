# encoding: UTF-8
#--
# WPScan - WordPress Security Scanner
# Copyright (C) 2012-2013
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#++

require File.expand_path(File.dirname(__FILE__) + '/../common/common_helper')

require_files_from_directory(VANE_LIB_DIR + '/modules')
require_files_from_directory(VANE_LIB_DIR, '**/*.rb')

# vane usage
def usage
  script_name = $0
  puts
  puts 'Examples :'
  puts
  puts '-Further help ...'
  puts "ruby #{script_name} --help"
  puts
  puts "-Do 'non-intrusive' checks ..."
  puts "ruby #{script_name} --url www.example.com"
  puts
  puts '-Do wordlist password brute force on enumerated users using 50 threads ...'
  puts "ruby #{script_name} --url www.example.com --wordlist darkc0de.lst --threads 50"
  puts
  puts "-Do wordlist password brute force on the 'admin' username only ..."
  puts "ruby #{script_name} --url www.example.com --wordlist darkc0de.lst --username admin"
  puts
  puts '-Enumerate installed plugins ...'
  puts "ruby #{script_name} --url www.example.com --enumerate p"
  puts
  puts '-Enumerate installed themes ...'
  puts "ruby #{script_name} --url www.example.com --enumerate t"
  puts
  puts '-Enumerate users ...'
  puts "ruby #{script_name} --url www.example.com --enumerate u"
  puts
  puts '-Enumerate installed timthumbs ...'
  puts "ruby #{script_name} --url www.example.com --enumerate tt"
  puts
  puts '-Use a HTTP proxy ...'
  puts "ruby #{script_name} --url www.example.com --proxy 127.0.0.1:8118"
  puts
  puts '-Use a SOCKS5 proxy ... (cURL >= v7.21.7 needed)'
  puts "ruby #{script_name} --url www.example.com --proxy socks5://127.0.0.1:9000"
  puts
  puts '-Use custom content directory ...'
  puts "ruby #{script_name} -u www.example.com --wp-content-dir custom-content"
  puts
  puts '-Use custom plugins directory ...'
  puts "ruby #{script_name} -u www.example.com --wp-plugins-dir wp-content/custom-plugins"
  puts
  puts '-Update ...'
  puts "ruby #{script_name} --update"
  puts
  puts 'See README for further information.'
  puts
end

# command help
def help
  puts 'Help :'
  puts
  puts 'Some values are settable in conf/browser.conf.json :'
  puts '  user-agent, proxy, proxy-auth, threads, cache timeout and request timeout'
  puts
  puts '--update   Update to the latest revision'
  puts '--url   | -u <target url>  The WordPress URL/domain to scan.'
  puts '--force | -f Forces Vane to not check if the remote site is running WordPress.'
  puts '--enumerate | -e [option(s)]  Enumeration.'
  puts '  option :'
  puts '    u        usernames from id 1 to 10'
  puts '    u[10-20] usernames from id 10 to 20 (you must write [] chars)'
  puts '    p        plugins'
  puts '    vp       only vulnerable plugins'
  puts '    ap       all plugins (can take a long time)'
  puts '    tt       timthumbs'
  puts '    t        themes'
  puts '    vt       only vulnerable themes'
  puts '    at       all themes (can take a long time)'
  puts '  Multiple values are allowed : "-e t,p" will enumerate timthumbs and plugins'
  puts '  If no option is supplied, the default is "vt,tt,u,vp"'
  puts
  puts '--exclude-content-based "<regexp or string>" Used with the enumeration option, will exclude all occurrences based on the regexp or string supplied'
  puts '                                             You do not need to provide the regexp delimiters, but you must write the quotes (simple or double)'
  puts '--config-file | -c <config file> Use the specified config file'
  puts '--follow-redirection  If the target url has a redirection, it will be followed without asking if you wanted to do so or not'
  puts '--wp-content-dir <wp content dir>  Vane try to find the content directory (ie wp-content) by scanning the index page, however you can specified it. Subdirectories are allowed'
  puts '--wp-plugins-dir <wp plugins dir>  Same thing than --wp-content-dir but for the plugins directory. If not supplied, Vane will use wp-content-dir/plugins. Subdirectories are allowed'
  puts '--proxy <[protocol://]host:port> Supply a proxy (will override the one from conf/browser.conf.json).'
  puts '                                 HTTP, SOCKS4 SOCKS4A and SOCKS5 are supported. If no protocol is given (format host:port), HTTP will be used'
  puts '--proxy-auth <username:password>  Supply the proxy login credentials (will override the one from conf/browser.conf.json).'
  puts '--basic-auth <username:password>  Set the HTTP Basic authentication'
  puts '--wordlist | -w <wordlist>  Supply a wordlist for the password bruter and do the brute.'
  puts '--threads  | -t <number of threads>  The number of threads to use when multi-threading requests. (will override the value from conf/browser.conf.json)'
  puts '--username | -U <username>  Only brute force the supplied username.'
  puts '--help     | -h This help screen.'
  puts '--verbose  | -v Verbose output.'
  puts
end
