module Bookmailer
  class BookmarkRepository
    Bookmark = Struct.new(:title, :url, :note)

    include Enumerable

    def each
      data[:bookmarks].each { |e| yield(e.contents) }
    end

    def initialize(filename)
      self.data = Newman::Store.new(filename)
    end

    def add_bookmark(params)
      title = params.fetch(:title)
      url   = params.fetch(:url)
      note  = params.fetch(:note)
      b = Bookmark.new(title, url, note)
      data[:bookmarks].create(b)
    end 

    def find_by_title(title)
      bookmark = data[:bookmarks].find { |e| e.contents.title == title }
      bookmark.contents if bookmark
    end


    def remove_bookmark(title)
      bookmark = data[:bookmarks].find { |e| e.contents.title == title }

      data[:bookmarks].destroy(bookmark.id) if bookmark
    end

   


    private

    attr_accessor :data
  end
end

