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

LIB_DIR              = File.expand_path(File.dirname(__FILE__) + '/..')
ROOT_DIR             = File.expand_path(LIB_DIR + '/..') # expand_path is used to get "vane/" instead of "vane/lib/../"
DATA_DIR             = ROOT_DIR + '/data'
CONF_DIR             = ROOT_DIR + '/conf'
CACHE_DIR            = ROOT_DIR + '/cache'
VANE_LIB_DIR         = LIB_DIR + '/vane'
VANETOOLS_LIB_DIR    = LIB_DIR + '/vanetools'
UPDATER_LIB_DIR      = LIB_DIR + '/updater'
COMMON_LIB_DIR       = LIB_DIR + '/common'
MODELS_LIB_DIR       = COMMON_LIB_DIR + '/models'
COLLECTIONS_LIB_DIR  = COMMON_LIB_DIR + '/collections'

LOG_FILE             = ROOT_DIR + '/log.txt'

# Plugins directories
COMMON_PLUGINS_DIR   = COMMON_LIB_DIR + '/plugins'
VANE_PLUGINS_DIR     = VANE_LIB_DIR + '/plugins' # Not used ATM
VANETOOLS_PLUGINS_DIR = VANETOOLS_LIB_DIR + '/plugins'

# Data files
PLUGINS_FILE        = DATA_DIR + '/plugins.txt'
PLUGINS_FULL_FILE   = DATA_DIR + '/plugins_full.txt'
PLUGINS_VULNS_FILE  = DATA_DIR + '/plugin_vulns.xml'
THEMES_FILE         = DATA_DIR + '/themes.txt'
THEMES_FULL_FILE    = DATA_DIR + '/themes_full.txt'
THEMES_VULNS_FILE   = DATA_DIR + '/theme_vulns.xml'
WP_VULNS_FILE       = DATA_DIR + '/wp_vulns.xml'
WP_VERSIONS_FILE    = DATA_DIR + '/wp_versions.xml'
LOCAL_FILES_FILE    = DATA_DIR + '/local_vulnerable_files.xml'
VULNS_XSD           = DATA_DIR + '/vuln.xsd'
WP_VERSIONS_XSD     = DATA_DIR + '/wp_versions.xsd'
LOCAL_FILES_XSD     = DATA_DIR + '/local_vulnerable_files.xsd'

VANE_VERSION       = '2.1'

$LOAD_PATH.unshift(LIB_DIR)
$LOAD_PATH.unshift(VANE_LIB_DIR)
$LOAD_PATH.unshift(MODELS_LIB_DIR)

require 'environment'

# TODO : add an exclude pattern ?
def require_files_from_directory(absolute_dir_path, files_pattern = '*.rb')
  files = Dir[File.join(absolute_dir_path, files_pattern)]

  # Files in the root dir are loaded first, then thoses in the subdirectories
  files.sort_by { |file| [file.count("/"), file] }.each do |f|
    f = File.expand_path(f)
    #puts "require #{f}" # Used for debug
    require f
  end
end

require_files_from_directory(COMMON_LIB_DIR, '**/*.rb')

# Add protocol
def add_http_protocol(url)
  url =~ /^https?:/ ? url : "http://#{url}"
end

def add_trailing_slash(url)
  url =~ /\/$/ ? url : "#{url}/"
end

# loading the updater
require_files_from_directory(UPDATER_LIB_DIR)
@updater = UpdaterFactory.get_updater(ROOT_DIR)

if @updater
  REVISION = @updater.local_revision_number()
else
  REVISION = 'NA'
end

# our 1337 banner
def banner
  puts 'Vane - a Free WordPress vulnerability scanner'
end

def colorize(text, color_code)
  "\e[#{color_code}m#{text}\e[0m"
end

def red(text)
  colorize(text, 31)
end

def green(text)
  colorize(text, 32)
end

def xml(file)
  Nokogiri::XML(File.open(file)) do |config|
    config.noblanks
  end
end
