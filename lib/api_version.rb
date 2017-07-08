class ApiVersion
  attr_reader :version, :default

  def initialize(options)
    @version = options[:version]
    @default = options[:default]
  end

  # check whether version is specified or is default
  def matches?(request)
    check_headers(request.headers) || default
  end

  private

  def check_headers(headers)
    # check version from Accept headers; expect custom media type `todos`
    accept = headers[:Accept]
    accept && accept.include?("application/api.revocation.#{version}+json")
  end
end
