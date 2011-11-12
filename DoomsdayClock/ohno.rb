Shoes.app :title => 'Doomsday Clock', :width => 420, :height => 450 do
    background white
    @radius = width * 0.45

    def pluralize(number, text)
        suffix = (number == 1) ? '' : 's'
        [number, text + suffix].join ' '
    end

    def vector(clock_degrees)
        degrees = (270 - clock_degrees) % 360
        radians = Math::PI * degrees / 180
        [Math.cos(radians) * @radius, Math.sin(radians) * @radius]
    end

    def clock
        para pluralize(@minutes, 'minute') + ' to midnight!'

        # outer circle
        translate width * 0.5, height * 0.5
        stroke black
        strokewidth 8
        fill white
        oval :left => 0, :top => 0, :radius => @radius, :center => true

        # middle circle
        fill black
        nostroke
        oval :left => 0, :top => 0, :radius => @radius * 0.05, :center => true

        # minute markers
        60.times do |m|
            x, y = vector(m * 6)
            stroke black
            strokewidth (m % 5 == 0) ? 5 : 2
            line x * 0.87, y * 0.87, x * 0.96, y * 0.96
        end

        # hour hand
        strokewidth 15
        stroke black
        cap :curve
        x, y = vector(@minutes * 0.5)
        line x * 0.6, y * 0.6, x * -0.1, y * -0.1

        # minute hand
        strokewidth 7
        x, y = vector(@minutes * 6)
        line x * 0.84, y * 0.84, x * -0.15, y * -0.15
    end

    @status = para "Querying thebulletin.org..."
    download 'http://www.thebulletin.org/' do |r|
        match = r.response.body.match /<title>.*([0-9]+).*[Mm]inute.*<\/title>/
        if match and match[1]
            @minutes = match[1].to_i
            @status.remove
            clock
        else
            para "No luck. :("
        end
    end
end
