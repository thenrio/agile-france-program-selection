class Pager
  def self.paginate(collection, modulo)
    pages = []
    page = nil
    d = 0
    collection.each do |element|
      if not page
        pages << (page = [])
      end
      page << element
      d += element.duration
      if d % modulo == 0
        page = nil
      end
    end
    pages
  end
end