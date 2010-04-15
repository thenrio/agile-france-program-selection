class Pager
  def self.paginate(collection, modulo)
    pages = []
    page = nil
    d = 0
    collection.each do |element|
      d += element.duration
      if d % modulo == 0
        page = nil
      end
      if not page
        pages << (page = [])
      end
      page << element
    end
    pages
  end
end