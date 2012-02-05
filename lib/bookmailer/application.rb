module Bookmailer
  
  Application = Newman::Application.new do 
      helpers do
        def bookmarks
          Bookmailer::BookmarkRepository.new(settings.application.bookmailer_db)
        end
      end

      to(:tag, "put") do
        subject = request.subject
        title,url = subject.split(' ').map { |x| x.strip }
        note      = request.body
        params = {  :title => title, :url => url, :note => note }
        bookmarks.add_bookmark(params)
        respond :subject => "Bookmark saved #{title}"
      end

      to(:tag, "get") do
        title = request.subject
        bookmark = bookmarks.find_by_title(title) 
        if bookmark
          respond :subject => "Bookmark: #{bookmark.title}",
            :body => "Url: #{bookmark.url}\n Notes: #{bookmark.note}"
        else
          respond :subject => "Bookmark not found"
        end
      end

      to(:tag, "delete") do
        title = request.subject
        if bookmarks.remove_bookmark(title)
          respond :subject => "Bookmark removed #{title}"
        else
          respond :subject => "Bookmark not found"
        end
      end

      default do
        p request
        p request.to
        p request.subject
        p request.body
        respond :subject => "FAIL"
      end


  end
  
end
