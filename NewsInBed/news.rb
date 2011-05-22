require 'rexml/document'

Shoes.app(:title => 'News In Bed', :width => 420, :height => 594) do
    background cornsilk
    @loading = para 'Finding some juicy news...'
    @dark_colors = [crimson, darkblue, darkmagenta, darkred, darkslateblue,
                    deeppink, indigo, maroon, midnightblue, red]

    def pick(list)
        list.shuffle.first
    end

    def titles(xml)
        doc = REXML::Document.new(xml)
        items = []
        doc.elements.each('rss/channel/item/title') do |el|
            items << el.text
        end
        items.shuffle
    end

    download 'http://feeds.bbci.co.uk/news/rss.xml' do |feed|
        @headlines = titles(feed.response.body)
        @loading.hide
        stack(:margin => 12) do
            title 'Shoes News', :align => 'center', :font => 'Georgia, serif bold 40px'
            @headlines.each do |headline|
                para "#{headline} in bed",
                    :font => 'Georgia, serif 20px',
                    :stroke => pick(@dark_colors)
            end
        end
    end
end
