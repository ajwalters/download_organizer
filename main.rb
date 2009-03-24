require File.expand_path(File.dirname(__FILE__)) + "/lib/download_organizer"

Shoes.app :width => 480, :height => 175, :title => "The Insanity Has Gone On Long Enough" do
  background gradient(rgb(160,158,154), rgb(242, 242, 241))
  stack  :margin => 10 do
    background rgb(255,255,255)
    border lightslategray
    stack do
      caption "Downloads Organizer", :margin_left => 20, :margin_top => 20, :variant => 'smallcaps', :size => 'large',
              :stroke => firebrick
    end
    flow :margin_left => 25, :height => 55 do
      para "Source:", :stroke => gray(0.35)
      @download_path_text = para "Please select a download folder"
    end
    @select_download_button_flow = flow :margin_left => 15, :margin_top => 5 do
      button "Select download folder", :width => 200 do
        # @sort_button.hide
        @success_text.remove() if @success_text
        request_download_folder(ask_open_folder)
      end

    end
  end

  def request_download_folder(selected_folder)
    if selected_folder
      # folder selected -> create the download organizer
      @download_organizer = DownloadOrganizer.new(selected_folder)
      @download_path_text.replace selected_folder
      unless @sort_button
        @select_download_button_flow.append{
          @sort_button = button "Sort!", :width => 100 do
            sort
          end   
        }
      end
    end
  end
  
  def sort
    @success_text.remove() if @success_text
    @download_organizer.sort_files
    @select_download_button_flow.append do
      @success_text = caption "DONE!", :stroke => darkgreen, :emphasis => 'italic', :margin_left => 20
    end
  end
  
end