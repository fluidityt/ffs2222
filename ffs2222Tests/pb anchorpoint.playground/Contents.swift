import SpriteKit
import PlaygroundSupport

let size = CGSize(width: 600, height: 500)
let view = SKView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
view.showsPhysics = true
let scene = SKScene(size: size)
scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
scene.physicsWorld.gravity = CGVector.zero

PlaygroundPage.current.liveView = view
view.presentScene(scene)



let node = SKSpriteNode(color: .white, size: CGSize(width: 200, height: 200)); do {
  node.anchorPoint = CGPoint(x: 1, y: 0.5)
  node.position.x -= 52
  node.position.y += 28
  
  let point = CGPoint(x: node.frame.width/2 , y: node.frame.height/2)
  
    func pbCenter(on node: SKSpriteNode) -> CGPoint {
      return  CGPoint(x: CGFloat(node.size.width * (node.anchorPoint.x - 0.5) - node.size.width),
                      y: CGFloat(node.size.height * (0.5 - node.anchorPoint.y)))
    }
    
    node.physicsBody = SKPhysicsBody(rectangleOf: node.size, center: pbCenter(on:node))
}

scene.addChild(node)
