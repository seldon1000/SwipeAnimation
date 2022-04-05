# SwipeAnimation

This is part of a greater effort to explain the importance of Animation&Motion inside mobile applications and games, developed @ Apple Developer Academy | Naples. The effort consists in four different repositories, each containing a single animation. You'll find the main GitHub repository containing further information at the link below.

https://github.com/seldon1000/SwiftUI_Animations

SwipeAnimation is a XCode project, containing an application prototype showcasing a swipe animation inside a grid of dots and a detailed explanation of how to implement the animation in SwiftUI.

## Overlays&Headackes

This animation is a simple swipe. Here, you use swipes to move vertically or horizontally and you move through all the available space, until you find an obstacles (dark dots in our case). The swipe should be quick but consistently animated, using colors, scale effect and overlays, with timed UI changes. Let's take a look.

![Alt Text](https://github.com/seldon1000/SwipeAnimation/blob/main/swipe.gif)

This animation comes with a lot of headackes. Let's see why. First things first, we have a grid @State variable, of type Grid. Grid is a custom class I created that manages the whole "gameplay" and the grid you play inside. Let's see what it actually does. Below you can take a look to its members and initializer. The ```currentDot``` variable contains the coordinates of the current dot inside the grid and is marked @Published, meaning that everytime it changes, the UI will refresh too, according to the changes. ```dotsToWin``` counts the dots left to be colored. ```dots``` holds the whole grid of dots, our environment. ```startDot``` holds the coordinates of the dot where you start playing. ```rows``` and ```cols``` hold the dimensions of the grid. The initialiser will take a Level object, which holds information about how the grid should look like.

```swift
@Published var currentDot: (Int, Int)
var dotsToWin: Int
var dots: [[Dot]]
    
private let startDot: (Int, Int)
let rows: Int
let cols: Int
    
init(level: Level) {
    currentDot = level.startDot
        
    dotsToWin = level.rows * level.cols - level.obstacles.count - 1
    dots = []
        
    startDot = level.startDot
    rows = level.rows
    cols = level.cols
        
    for i in 0..<rows {
        dots.append([])
            
       for j in 0..<cols {
            dots[i].append(Dot(isObstacle: level.obstacles.contains(where: { k in k == (i, j) }), coordinates: (i, j)))
        }
    }
        
    dots[currentDot.0][currentDot.1].isColored = true
}
```

Let's move on to the headackes part: the gesture management. Since a swipe gesture modifies a lot of things inside the grid object we are using, its management is held inside the grid itself. The function is ```dragGesture(translation: CGSize)```. Below you will find an example. The ```j``` variable is used for two reasons: it lets us better delay animations when we swipe and it lets us know if we actually moved from a position inside the grid to another. The function takes a ```translation``` object as input parameter, which holds the amount of space dragged during the swipe. Inside the if statement, we check if the user did a left to right swipe. If so, we start iterating throughout every dot present in that specific direction. The iteration stops when we encounter an edge, an obstacle or when there are no other dots to be colored. If there is a dot we can move to, we color that dot with an easeInOut animation, with a duration of ```j```. Then, we increment ```j```, in order to provide a gradual animation for the whole swipe length. This is for the left to right swipe, but it's the same for the other directions.

```swift
var j: Double = 0.3
        
if translation.width > 90 {
    var i = currentDot.1 + 1
            
    while i < cols && !dots[currentDot.0][i].isObstacle && dotsToWin > 0 {
        if !dots[currentDot.0][i].isColored {
            dotsToWin -= 1
        }
                
        withAnimation(.easeInOut(duration: j)) {
            currentDot.1 = i
            dots[currentDot.0][i].isColored = true
        }
                
        i += 1
        j *= 1.06
    }
}
```

We've talked about the internal stuff, but now let's move on to the UI. Below there's the DotComponent file source code. We have the grid again, the one declared inside the GameView file, a ```diameter``` @State var, which defines the dimensions of the dot accordingly to the device screen and a ```dot``` variable of type Dot, which holds information about the dot. So, we fill the dot with the right color, keeping in mind that obstacles should be dark: ```.fill(Color(dot.isObstacle ? dot.obstacleColor : dot.color))```. We set the frame and then apply an overlay: ```.overlay(Circle().strokeBorder(.black.opacity(0.35), lineWidth: diameter * (dot.coordinates == grid.currentDot && grid.dotsToWin > 0 ? 0.35 : 0.0)))```, this means that we put a darker stroke border on top of the dot, but only if its the current one, to differentiate it. This is also important for the swipe animation. Then, we apply a scale effect: ```.scaleEffect(dot.coordinates == grid.currentDot && grid.dotsToWin > 0 ? 1.2 : (dot.isColored ? 1.0 : 0.0))```, meaning that if the dot is the current one, it will be larger than the others, otherwise, if the dot is already colored it will fill its frame or else it will stay scaled to a 0 factor (it won't even appear). That means that as soon as the grid colors the dot, it will enlarge itself from a 0 scale factor to 1. Anything else inside the file will be discussed later.

```swift
@EnvironmentObject var grid: Grid
    
@State var diameter: CGFloat = 64
    
var dot: Dot
    
var body: some View {
    Circle()
        .fill(Color(dot.isObstacle ? dot.obstacleColor : dot.color))
        .frame(width: diameter, height: diameter)
        .overlay(Circle().strokeBorder(.black.opacity(0.35), lineWidth: diameter * (dot.coordinates == grid.currentDot && grid.dotsToWin > 0 ? 0.35 : 0.0)))
        .scaleEffect(dot.coordinates == grid.currentDot && grid.dotsToWin > 0 ? 1.2 : (dot.isColored ? 1.0 : 0.0))
        .padding(6)
        .onAppear {
            diameter = UIScreen.main.bounds.width / CGFloat(grid.cols) - 17
        }
}
```

Lastly, let's take a look to the Start file source code, which displays the grid of DotComponent objects. Using the ```.gesture``` modifier, we listen for drag gestures, and we pass their translation value to the grid's ```dragGesture``` function.

```swift
@State var grid: Grid = Grid(level: level)
    
var body: some View {
    VStack {
        VStack(spacing: 0) {
            ForEach(0..<grid.rows, id: \.self) { i in
                HStack(spacing: 0) {
                    ForEach(grid.dots[i]) { dot in
                        DotComponent(dot: dot)
                    }
                }
            }
        }
        .environmentObject(grid)
        .contentShape(Rectangle())
        .gesture(DragGesture().onEnded { value in
            if grid.dragGesture(translation: value.translation) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    grid.resetGrid()
                }
            }
        })
    }
}
```

I told you there were a lot of headackes here. For more animations, refer to the link down below.

https://github.com/seldon1000/SwiftUI_Animations
