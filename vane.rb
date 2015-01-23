#!/usr/bin/env ruby
# encoding: UTF-8
#-- 
# Vane - A WordPress vulnerability scanner

# Copyright (C) 2012-2015 WPScan Team
# Copyright (C) 2015 Delve Labs inc.

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#++

$: << '.'
require File.dirname(__FILE__) + '/lib/vane/vane_helper'
require File.dirname(__FILE__) + '/main'

main()
