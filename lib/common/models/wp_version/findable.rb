# encoding: UTF-8

class WpVersion < WpItem

  module Findable

    # Find the version of the blog designated from target_uri
    #
    # @param [ URI ] target_uri
    # @param [ String ] wp_content_dir
    # @param [ String ] wp_plugins_dir
    #
    # @return [ WpVersion ]
    def find(target_uri, wp_content_dir, wp_plugins_dir, versions_xml)
      methods.grep(/^find_from_/).each do |method|

        if method === :find_from_advanced_fingerprinting
          version = send(method, target_uri, wp_content_dir, wp_plugins_dir, versions_xml)
        else
          version = send(method, target_uri)
        end

        if version
          return new(target_uri, number: version, found_from: method)
        end
      end
      nil
    end

    # Used to check if the version is correct: must contain at least one dot.
    #
    # @return [ String ]
    def version_pattern
      '([^\r\n"\']+\.[^\r\n"\']+)'
    end

    protected

    # Returns the first match of <pattern> in the body of the url
    #
    # @param [ URI ] target_uri
    # @param [ Regex ] pattern
    # @param [ String ] path
    #
    # @return [ String ]
    def scan_url(target_uri, pattern, path = nil)
      url = path ? target_uri.merge(path).to_s : target_uri.to_s
      response = Browser.get_and_follow_location(url)

      response.body[pattern, 1]
    end

    #
    # DO NOT Change the order of the following methods
    # unless you know what you are doing
    # See WpVersion.find
    #

    # Attempts to find the wordpress version from,
    # the generator meta tag in the html source.
    #
    # The meta tag can be removed however it seems,
    # that it is reinstated on upgrade.
    #
    # @param [ URI ] target_uri
    #
    # @return [ String ] The version number
    def find_from_meta_generator(target_uri)
      scan_url(
        target_uri,
        %r{name="generator" content="wordpress #{version_pattern}"}i
      )
    end

    # Attempts to find the WordPress version from,
    # the generator tag in the RSS feed source.
    #
    # @param [ URI ] target_uri
    #
    # @return [ String ] The version number
    def find_from_rss_generator(target_uri)
      scan_url(
        target_uri,
        %r{<generator>http://wordpress.org/\?v=#{version_pattern}</generator>}i,
        'feed/'
      )
    end

    # Attempts to find WordPress version from,
    # the generator tag in the RDF feed source.
    #
    # @param [ URI ] target_uri
    #
    # @return [ String ] The version number
    def find_from_rdf_generator(target_uri)
      scan_url(
        target_uri,
        %r{<admin:generatorAgent rdf:resource="http://wordpress.org/\?v=#{version_pattern}" />}i,
        'feed/rdf/'
      )
    end

    # Attempts to find the WordPress version from,
    # the generator tag in the Atom source.
    #
    # @param [ URI ] target_uri
    #
    # @return [ String ] The version number
    def find_from_atom_generator(target_uri)
      scan_url(
        target_uri,
        %r{<generator uri="http://wordpress.org/" version="#{version_pattern}">WordPress</generator>}i,
        'feed/atom/'
      )
    end

    def find_from_stylesheets_numbers(target_uri)
      wp_versions = WpVersion.all
      found       = {}
      pattern     = /\bver=([0-9\.]+)/i

      Nokogiri::HTML(Browser.get(target_uri.to_s).body).css('link,script').each do |tag|
        %w(href src).each do |attribute|
          attr_value = tag.attribute(attribute).to_s

          next if attr_value.nil? || attr_value.empty?

          uri = Addressable::URI.parse(attr_value)
          next unless uri.query && uri.query.match(pattern)

          version = Regexp.last_match[1].to_s

          found[version] ||= 0
          found[version] += 1
        end
      end

      found.delete_if { |v, _| !wp_versions.include?(v) }

      best_guess = found.sort_by(&:last).last
      # best_guess[0]: version number, [1] numbers of occurences
      best_guess && best_guess[1] > 1 ? best_guess[0] : nil
    end

    # Uses data/wp_versions.xml to try to identify a
    # wordpress version.
    #
    # It does this by using client side file hashing
    #
    # /!\ Warning : this method might return false positive if the file used for fingerprinting is part of a theme (they can be updated)
    #
    # @param [ URI ] target_uri
    # @param [ String ] wp_content_dir
    # @param [ String ] wp_plugins_dir
    # @param [ String ] versions_xml The path to the xml containing all versions
    #
    # @return [ String ] The version number
    def find_from_advanced_fingerprinting(target_uri, wp_content_dir, wp_plugins_dir, versions_xml)
      xml     = xml(versions_xml)

      # This wp_item will take care of encoding the path
      # and replace variables like $wp-content$ & $wp-plugins$
      wp_item = WpItem.new(target_uri,
                           wp_content_dir: wp_content_dir,
                           wp_plugins_dir: wp_plugins_dir)

      xml.xpath('//file').each do |node|
        wp_item.path = node.attribute('src').text

        response = Browser.get(wp_item.url)
        md5sum = Digest::MD5.hexdigest(response.body)
        sha256sum = Digest::SHA256.hexdigest(response.body)

        node.search('hash').each do |hash|
          md5node = hash.attribute('md5')
          sha256node = hash.attribute('sha256')
          if sha256node and sha256node.text == sha256sum
            return hash.search('version').text
          elsif md5node and md5node.text == md5sum
            return hash.search('version').text
          end
        end
      end
      nil
    end

    # Attempts to find the WordPress version from the readme.html file.
    #
    # @param [ URI ] target_uri
    #
    # @return [ String ] The version number
    def find_from_readme(target_uri)
      scan_url(
        wp_url.to_s,
        %r{<br />\sversion #{version_pattern}}i,
        'readme.html'
      )
    end

    # Attempts to find the WordPress version from the sitemap.xml file.
    #
    # @param [ URI ] target_uri
    #
    # @return [ String ] The version number
    def find_from_sitemap_generator(target_uri)
      scan_url(
        target_uri,
        %r{generator="wordpress/#{version_pattern}"}i,
        'sitemap.xml'
      )
    end

    # Attempts to find the WordPress version from the p-links-opml.php file.
    #
    # @param [ URI ] target_uri
    #
    # @return [ String ] The version number
    def find_from_links_opml(target_uri)
      scan_url(
        target_uri,
        %r{generator="wordpress/#{version_pattern}"}i,
        'wp-links-opml.php'
      )
    end

  end
end
