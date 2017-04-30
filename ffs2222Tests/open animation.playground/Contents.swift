
import SpriteKit
import PlaygroundSupport

let size = CGSize(width: 600, height: 1000)
let view = SKView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
let scene = LaunchScene(size: size)


PlaygroundPage.current.liveView = view
view.presentScene(scene)



