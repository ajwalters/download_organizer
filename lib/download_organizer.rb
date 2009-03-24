require 'fileutils'
require 'find'

class DownloadOrganizer

  #== Included Modules
  include FileUtils
  include Find

  #== Constants
  RECOGNIZED_TYPES = [:music, :video, :image, :document, :disk_image, :archive, :torrent]

  DEFAULT_MUSIC_FOLDER =  "Music"
  DEFAULT_VIDEO_FOLDER =  "Video"
  DEFAULT_TORRENT_FOLDER =  "Torrents"
  DEFAULT_DISK_IMAGE_FOLDER =  "Disk Images and Installers"
  DEFAULT_DOCUMENT_FOLDER =  "Documents"
  DEFAULT_IMAGE_FOLDER =  "Images"
  DEFAULT_ARCHIVE_FOLDER =  "Archives"  
  DEFAULT_MISC_FOLDER =  "Misc"
  
  MUSIC_EXTENSIONS = /mp3|wav|m3u/i
  VIDEO_EXTENSIONS = /avi|mpeg|mov|vob/i
  TORRENT_EXTENSIONS = /torrent/i
  DISK_IMAGE_EXTENSIONS = /iso|dmg|pkg/i
  DOCUMENT_EXTENSIONS = /doc|pdf|xls/i
  IMAGE_EXTENSIONS = /jpeg|jpg|gif|ico|png|icns/i
  ARCHIVE_EXTENSIONS = /rar|zip|tar|gz/i

  #== Instance Methods
  def initialize(path_to_download_folder) #, progress_bar_object=nil)
    @download_path = path_to_download_folder
    # Get number of files in download folder -- subtract 2 for . and ..
    @total_number_of_files = Dir.entries(@download_path).length - 2
    @files_processed = 0
  end
  
  def download_path
    @download_path
  end
  
  def progress
    @files_processed.to_f / @total_number_of_files.to_f
  end
  
  def progress_bar=(obj)
    @progress_bar = obj
  end
  
  def progress_bar
    @progress_bar
  end 
  
  # Main method which sorts the files
  def sort_files
    # Iterate thru files in @download_path
    cd(@download_path) do
      Find.find(pwd) do |path_to_file|
        @current_file_path = path_to_file
        next if @current_file_path == pwd # don't include the download folder as one of the files
        update_progress
        @file_directory, @file_name = File.split(@current_file_path)
        next if @file_name[0..0] == "." # skip any files/directories beginning with .
        # Stop searching this file/directory if it should be skipped, otherwise process the file
        should_skip_folder? ? Find.prune : process_download_file
      end
    end
  end
  
  private 
  
  def destination_folder_name
    instance_variable_get("@#{@file_type}_folder") || self.class.module_eval("DEFAULT_#{@file_type.to_s.upcase}_FOLDER")
  end
  
  def destination_folder_path
    "#{@download_path}/#{destination_folder_name}"
  end
  
  def handle_file
    create_destination_folder unless File.exists?(destination_folder_path)
    # move the file into the appropriate folder
    mv @current_file_path, destination_folder_path
  end
  
  def create_destination_folder
    mkdir(destination_folder_name)
  end
  
  def current_directory
    pwd
  end
    
  def process_download_file
    if File.file?(@current_file_path)
      # file
      @file_type = get_type_of_file(@current_file_path)
    else  
      # directory
      @file_type = get_folders_most_common_file_type
    end
    handle_file if @file_type
  end
  
  def get_type_of_file(path)
    extension = File.extname(path)
    RECOGNIZED_TYPES.each{|file_type| return file_type if extension =~ self.class.module_eval("#{file_type.to_s.upcase}_EXTENSIONS")}
    # If the file_type is not recognized, return :misc
    return :misc
  end
  
  def get_folders_most_common_file_type
    @file_type_counts = {}
    count_folder_file_types_recurse(@current_file_path)
    return nil if @file_type_counts.length == 0 # No files in folder
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
  
  # Return true if @current_file_path is one of the default folder destinations
  def should_skip_folder?
    folder_symbols = RECOGNIZED_TYPES + [:misc]
    folder_symbols.each{|type| return true if File.basename(@current_file_path) == self.class.module_eval("DEFAULT_#{type.to_s.upcase}_FOLDER")}
    return false
  end
  
  def update_progress
    @files_processed += 1 # Increment processed count
    @progress_bar.fraction = progress if @progress_bar
  end
  
end
