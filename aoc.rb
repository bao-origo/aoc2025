require 'net/http'
require 'uri'
require 'json'

module AOC
  def self.read(day)
    cache = {}
    file_path = 'inputs.json'
    if File.exist?(file_path)
      json_data = File.read(file_path)
      cache = JSON.parse(json_data)
      value = cache[day.to_s]
      if value
        return value
      end
    end

    url = URI.parse("https://adventofcode.com/2025/day/#{day}/input")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url.request_uri)

    session_cookie = ENV['AOC_SESSION']
    if session_cookie
      request['Cookie'] = session_cookie
    else
      puts "Error: AOC_SESSION environment variable is not set."
      return nil
    end

    response = http.request(request)

    if response.is_a?(Net::HTTPSuccess)
      cache[day.to_s] = response.body
      File.write(file_path, JSON.pretty_generate(cache))
      response.body
    else
      raise "Error fetching input: #{response.code} #{response.message}"
    end
  end
end
