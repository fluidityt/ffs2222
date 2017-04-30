
import SpriteKit
import PlaygroundSupport

let size = CGSize(width: 600, height: 500)
let view = SKView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
let scene = GameScene(size: size)


PlaygroundPage.current.liveView = view
view.presentScene(scene)

public func setMasks(pb: SKPhysicsBody, cat: UInt32, cont: UInt32, col: UInt32) {
  pb.categoryBitMask = cat
  pb.contactTestBitMask = cont
  pb.collisionBitMask = col
}

class GameScene2: SKScene {
  enum Category {
    static let
    zero =    UInt32 (0),    yellow =  UInt32 (1),    black =   UInt32 (2),
    three =   UInt32 (4),    line  =   UInt32 (8),    death =   UInt32 (16)
  };
  
  lazy var numBoxesX: Int = Int(self.frame.size.width / 30)
  lazy var numBoxesY: Int = Int(self.frame.size.height / 30)
  lazy var startingPoint: CGPoint = CGPoint(x: (self.frame.minX + 15),
                                            y: (self.frame.maxY + 15))
  
  let size30 = CGSize(width: 30, height: 30)

  func spawnBlackNode(pos: CGPoint)  {
    typealias C = Category
    
    let newPB = SKPhysicsBody(rectangleOf: size30)
    setMasks(pb: newPB, cat: C.black, cont: C.yellow | C.death, col: C.zero)
    
    let blackNode = SKSpriteNode(color: .white, size: size30)
    blackNode.name     = "black"
    blackNode.position = pos
    blackNode.physicsBody = newPB
    addChild(blackNode)
  }
  
  func makeHorizontalLine(atY: Int) {
    var nextPoint = startingPoint
    nextPoint.y += CGFloat(atY) * 30
    for _ in 1...numBoxesX {
      spawnBlackNode(pos: nextPoint)
      nextPoint.x += 30
    }
  }
  
  func dropBoxes() {
    for i in 1...numBoxesY {
      makeHorizontalLine(atY: i)
    }
  }
  
  override func didMove(to view: SKView) {
    anchorPoint = CGPoint(x: 0.5, y: 0.5)
    dropBoxes()
    
  }
}

