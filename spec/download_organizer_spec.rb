require File.expand_path(File.dirname(__FILE__)) + "/spec_helper"

include DownloadOrganizerSpecHelper

describe DownloadOrganizer, "#initialize(path_to_download_folder)" do
  
  before(:each) do
    @path_to_download = test_download_path
    @do = DownloadOrganizer.new(@path_to_download)
  end
  
  it "should create a new DownloadOrganizer" do
    @do.should be_an_instance_of(DownloadOrganizer)
  end
  
  it "should set the path of the download folder" do
    @do.download_path.should eql(@path_to_download)
  end
  
  # it "should initilize the current directory to the download folder" do
  #   @do.current_directory.should eql(@path_to_download)
  # end
  
  it "should include FileUtils module" do
    @do.should be_kind_of(FileUtils)
  end
  
end

describe DownloadOrganizer, "handling music files" do
  before(:each) do
    @do = DownloadOrganizer.new(test_download_path)
  end
  
  describe "when and mp3 is encountered" do
    before(:each) do
      @file_name = "temp.mp3"
      @file = File.new("#{test_download_path}/#{@file_name}", "w")
    end
    
    after(:each) do
      FileUtils.remove_entry_secure(test_music_path)
    end
    
    it "should create a new 'Music' folder if one does not exist" do
      File.exists?(test_music_path).should be_false
      @do.sort_files
      File.exists?(test_music_path).should be_true
      File.directory?(test_music_path).should be_true
    end
    
    it "should copy the mp3 into the Music folder" do
      old_path = "#{test_download_path}/#{@file_name}"
      new_path = "#{test_download_path}/Music/#{@file_name}"
      File.exists?(old_path).should be_true
      @do.sort_files
      File.exists?(old_path).should be_false
      File.exists?(new_path).should be_true
    end    
  end
end

describe DownloadOrganizer, "handling files beginning with . " do
  it "should ignore them"
end

describe "video files" do
  it "should handle several forms of video files"
end

describe "torrent files" do
  it "should handle torrent files"
end

describe "dmg files" do
  it "should handle dmg files"
end