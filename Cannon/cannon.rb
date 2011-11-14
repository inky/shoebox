class Vector2D
    attr_accessor :x, :y

    def initialize(x, y)
        @x, @y = x.to_f, y.to_f
    end

    def add(v)
        Vector2D.new(@x + v.x, @y + v.y)
    end
    def add(x, y)
        Vector2D.new(@x + x, @y + y)
    end
    def add!(v)
        @x += v.x
        @y += v.y
        self
    end
    def add!(x, y)
        @x += x
        @y += y
        self
    end

    def mult(m)
        Vector2D.new(@x * m, @y * m)
    end
    def mult!(m)
        @x *= m
        @y *= m
    end

    def length
        Math.sqrt( (@x * @x) + (@y * @y) )
    end

    def normalize!
        l = self.length
        @x /= l
        @y /= l
        self
    end

    def radians
        Math.tan(@y / @x)
    end
end

class Projectile
    attr_accessor :x, :y, :radius, :velocity

    def initialize(x, y, radius, velocity)
        @x = x
        @y = y
        @radius = radius
        @velocity = velocity
        @start = Vector2D.new x, y
        @time = 0
    end

    def increment(fps)
        g = -9.8 * 120
        @time += 1.0 / fps
        @x = @start.x + velocity.x * @time
        @y = @start.y + (velocity.y * @time) - 0.5 * (g * @time * @time)
    end
end

class Cannon
    attr_accessor :x, :y, :direction, :length, :firing, :projectile

    def initialize(x, y)
        @x = x
        @y = y
        @direction = Vector2D.new 0, 0
        @length = 100
        @firing = false
        @projectile = nil
    end

    def aim_at(x, y)
        @direction.x = x - @x
        @direction.y = y - @y
        @direction.normalize!
    end

    def fire
        return if @firing
        @firing = true
        position = @direction.mult(@length + 20).add(x, y)
        velocity = @direction.mult 800
        @projectile = Projectile.new(position.x, position.y, 12, velocity)
    end

    def remove_projectile
        @projectile = nil
        @firing = false
    end
end

Shoes.app :title => 'Cannon', :width => 640, :height => 400 do
    @cannon = Cannon.new -5, height / 2

    def draw_cannon
        stroke black
        strokewidth 30
        line(@cannon.x,
             @cannon.y,
             @cannon.direction.x * @cannon.length + @cannon.x,
             @cannon.direction.y * @cannon.length + @cannon.y)
        fill black
        nostroke
        oval :left => @cannon.x, :top => @cannon.y, :radius => 30, :center => true
        if @cannon.projectile
            oval :left => @cannon.projectile.x,
                 :top => @cannon.projectile.y,
                 :radius => @cannon.projectile.radius,
                 :center => true
        end
    end

    fps = 30
    frame = nil
    animate fps do
        button, left, top = self.mouse
        frame.remove if frame
        frame = flow :left => 0, :top => 0, :width => width, :height => height do
            background white

            if @cannon.projectile
                @cannon.projectile.increment(fps)
                if @cannon.projectile.x > width - @cannon.projectile.radius
                    @cannon.remove_projectile
                elsif @cannon.projectile.y > height - @cannon.projectile.radius
                    @cannon.remove_projectile
                end
            end
            @cannon.aim_at left, top
            @cannon.fire if button == 1
            draw_cannon
        end
    end
end
