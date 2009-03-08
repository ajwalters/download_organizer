require 'fileutils'
require 'find'

class DownloadOrganizer

  #== Included Modules
  include FileUtils
  include Find
  
  #== Constants
  DEFAULT_MUSIC_FOLDER =  "Music"
  MUSIC_EXTENSIONS = /mp3/
  
  #== Accessors
  # attr_reader :current_directory

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
  
  def music_folder_name
    @music_folder || DEFAULT_MUSIC_FOLDER
  end
  
  def music_folder_path
    "#{@download_path}/#{music_folder_name}"
  end
  
  def current_directory
    pwd
  end
  
  # Main method which sorts the files
  def sort_files
    # Iterate thru files in @download_path
    cd(@download_path) do
      Find.find(pwd) do |path_to_file|
        @path_to_file = path_to_file
        next if path_to_file == pwd # don't include the download folder as one of the files
        @file_directory, @file_name = File.split(path_to_file)
        next if @file_name[0] == "." # skip any files/directories beginning with .
        process_download_file
      end
    end
  end
    
  def process_download_file
    if File.file?(@path_to_file)
      # file
      type_of_file = get_type_of_file
      handle_music_file if type_of_file == :music
    else
      # directory (other?)
      # For now, stop searching in directory
      Find.prune
    end
  end
  
  def get_type_of_file
    extension = File.extname(@path_to_file)
    return :music if extension =~ MUSIC_EXTENSIONS
  end
  
  def handle_music_file
    create_music_folder unless File.exists?(music_folder_path)
    # move the file into the music folder
    mv @path_to_file, music_folder_path
  end
  
  def create_music_folder
    mkdir(music_folder_path)
  end
  
end
