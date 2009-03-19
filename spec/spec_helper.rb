require 'rubygems'
require 'spec'
# require File.expand_path(File.dirname(__FILE__)) + "/../download_organizer"
Dir.glob(File.expand_path(File.dirname(__FILE__)) + "/../lib/*.rb").each{|f| require f}

Spec::Runner.configure do |config|
  # If you're not using ActiveRecord you should remove these
  # lines, delete config/database.yml and disable :active_record
  # in your config/boot.rb
  # config.use_transactional_fixtures = true
  # config.use_instantiated_fixtures  = false
  # config.fixture_path = RAILS_ROOT + '/spec/fixtures/'

  # == Fixtures
  #
  # You can declare fixtures for each example_group like this:
  #   describe "...." do
  #     fixtures :table_a, :table_b
  #
  # Alternatively, if you prefer to declare them only once, you can
  # do so right here. Just uncomment the next line and replace the fixture
  # names with your fixtures.
  #
  # config.global_fixtures = :table_a, :table_b
  #
  # If you declare global fixtures, be aware that they will be declared
  # for all of your examples, even those that don't use them.
  #
  # You can also declare which fixtures to use (for example fixtures for test/fixtures):
  #
  # config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
  #
  # == Mock Framework
  #
  # RSpec uses it's own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  #
  # == Notes
  # 
  # For more information take a look at Spec::Example::Configuration and Spec::Runner
  
end

##
# rSpec Hash additions.
#
# From 
#   * http://wincent.com/knowledge-base/Fixtures_considered_harmful%3F
#   * Neil Rahilly
class Hash
  ##
  # Filter keys out of a Hash.
  #
  #   { :a => 1, :b => 2, :c => 3 }.except(:a)
  #   => { :b => 2, :c => 3 }

  def except(*keys)
    self.reject { |k,v| keys.include?(k || k.to_sym) }
  end

  ##
  # Override some keys.
  #
  #   { :a => 1, :b => 2, :c => 3 }.with(:a => 4)
  #   => { :a => 4, :b => 2, :c => 3 }
  
  def with(overrides = {})
    self.merge overrides
  end

  ##
  # Returns a Hash with only the pairs identified by +keys+.
  #
  #   { :a => 1, :b => 2, :c => 3 }.only(:a)
  #   => { :a => 1 }
  
  def only(*keys)
    self.reject { |k,v| !keys.include?(k || k.to_sym) }
  end

end

module DownloadOrganizerSpecHelper
  def test_download_path
    File.expand_path(File.dirname(__FILE__)) + "/test_download_folder"
  end
  
  def test_music_path
    test_download_path + "/Music"
  end
  
  def test_video_path
    test_download_path + "/Video"
  end
  
  def test_torrent_path
    test_download_path + "/Torrents"
  end
  
  def test_disk_image_path
    test_download_path + "/Disk Images and Installers"
  end
  
  def test_documents_path
    test_download_path + "/Documents"
  end
  
  def test_images_path
    test_download_path + "/Images"
  end
  
  def test_archives_path
    test_download_path + "/Archives"
  end
  
  def test_misc_path
    test_download_path + "/Misc"
  end
end

# Deletes a file, checking if it exists first
def delete_if_exists(path)
  FileUtils.remove_entry_secure(path) if File.exists?(path)
end

def create_dir_unless_exists(path)
  Dir.mkdir(path) unless File.exists?(path)
end


