# encoding: UTF-8

# Moderately complex ruby file to parser
module TheModuleName
  CONTENT_TYPES = { base: 'application/vnd.com.workday.base-v0+json',
                    service: 'application/vnd.com.workday.service-v0+json' }
  POST_CONTENT_TYPE = 'application/x-www-form-urlencoded '

  class BaseAPI
    def initialize(base_url)
      @base_url = "#{base_url}/api"
      @doc = nil
    end

    def doc
      # http_get(@base_url)
    end

    def update(resource_name, fqdn)
      fail NotImplementederror
    end

    def deploy
      fail NotImplementederror
    end
  end

  class PublicRestAPI < BaseAPI
    def deploy
      # do stuff
    end
  end

  class AuthRestAPI < BaseAPI
    def authenticate
      fail NotImplementederror
    end
  end

  class OAuthRestAPI < AuthRestAPI
    def authenticate
      # do stuff
    end
  end
end
