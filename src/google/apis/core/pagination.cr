module Google
  module Apis
    module Core
      module Paginated
        abstract def next_page_token : String?
      end

      class PageIterator(T)
        include Iterator(T)

        @first_page : T?
        @next_token : String?
        @fetcher : String? -> T

        def initialize(first_page : T, @fetcher : String? -> T)
          @first_page = first_page
          @next_token = first_page.next_page_token
        end

        def next
          if page = @first_page
            @first_page = nil
            return page
          end

          token = @next_token
          return stop unless token

          page = @fetcher.call(token)
          @next_token = page.next_page_token
          page
        end
      end
    end
  end
end
