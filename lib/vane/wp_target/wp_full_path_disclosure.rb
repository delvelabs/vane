# encoding: UTF-8

class WpTarget < WebSite
  module WpFullPathDisclosure

    # Check for Full Path Disclosure (FPD)
    #
    # @return [ Boolean ]
    def has_full_path_disclosure?
      response = Browser.get(full_path_disclosure_url())
      response.body[%r{Fatal error}i] ? true : false
    end

    # @return [ String ]
    def full_path_disclosure_url
      wp_uri.merge('wp-includes/rss-functions.php').to_s
    end

  end
end
