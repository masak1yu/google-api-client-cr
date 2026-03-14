require "../../../spec_helper"

describe Google::Apis::Core::PageIterator do
  it "iterates over pages" do
    page1 = Google::Apis::YoutubeV3::SearchListsResponse.from_json(%({
      "items": [{"id": {"videoId": "v1"}}],
      "nextPageToken": "page2"
    }))

    page2 = Google::Apis::YoutubeV3::SearchListsResponse.from_json(%({
      "items": [{"id": {"videoId": "v2"}}]
    }))

    call_count = 0
    fetcher = ->(token : String?) {
      call_count += 1
      page2
    }

    iterator = Google::Apis::Core::PageIterator(Google::Apis::YoutubeV3::SearchListsResponse).new(page1, fetcher)

    pages = [] of Google::Apis::YoutubeV3::SearchListsResponse
    iterator.each { |page| pages << page }

    pages.size.should eq(2)
    pages[0].items.not_nil![0].id.not_nil!.video_id.should eq("v1")
    pages[1].items.not_nil![0].id.not_nil!.video_id.should eq("v2")
    call_count.should eq(1)
  end

  it "returns single page when no next_page_token" do
    page = Google::Apis::YoutubeV3::SearchListsResponse.from_json(%({
      "items": [{"id": {"videoId": "v1"}}]
    }))

    fetcher = ->(token : String?) {
      raise "should not be called"
      page
    }

    iterator = Google::Apis::Core::PageIterator(Google::Apis::YoutubeV3::SearchListsResponse).new(page, fetcher)
    pages = iterator.to_a
    pages.size.should eq(1)
  end
end
