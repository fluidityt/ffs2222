import SpriteKit
import PlaygroundSupport

let size = CGSize(width: 600, height: 500)
let view = SKView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
let scene = SKScene(size: size)
scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)

PlaygroundPage.current.liveView = view
view.presentScene(scene)

scene.addChild(SKSpriteNode())

extension CGRect {
  
  init(middle: CGPoint, width: CGFloat, height: CGFloat) {
    
    let x = middle.x - (width/2)
    let y = middle.y - (height/2)
    
    self.origin = CGPoint(x: x, y: y)
    self.size   = CGSize(width: width, height: height)
  }
}

let size30 = CGSize(width: 30, height: 30)

let node = SKSpriteNode(color: .green, size: size30)
scene.addChild(node)

let newRect = CGRect(middle: CGPoint(x:0,y:0), width: 30, height: 30)

while node.frame.intersects(newRect) {
    node.position.x += 5
}
