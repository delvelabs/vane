# encoding: UTF-8

require File.expand_path(File.dirname(__FILE__) + '/vane_helper')

describe 'VaneOptions' do

  before :each do
    @vane_options = VaneOptions.new
  end

  describe '#initialize' do
    it 'should set all options to nil' do
      VaneOptions::ACCESSOR_OPTIONS.each do |option|
        expect(@vane_options.send(option)).to be === nil
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
      expect(@vane_options.url).to be === 'http://example.com'
    end

    it "should not add the http protocol if it's already present" do
      url = 'http://example.com'
      @vane_options.url = url
      expect(@vane_options.url).to be === url
    end

    it 'should encode IDN' do
      @vane_options.url = 'http://пример.испытание/'
      expect(@vane_options.url).to be === 'http://xn--e1afmkfd.xn--80akhbyknj4f/'
    end
  end

  describe '#threads=' do
    it 'should convert an integer in a string into an integr' do
      @vane_options.threads = '10'
      expect(@vane_options.threads).to be_an Integer
      expect(@vane_options.threads).to be === 10
    end

    it 'should set to correct number of threads' do
      @vane_options.threads = 15
      expect(@vane_options.threads).to be_an Integer
      expect(@vane_options.threads).to be === 15
    end
  end

  describe '#wordlist=' do
    it 'should raise an error if the wordlist file does not exist' do
      expect { @vane_options.wordlist = '/i/do/not/exist.txt' }.to raise_error
    end

    it 'should not raise an error' do
      wordlist_file = "#{SPEC_FIXTURES_VANE_VANE_OPTIONS_DIR}/wordlist.txt"

      @vane_options.wordlist = wordlist_file
      expect(@vane_options.wordlist).to be === wordlist_file
    end
  end

  describe '#proxy=' do
    it 'should raise an error' do
      expect { @vane_options.proxy = 'invalidproxy' }.to raise_error
    end

    it 'should not raise an error' do
      proxy = '127.0.0.1:3038'
      @vane_options.proxy = proxy
      expect(@vane_options.proxy).to be === proxy
    end
  end

  describe '#proxy_auth=' do
    it 'should raise an error if the format is not correct' do
      expect { @vane_options.proxy_auth = 'invalidauth' }.to raise_error
    end

    it 'should not raise en error' do
      proxy_auth = 'user:pass'
      @vane_options.proxy_auth = proxy_auth
      expect(@vane_options.proxy_auth).to be === proxy_auth
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

      expect(@vane_options.enumerate_plugins).to be_truthy
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

      expect(@vane_options.enumerate_themes).to be_truthy
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

      expect(@vane_options.enumerate_only_vulnerable_plugins).to be_truthy
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

      expect(@vane_options.enumerate_only_vulnerable_themes).to be_truthy
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

      expect(@vane_options.enumerate_all_themes).to be_truthy
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

      expect(@vane_options.enumerate_all_plugins).to be_truthy
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
        expect(@vane_options.basic_auth).to eq 'Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ=='
      end
    end
  end

  describe '#has_options?' do
    it 'should return false' do
      expect(@vane_options.has_options?).to be_falsey
    end

    it 'should return true' do
      @vane_options.verbose = false
      expect(@vane_options.has_options?).to be_truthy
    end
  end

  describe '#to_h' do
    it 'should return an empty hash' do
      expect(@vane_options.to_h).to be_a Hash
      expect(@vane_options.to_h).to be_empty
    end

    it 'should return a hash with :verbose = true' do
      expected = {verbose: true}
      @vane_options.verbose = true

      expect(@vane_options.to_h).to be === expected
    end
  end

  describe '#clean_option' do
    after :each do
      expect(VaneOptions.clean_option(@option)).to be === @expected
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
      expect(VaneOptions.option_to_instance_variable_setter(@argument)).to be === @expected
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
      expect(VaneOptions.is_long_option?('--url')).to be_truthy
    end

    it 'should return false' do
      expect(VaneOptions.is_long_option?('hello')).to be_falsey
      expect(VaneOptions.is_long_option?('--enumerate')).to be_falsey
    end
  end

  describe '#enumerate_options_from_string' do
    after :each do
      if @argument
        vane_options = VaneOptions.new
        vane_options.enumerate_options_from_string(@argument)
        expect(vane_options.to_h).to be === @expected_hash
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
      expect(@vane_options.url).to be === 'http://example.com'
    end

    it 'should set @enumerate_plugins to true' do
      @vane_options.set_option_from_cli('--enumerate', 'p')
      expect(@vane_options.enumerate_plugins).to be_truthy
      expect(@vane_options.enumerate_only_vulnerable_plugins).to be_nil
    end

    it 'should set @enumerate_only_vulnerable_plugins, @enumerate_timthumbs and @enumerate_usernames to true if no argument is given' do
      @vane_options.set_option_from_cli('--enumerate', '')
      expect(@vane_options.enumerate_only_vulnerable_plugins).to be_truthy
      expect(@vane_options.enumerate_timthumbs).to be_truthy
      expect(@vane_options.enumerate_usernames).to be_truthy
    end
  end

  describe '#load_from_arguments' do
    after :each do
      set_argv(@argv)
      vane_options = VaneOptions.load_from_arguments
      expect(vane_options.to_h).to be === @expected_hash
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
