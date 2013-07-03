# Load files in lib/ even if they reopen existing classes.
#
Dir[Rails.root + 'lib/**/*.rb'].each do |file|
  require file
end
