require 'fileutils'
require 'find'

class DownloadOrganizer

  #== Included Modules
  include FileUtils
  include Find

  #== Constants
  # recognized_types = [:music, :video, :image, :document, :disk_image, :archive, :torrent]
  DEFAULT_MUSIC_FOLDER =  "Music"
  DEFAULT_VIDEO_FOLDER =  "Video"
  DEFAULT_TORRENTS_FOLDER =  "Torrents"
  DEFAULT_DISK_IMAGES_FOLDER =  "Disk Images and Installers"
  DEFAULT_DOCUMENTS_FOLDER =  "Documents"
  DEFAULT_IMAGES_FOLDER =  "Images"
  DEFAULT_ARCHIVES_FOLDER =  "Archives"  
  DEFAULT_MISC_FOLDER =  "Misc"
  
  MUSIC_EXTENSIONS = /mp3|wav|m3u/i
  VIDEO_EXTENSIONS = /avi|mpeg|mov|vob/i
  TORRENT_EXTENSIONS = /torrent/i
  DISK_IMAGE_EXTENSIONS = /iso|dmg|pkg/i
  DOCUMENT_EXTENSIONS = /doc|pdf|xls/i
  IMAGE_EXTENSIONS = /jpeg|jpg|gif|ico|png|icns/i
  ARCHIVE_EXTENSIONS = /rar|zip|tar/i
  
  #== Accessors

  #== Class Methods
  class << self
  end
  
  #== Instance Methods
  def initialize(path_to_download_folder)
    @download_path = path_to_download_folder
    # CD to the download_path
  end
  
  def download_path
    @download_path
  end
  
  # = Music
  def music_folder_name
    @music_folder || DEFAULT_MUSIC_FOLDER
  end
  
  def music_folder_path
    "#{@download_path}/#{music_folder_name}"
  end
  
  def handle_music_file
    puts "HANDLE MUSIC FILE"
    create_music_folder unless File.exists?(music_folder_path)
    # move the file into the music folder
    mv @current_file_path, music_folder_path
  end
  
  def create_music_folder
    mkdir(music_folder_path)
  end
    
  # = Video
  def video_folder_name
    @video_folder || DEFAULT_VIDEO_FOLDER
  end
  
  def video_folder_path
    "#{@download_path}/#{video_folder_name}"
  end
  
  def handle_video_file
    create_video_folder unless File.exists?(video_folder_path)
    mv @current_file_path, video_folder_path
  end
  
  def create_video_folder
    mkdir(video_folder_path)
  end
  
  # = Torrents  
  def torrents_folder_name
    @torrents_folder || DEFAULT_TORRENTS_FOLDER
  end
  
  def torrents_folder_path
    "#{@download_path}/#{torrents_folder_name}"
  end
  
  def handle_torrent_file
    create_torrents_folder unless File.exists?(torrents_folder_path)
    # move the file into the music folder
    mv @current_file_path, torrents_folder_path
  end
  
  def create_torrents_folder
    "make: #{torrents_folder_path}"
    mkdir(torrents_folder_path)
  end
  
  # = Disk Images and Installers
  def disk_images_folder_name
    @disk_images_folder || DEFAULT_DISK_IMAGES_FOLDER
  end
  
  def disk_images_folder_path
    "#{@download_path}/#{disk_images_folder_name}"
  end
  
  def handle_disk_image_file
    create_disk_images_folder unless File.exists?(disk_images_folder_path)
    # move the file into the music folder
    mv @current_file_path, disk_images_folder_path
  end
  
  def create_disk_images_folder
    mkdir(disk_images_folder_path)
  end
  
  # = Documents
  def documents_folder_name
    @documents_folder || DEFAULT_DOCUMENTS_FOLDER
  end
  
  def documents_folder_path
    "#{@download_path}/#{documents_folder_name}"
  end
  
  def handle_document_file
    create_documents_folder unless File.exists?(documents_folder_path)
    # move the file into the music folder
    mv @current_file_path, documents_folder_path
  end
  
  def create_documents_folder
    mkdir(documents_folder_path)
  end
  
  # = Images
  def images_folder_name
    @images_folder || DEFAULT_IMAGES_FOLDER
  end
  
  def images_folder_path
    "#{@download_path}/#{images_folder_name}"
  end
  
  def handle_image_file
    create_images_folder unless File.exists?(images_folder_path)
    # move the file into the music folder
    mv @current_file_path, images_folder_path
  end
  
  def create_images_folder
    mkdir(images_folder_path)
  end
  
  # = Archives
  def archives_folder_name
    @archives_folder || DEFAULT_ARCHIVES_FOLDER
  end
  
  def archives_folder_path
    "#{@download_path}/#{archives_folder_name}"
  end
  
  def handle_archive_file
    create_archives_folder unless File.exists?(archives_folder_path)
    # move the file into the music folder
    mv @current_file_path, archives_folder_path
  end
  
  def create_archives_folder
    mkdir(archives_folder_path)
  end
  
  # = Misc files
  def misc_folder_name
    @misc_folder || DEFAULT_MISC_FOLDER
  end
  
  def misc_folder_path
    "#{@download_path}/#{misc_folder_name}"
  end
  
  def handle_misc_file
    create_misc_folder unless File.exists?(misc_folder_path)
    # move the file into the music folder
    mv @current_file_path, misc_folder_path
  end
  
  def create_misc_folder
    mkdir(misc_folder_path)
  end
  
  def current_directory
    pwd
  end
  
  # Main method which sorts the files
  def sort_files
    # Iterate thru files in @download_path
    cd(@download_path) do
      Find.find(pwd) do |path_to_file|
        @current_file_path = path_to_file
        next if @current_file_path == pwd # don't include the download folder as one of the files
        @file_directory, @file_name = File.split(@current_file_path)
        next if @file_name[0..0] == "." # skip any files/directories beginning with .
        process_download_file
      end
    end
  end
    
  def process_download_file
    if File.file?(@current_file_path)
      # file
      type_of_file = get_type_of_file(@current_file_path)
    else
      # directory
      type_of_file = get_folders_most_common_file_type
    end
    handle_music_file if type_of_file == :music
    handle_video_file if type_of_file == :video
    handle_image_file if type_of_file == :image
    handle_document_file if type_of_file == :document
    handle_archive_file if type_of_file == :archive
    handle_torrent_file if type_of_file == :torrent
    handle_disk_image_file if type_of_file == :disk_image
    handle_misc_file if type_of_file == :other
  end
  
  def get_type_of_file(path)
    extension = File.extname(path)
    return :music if extension =~ MUSIC_EXTENSIONS
    return :video if extension =~ VIDEO_EXTENSIONS
    return :image if extension =~ IMAGE_EXTENSIONS
    return :document if extension =~ DOCUMENT_EXTENSIONS
    return :archive if extension =~ ARCHIVE_EXTENSIONS
    return :torrent if extension =~ TORRENT_EXTENSIONS
    return :disk_image if extension =~ DISK_IMAGE_EXTENSIONS
    return :other
  end
  
  def get_folders_most_common_file_type
    @file_type_counts = {}
    count_folder_file_types_recurse(@current_file_path)
    # sort file types into descending order
    sorted_type_counts = @file_type_counts.sort{|a,b| a[1] <=> b[1]}.reverse
    return sorted_type_counts[0][0]
  end
  
  def count_folder_file_types_recurse(file_path)
    if File.file?(file_path)
      # get type of file
      file_type = get_type_of_file(file_path)
      # Create or increment file type count for file type
      @file_type_counts.has_key?(file_type) ? (@file_type_counts[file_type] += 1) : (@file_type_counts[file_type] = 1) 
    else
      # iterate over files in directory and recursively call count
      Find.find(file_path) do |path|
        next if file_path == path # Skip the first...
        count_folder_file_types_recurse(path)
      end
    end
  end
  
  # Deletes a file, checking if it exists first
  def delete_if_exists(path)
    FileUtils.remove_entry_secure(path) if test(?e, path)
  end
  
end
