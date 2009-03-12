require File.expand_path(File.dirname(__FILE__)) + "/spec_helper"

include DownloadOrganizerSpecHelper

describe DownloadOrganizer do
  
  before(:all) do
    delete_if_exists(test_download_path)
    create_dir_unless_exists(test_download_path)
  end
  
  after(:all) do
    delete_if_exists(test_download_path)
  end

  describe "#initialize(path_to_download_folder)" do
    
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
  
    it "should include FileUtils module" do
      @do.should be_kind_of(FileUtils)
    end
  
  end

  describe "handling files beginning with . " do
    before(:each) do
      @do = DownloadOrganizer.new(test_download_path)
      @file_path = "#{test_download_path}/.TEMP"
      @file = File.new(@file_path, "w")
    end
  
    after(:each) do
      FileUtils.remove_entry_secure(@file_path)
    end
  
    it "should ignore the file, leaving it's original location" do
      File.exists?(@file_path).should be_true
      @do.sort_files
      File.exists?(@file_path).should be_true
    end
  end

  describe "handling music files" do
    before(:each) do
      @do = DownloadOrganizer.new(test_download_path)
    end
  
    describe "when and mp3 is encountered" do
      before(:each) do
        @file_name = "temp.mp3"
        @original_file_path = "#{test_download_path}/#{@file_name}"
        @file = File.new(@original_file_path, "w")
      end
    
      after(:each) do
        FileUtils.remove_entry_secure(test_music_path)
        delete_if_exists(@original_file_path)
      end
    
      it "should create a new 'Music' folder if one does not exist" do
        File.exists?(test_music_path).should be_false
        @do.sort_files
        File.exists?(test_music_path).should be_true
        File.directory?(test_music_path).should be_true
      end
    
      it "should move the mp3 into the Music folder" do
        old_path = "#{test_download_path}/#{@file_name}"
        new_path = "#{test_download_path}/Music/#{@file_name}"
        File.exists?(old_path).should be_true
        @do.sort_files
        File.exists?(old_path).should be_false
        File.exists?(new_path).should be_true
      end    
    end
  
  end

  describe "recognzied music types" do
    it "should recognize .mp3" do
      ".mp3".should match(DownloadOrganizer::MUSIC_EXTENSIONS)
    end
  
    it "should recognize .m3u" do
      ".m3u".should match(DownloadOrganizer::MUSIC_EXTENSIONS)
    end
  
    it "should recoginze .wav" do
      ".wav".should match(DownloadOrganizer::MUSIC_EXTENSIONS)
    end
  end

  describe "handling video files" do
    before(:each) do
      @do = DownloadOrganizer.new(test_download_path)
      @file_name = "video.avi"
      @file_path = "#{test_download_path}/#{@file_name}" # all recognized video types (below) will behave like .avi
      @file = File.new(@file_path, "w")
    end
  
    after(:each) do
      delete_if_exists(test_video_path)
      delete_if_exists(@file_path)
    end
  
    it "should create a 'Videos' folder if one does not exist" do
      File.exists?(test_video_path).should be_false
      @do.sort_files
      File.exists?(test_video_path).should be_true
      File.directory?(test_video_path).should be_true
    end
  
    it "should move the video into the Video folder" do
      old_path = @file_path
      new_path = "#{test_download_path}/Video/#{@file_name}"
      File.exists?(old_path).should be_true
      @do.sort_files
      File.exists?(old_path).should be_false
      File.exists?(new_path).should be_true
    end
  
  end

  describe "recognized video types" do
    it "should recognize .avi" do
      ".avi".should match(DownloadOrganizer::VIDEO_EXTENSIONS)
    end
  
    it "should recognize .mpeg" do
      ".mpeg".should match(DownloadOrganizer::VIDEO_EXTENSIONS)
    end
  
    it "should recognize .mov" do
      ".mov".should match(DownloadOrganizer::VIDEO_EXTENSIONS)
    end
  
    it "should recognize .VOB" do
      ".VOB".should match(DownloadOrganizer::VIDEO_EXTENSIONS)
    end
  end

  describe "handling torrent files" do
    before(:each) do
      @do = DownloadOrganizer.new(test_download_path)
      @file_name = "download.torrent"
      @file_path = "#{test_download_path}/#{@file_name}" # all recognized torrent types (below) will behave like .torrent
      @file = File.new(@file_path, "w")
    end
  
    after(:each) do
      FileUtils.remove_entry_secure(test_torrent_path)
    end
  
    it "should create a 'Torrents' folder if one does not exist" do
      File.exists?(test_torrent_path).should be_false
      @do.sort_files
      File.exists?(test_torrent_path).should be_true
      File.directory?(test_torrent_path).should be_true
    end
  
    it "should move the torrent into the Torrent folder" do
      old_path = @file_path
      new_path = "#{test_download_path}/Torrents/#{@file_name}"
      File.exists?(old_path).should be_true
      @do.sort_files
      File.exists?(old_path).should be_false
      File.exists?(new_path).should be_true
    end
  end

  describe "recognized torrent types" do
    it "should recognize .torrent" do
      ".torrent".should match(DownloadOrganizer::TORRENT_EXTENSIONS)
    end
  end

  describe "handling dmg files" do
    before(:each) do
      @do = DownloadOrganizer.new(test_download_path)
      @file_name = "download.dmg"
      @file_path = "#{test_download_path}/#{@file_name}" # all recognized disk_image types (below) will behave like .dmg
      @file = File.new(@file_path, "w")
    end
  
    after(:each) do
      FileUtils.remove_entry_secure(test_disk_image_path)
    end
  
    it "should create a 'Disk Images and Installers' folder if one does not exist" do
      File.exists?(test_disk_image_path).should be_false
      @do.sort_files
      File.exists?(test_disk_image_path).should be_true
      File.directory?(test_disk_image_path).should be_true
    end
  
    it "should move the file into the 'Disk Images and Installers' folder" do
      old_path = @file_path
      new_path = "#{test_download_path}/Disk Images and Installers/#{@file_name}"
      File.exists?(old_path).should be_true
      @do.sort_files
      File.exists?(old_path).should be_false
      File.exists?(new_path).should be_true
    end
  end

  describe "recognized disk image and installer types" do
    it "should recognize .dmg" do
      ".dmg".should match(DownloadOrganizer::DISK_IMAGE_EXTENSIONS)
    end
  
    it "should recognize .iso" do
      ".iso".should match(DownloadOrganizer::DISK_IMAGE_EXTENSIONS)
    end
  
    it "should recognize .pkg" do
      ".pkg".should match(DownloadOrganizer::DISK_IMAGE_EXTENSIONS)
    end
  end

  describe "handling documents" do
    before(:each) do
      @do = DownloadOrganizer.new(test_download_path)
      @file_name = "document.pdf"
      @file_path = "#{test_download_path}/#{@file_name}" # all recognized document types (below) will behave like .pdf
      @file = File.new(@file_path, "w")
    end
  
    after(:each) do
      FileUtils.remove_entry_secure(test_documents_path)
      delete_if_exists(@file_path)
    end
  
    it "should create a 'Documents' folder if one does not exist" do
      File.exists?(test_documents_path).should be_false
      @do.sort_files
      File.exists?(test_documents_path).should be_true
      File.directory?(test_documents_path).should be_true
    end
  
    it "should move the file into the Documents folder" do
      old_path = @file_path
      new_path = "#{test_download_path}/Documents/#{@file_name}"
      File.exists?(old_path).should be_true
      @do.sort_files
      File.exists?(old_path).should be_false
      File.exists?(new_path).should be_true
    end
  end

  describe "recognized document types" do
    it "should recognize .pdf" do
      ".pdf".should match(DownloadOrganizer::DOCUMENT_EXTENSIONS)
    end
  
    it "should recognize .doc" do
      ".doc".should match(DownloadOrganizer::DOCUMENT_EXTENSIONS)
    end
  
    it "should recognize .xls" do
      ".xls".should match(DownloadOrganizer::DOCUMENT_EXTENSIONS)
    end
  end

  describe "image files" do
    before(:each) do
      @do = DownloadOrganizer.new(test_download_path)
      @file_name = "image.jpg"
      @file_path = "#{test_download_path}/#{@file_name}" # all recognized image types (below) will behave like .jpg
      @file = File.new(@file_path, "w")
    end
  
    after(:each) do
      FileUtils.remove_entry_secure(test_images_path)
      delete_if_exists(@file_path)
    end
  
    it "should create a 'Images' folder if one does not exist" do
      File.exists?(test_images_path).should be_false
      @do.sort_files
      File.exists?(test_images_path).should be_true
      File.directory?(test_images_path).should be_true
    end
  
    it "should move the file into the Images folder" do
      old_path = @file_path
      new_path = "#{test_download_path}/Images/#{@file_name}"
      File.exists?(old_path).should be_true
      @do.sort_files
      File.exists?(old_path).should be_false
      File.exists?(new_path).should be_true
    end
  end

  describe "recognized image types" do
    it "should recognize .jpg" do
      ".jpg".should match(DownloadOrganizer::IMAGE_EXTENSIONS)
    end
  
    it "should recognize .jpeg" do
      ".jpeg".should match(DownloadOrganizer::IMAGE_EXTENSIONS)
    end
  
    it "should recognize .png" do
      ".png".should match(DownloadOrganizer::IMAGE_EXTENSIONS)
    end
  
    it "should recognize .gif" do
      ".gif".should match(DownloadOrganizer::IMAGE_EXTENSIONS)
    end
  
    it "should recognize .ico" do
      ".ico".should match(DownloadOrganizer::IMAGE_EXTENSIONS)
    end
    it "should recognize .icns" do
      ".icns".should match(DownloadOrganizer::IMAGE_EXTENSIONS)
    end
  end

  describe "archive files" do
    before(:each) do
      @do = DownloadOrganizer.new(test_download_path)
      @file_name = "archive.zip"
      @file_path = "#{test_download_path}/#{@file_name}" # all recognized archive types (below) will behave like .zip
      @file = File.new(@file_path, "w")
    end
  
    after(:each) do
      FileUtils.remove_entry_secure(test_archives_path)
      delete_if_exists(@file_path)
    end
  
    it "should create a 'Archives' folder if one does not exist" do
      File.exists?(test_archives_path).should be_false
      @do.sort_files
      File.exists?(test_archives_path).should be_true
      File.directory?(test_archives_path).should be_true
    end
  
    it "should move the file into the Archives folder" do
      old_path = @file_path
      new_path = "#{test_download_path}/Archives/#{@file_name}"
      File.exists?(old_path).should be_true
      @do.sort_files
      File.exists?(old_path).should be_false
      File.exists?(new_path).should be_true
    end
  end

  describe "recognized archive types" do
    it "should recognize .rar" do
      ".rar".should match(DownloadOrganizer::ARCHIVE_EXTENSIONS)
    end
  
    it "should recognize .zip" do
      ".zip".should match(DownloadOrganizer::ARCHIVE_EXTENSIONS)
    end
  
    it "should recognize .tar" do
      ".tar".should match(DownloadOrganizer::ARCHIVE_EXTENSIONS)
    end
  end

  describe "all other file types" do 
    before(:each) do
      @do = DownloadOrganizer.new(test_download_path)
      @file_name = "misc_file.skjo"
      @file_path = "#{test_download_path}/#{@file_name}"
      @file = File.new(@file_path, "w")
    end
  
    after(:each) do
      FileUtils.remove_entry_secure(test_misc_path)
      delete_if_exists(@file_path)
    end
  
    it "should create a 'Misc' folder if one does not exist" do
      File.exists?(test_misc_path).should be_false
      @do.sort_files
      File.exists?(test_misc_path).should be_true
      File.directory?(test_misc_path).should be_true
    end
  
    it "should move the file into the Misc folder" do
      old_path = @file_path
      new_path = "#{test_download_path}/Misc/#{@file_name}"
      File.exists?(old_path).should be_true
      @do.sort_files
      File.exists?(old_path).should be_false
      File.exists?(new_path).should be_true
    end
  end

  describe "handling folders" do
  
    before(:each) do
      @do = DownloadOrganizer.new(test_download_path)
      @temp_folder_name = "temp_folder"
      @temp_folder_path = "#{test_download_path}/#{@temp_folder_name}"
      @majority_num = 6 # Number of files to create for majority
      Dir.mkdir(@temp_folder_path)
    end
  
    after(:each) do
      delete_if_exists(test_video_path)
      delete_if_exists(test_images_path)
      delete_if_exists(test_music_path)
      delete_if_exists(@temp_folder_path)
    end
  
    it "should put folders with a majority of movie files in the movies folder" do
      @majority_num.times{ |i| File.new("#{@temp_folder_path}/FILE_#{i}.VOB", "w") }
      File.new("#{@temp_folder_path}/cover.jpeg", "w")
      @do.sort_files
      File.exists?("#{test_video_path}/#{@temp_folder_name}").should be_true
    end
  
    it "should put folders with a majority of music files in the music folder" do
      @majority_num.times{ |i| File.new("#{@temp_folder_path}/song_#{i}.mp3", "w") }
      File.new("#{@temp_folder_path}/cover.jpeg", "w")
      @do.sort_files
      File.exists?("#{test_music_path}/#{@temp_folder_name}").should be_true
    end
  
    it "should put folders with no m3u, but a majority of mp3s in the music folder"
  
    it "should put folders with primarily image files in the pictures folder" do
      @majority_num.times{ |i| File.new("#{@temp_folder_path}/picture_#{i}.jpeg", "w") }
      File.new("#{@temp_folder_path}/explanation.pdf", "w")
      @file = File.new("#{@temp_folder_path}/temp.jpeg", "w")
      @do.sort_files
      File.exists?("#{test_images_path}/#{@temp_folder_name}").should be_true
    end
  
  end
  
end