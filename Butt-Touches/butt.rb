# code by inky, May 2011 <http://inky.me>
# images from a comic by Ryan Pequin <http://threewordphrase.com/kingbutt.htm>
Shoes.app(:title => 'King Butt-Touches',
          :width => 400,
          :height => 270,
          :resizable => false) {
    background white
    image 'assets/butt0.png'
    @butt = image('assets/butt1.png').click{
        @butt.path = 'assets/butt2.png'
    }.release{
        @butt.path = 'assets/butt1.png'
    }
}
