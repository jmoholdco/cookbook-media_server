module GitHubAPI
  class Nzbget
    attr_reader :auth, :stable_release
    def initialize
      self.class.send(:include, HTTParty)
      self.class.send(:base_uri, 'https://api.github.com')
      @auth = {
        query: { access_token: 'a02d11cc9fdbfc30918ecb9b4258bb946c6cd97d' }
      }
    end

    def stable_release
      @stable_release ||= safe_get('/repos/nzbget/nzbget/releases/latest', auth)
    end

    def checksums
      @checksums ||= rawsums.scan(/^"SHA256\((.+)\)"\s:\s"([0-9a-f]*)",/).to_h
    end

    def latest_stable
      stable_release['tarball_url']
    end

    def latest_testing
      res = self.class.get('/repos/nzbget/nzbget/releases', auth)
      res.first['tarball_url'] if res.success?
    end

    def repo_url
      'https://github.com/nzbget/nzbget'
    end

    def find(release_type)
      case release_type
      when 'git' then repo_url
      when 'testing' then latest_testing
      when 'stable' then latest_stable
      else repo_url
      end
    end

    def self.find(release_type)
      new.find(release_type)
    end

    private

    def rawsums
      res = HTTParty.get(checksum_asset['browser_download_url'])
      return nil unless res.success?
      res.body
    end

    def checksum_asset
      stable_release['assets'].find { |asset| asset['name'] =~ /sig/i }
    end

    def safe_get(url, query)
      res = self.class.get(url, query)
      res if res.success?
    end
  end
end
