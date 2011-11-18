module Trackerific
  # Raised if something other than tracking information is returned.
  class UnknownPackageId < RuntimeError ; end

  class ServiceError < RuntimeError ; end
end
