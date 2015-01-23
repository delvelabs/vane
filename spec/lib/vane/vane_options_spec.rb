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

require File.expand_path(File.dirname(__FILE__) + '/vane_helper')

describe 'VaneOptions' do

  before :each do
    @vane_options = VaneOptions.new
  end

  describe '#initialize' do
    it 'should set all options to nil' do
      VaneOptions::ACCESSOR_OPTIONS.each do |option|
        @vane_options.send(option).should === nil
      end
    end
  end

  describe '#url=' do
    it 'should raise an error if en empty or nil url is supplied' do
      expect { @vane_options.url = '' }.to raise_error
      expect { @vane_options.url = nil }.to raise_error
    end

    it 'should add the http protocol if not present' do
      @vane_options.url = 'example.com'
      @vane_options.url.should === 'http://example.com'
    end

    it "should not add the http protocol if it's already present" do
      url = 'http://example.com'
      @vane_options.url = url
      @vane_options.url.should === url
    end
  end

  describe '#threads=' do
    it 'should convert an integer in a string into an integr' do
      @vane_options.threads = '10'
      @vane_options.threads.should be_an Integer
      @vane_options.threads.should === 10
    end

    it 'should set to correct number of threads' do
      @vane_options.threads = 15
      @vane_options.threads.should be_an Integer
      @vane_options.threads.should === 15
    end
  end

  describe '#wordlist=' do
    it 'should raise an error if the wordlist file does not exist' do
      expect { @vane_options.wordlist = '/i/do/not/exist.txt' }.to raise_error
    end

    it 'should not raise an error' do
      wordlist_file = "#{SPEC_FIXTURES_VANE_VANE_OPTIONS_DIR}/wordlist.txt"

      @vane_options.wordlist = wordlist_file
      @vane_options.wordlist.should === wordlist_file
    end
  end

  describe '#proxy=' do
    it 'should raise an error' do
      expect { @vane_options.proxy = 'invalidproxy' }.to raise_error
    end

    it 'should not raise an error' do
      proxy = '127.0.0.1:3038'
      @vane_options.proxy = proxy
      @vane_options.proxy.should === proxy
    end
  end

  describe '#proxy_auth=' do
    it 'should raise an error if the format is not correct' do
      expect { @vane_options.proxy_auth = 'invalidauth' }.to raise_error
    end

    it 'should not raise en error' do
      proxy_auth = 'user:pass'
      @vane_options.proxy_auth = proxy_auth
      @vane_options.proxy_auth.should === proxy_auth
    end
  end

  describe '#enumerate_plugins=' do
    it 'should raise an error' do
      @vane_options.enumerate_only_vulnerable_plugins = true
      expect { @vane_options.enumerate_plugins = true }.to raise_error(
        RuntimeError, 'Please choose only one plugin enumeration option'
      )
    end

    it 'should not raise an error' do
      @vane_options.enumerate_only_vulnerable_plugins = false
      @vane_options.enumerate_plugins = true

      @vane_options.enumerate_plugins.should be_true
    end
  end

  describe '#enumerate_themes=' do
    it 'should raise an error' do
      @vane_options.enumerate_only_vulnerable_themes = true
      expect { @vane_options.enumerate_themes = true }.to raise_error(
        RuntimeError, 'Please choose only one theme enumeration option'
      )
    end

    it 'should not raise an error' do
      @vane_options.enumerate_only_vulnerable_themes = false
      @vane_options.enumerate_themes = true

      @vane_options.enumerate_themes.should be_true
    end
  end

  describe '#enumerate_only_vulnerable_plugins=' do
    it 'should raise an error' do
      @vane_options.enumerate_plugins = true
      expect { @vane_options.enumerate_only_vulnerable_plugins = true }.to raise_error(
        RuntimeError, 'Please choose only one plugin enumeration option'
      )
    end

    it 'should not raise an error' do
      @vane_options.enumerate_plugins = false
      @vane_options.enumerate_only_vulnerable_plugins = true

      @vane_options.enumerate_only_vulnerable_plugins.should be_true
    end
  end

  describe '#enumerate_only_vulnerable_themes=' do
    it 'should raise an error' do
      @vane_options.enumerate_themes = true
      expect { @vane_options.enumerate_only_vulnerable_themes = true }.to raise_error(
        RuntimeError, 'Please choose only one theme enumeration option'
      )
    end

    it 'should not raise an error' do
      @vane_options.enumerate_themes = false
      @vane_options.enumerate_only_vulnerable_themes = true

      @vane_options.enumerate_only_vulnerable_themes.should be_true
    end
  end

  describe '#enumerate_all_themes=' do
    it 'should raise an error' do
      @vane_options.enumerate_themes = true
      expect { @vane_options.enumerate_all_themes = true }.to raise_error(
        RuntimeError, 'Please choose only one theme enumeration option'
      )
    end

    it 'should not raise an error' do
      @vane_options.enumerate_themes = false
      @vane_options.enumerate_all_themes = true

      @vane_options.enumerate_all_themes.should be_true
    end
  end

  describe '#enumerate_all_plugins=' do
    it 'should raise an error' do
      @vane_options.enumerate_plugins = true
      expect { @vane_options.enumerate_all_plugins = true }.to raise_error(
        RuntimeError, 'Please choose only one plugin enumeration option'
      )
    end

    it 'should not raise an error' do
      @vane_options.enumerate_plugins = false
      @vane_options.enumerate_all_plugins = true

      @vane_options.enumerate_all_plugins.should be_true
    end
  end

  describe '#basic_auth=' do
    context 'invalid format' do
      it 'should raise an error if the : is missing' do
        expect { @vane_options.basic_auth = 'helloworld' }.to raise_error(
          RuntimeError, 'Invalid basic authentication format, login:password expected'
        )
      end
    end

    context 'valid format' do
      it "should add the 'Basic' word and do the encode64. See RFC 2617" do
        @vane_options.basic_auth = 'Aladdin:open sesame'
        @vane_options.basic_auth.should == 'Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ=='
      end
    end
  end

  describe '#has_options?' do
    it 'should return false' do
      @vane_options.has_options?.should be_false
    end

    it 'should return true' do
      @vane_options.verbose = false
      @vane_options.has_options?.should be_true
    end
  end

  describe '#to_h' do
    it 'should return an empty hash' do
      @vane_options.to_h.should be_a Hash
      @vane_options.to_h.should be_empty
    end

    it 'should return a hash with :verbose = true' do
      expected = {verbose: true}
      @vane_options.verbose = true

      @vane_options.to_h.should === expected
    end
  end

  describe '#clean_option' do
    after :each do
      VaneOptions.clean_option(@option).should === @expected
    end

    it "should return 'url'" do
      @option = '--url'
      @expected = 'url'
    end

    it "should return 'u'" do
      @option = '-u'
      @expected = 'u'
    end

    it "should return 'follow_redirection'" do
      @option = '--follow-redirection'
      @expected = 'follow_redirection'
    end
  end

  describe '#option_to_instance_variable_setter' do
    after :each do
      VaneOptions.option_to_instance_variable_setter(@argument).should === @expected
    end

    it 'should return :url=' do
      @argument = '--url'
      @expected = :url=
    end

    it 'should return :verbose=' do
      @argument = '--verbose'
      @expected = :verbose=
    end

    it 'should return :proxy= for --proxy' do
      @argument = '--proxy'
      @expected = :proxy=
    end

    it 'should return nil for --enumerate' do
      @argument = '--enumerate'
      @expected = nil
    end

    it 'should return :proxy_auth= for --proxy_auth' do
      @argument = '--proxy_auth'
      @expected = :proxy_auth=
    end
  end

  describe '#is_long_option?' do
    it 'should return true' do
      VaneOptions.is_long_option?('--url').should be_true
    end

    it 'should return false' do
      VaneOptions.is_long_option?('hello').should be_false
      VaneOptions.is_long_option?('--enumerate').should be_false
    end
  end

  describe '#enumerate_options_from_string' do
    after :each do
      if @argument
        vane_options = VaneOptions.new
        vane_options.enumerate_options_from_string(@argument)
        vane_options.to_h.should === @expected_hash
      end
    end

    it 'should raise an error if p and p! are ' do
      expect { @vane_options.enumerate_options_from_string('p,vp') }.to raise_error
    end

    it 'should set enumerate_plugins to true' do
      @argument = 'p'
      @expected_hash = {enumerate_plugins: true}
    end

    it 'should set enumerate_only_vulnerable_plugins to tue' do
      @argument = 'vp'
      @expected_hash = {enumerate_only_vulnerable_plugins: true}
    end

    it 'should set enumerate_timthumbs to true' do
      @argument = 'tt'
      @expected_hash = {enumerate_timthumbs: true}
    end

    it 'should set enumerate_usernames to true' do
      @argument = 'u'
      @expected_hash = {enumerate_usernames: true}
    end

    it 'should set enumerate_usernames to true and enumerate_usernames_range to (1..20)' do
      @argument = 'u[1-20]'
      @expected_hash = {enumerate_usernames: true, enumerate_usernames_range: (1..20)}
    end

    # Let's try some multiple choices
    it 'should set enumerate_timthumbs to true, enumerate_usernames to true, enumerate_usernames_range to (1..2)' do
      @argument = 'u[1-2],tt'
      @expected_hash = {
        enumerate_usernames: true, enumerate_usernames_range: (1..2),
        enumerate_timthumbs: true
      }
    end
  end

  describe '#set_option_from_cli' do
    it 'should raise an error with unknow option' do
      expect { @vane_options.set_option_from_cli('hello', '') }.to raise_error
    end

    it 'should set @url to example.com' do
      @vane_options.set_option_from_cli('--url', 'example.com')
      @vane_options.url.should === 'http://example.com'
    end

    it 'should set @enumerate_plugins to true' do
      @vane_options.set_option_from_cli('--enumerate', 'p')
      @vane_options.enumerate_plugins.should be_true
      @vane_options.enumerate_only_vulnerable_plugins.should be_nil
    end

    it 'should set @enumerate_only_vulnerable_plugins, @enumerate_timthumbs and @enumerate_usernames to true if no argument is given' do
      @vane_options.set_option_from_cli('--enumerate', '')
      @vane_options.enumerate_only_vulnerable_plugins.should be_true
      @vane_options.enumerate_timthumbs.should be_true
      @vane_options.enumerate_usernames.should be_true
    end
  end

  describe '#load_from_arguments' do
    after :each do
      set_argv(@argv)
      vane_options = VaneOptions.load_from_arguments
      vane_options.to_h.should === @expected_hash
    end

    it 'should return {}' do
      @argv = ''
      @expected_hash = {}
    end

    it "should return {:url => 'example.com'}" do
      @argv = '--url example.com'
      @expected_hash = { url: 'http://example.com' }
    end

    it "should return {:url => 'example.com'}" do
      @argv = '-u example.com'
      @expected_hash = { url: 'http://example.com' }
    end

    it "should return {:username => 'admin'}" do
      @argv = '--username admin'
      @expected_hash = { username: 'admin' }
    end

    it "should return {:username => 'Youhou'}" do
      @argv = '-U Youhou'
      @expected_hash = { username: 'Youhou' }
    end

    it "should return {:url => 'example.com', :threads => 5, :force => ''}" do
      @argv = '-u example.com --force -t 5'
      @expected_hash = { url: 'http://example.com', threads: 5, force: '' }
    end

    it "should return {:url => 'example.com', :enumerate_plugins => true, :enumerate_timthumbs => true}" do
      @argv = '-u example.com -e p,tt'
      @expected_hash = { url: 'http://example.com', enumerate_plugins: true, enumerate_timthumbs: true }
    end
  end

end
