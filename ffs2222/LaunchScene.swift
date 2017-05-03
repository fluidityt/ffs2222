//
// LaunchScene.swift

import SpriteKit

class LaunchScene: SKScene {
  
  lazy var numBoxesX: Int = Int(self.frame.size.width / 30)
  lazy var numBoxesY: Int = Int(self.frame.size.height / 30)
  lazy var startingPoint: CGPoint = CGPoint(x: (self.frame.minX + 15),
                                            y: (self.frame.maxY + 15))
  
  let size30 = CGSize(width: 30, height: 30)
  
  typealias C = Category
  
  func spawnBlackNode(pos: CGPoint)  {
    
    let blackNode = SKSpriteNode(color: .white, size: size30); do {
      let newPB = SKPhysicsBody(rectangleOf: size30)
      newPB.velocity.dy -= CGFloat(randy(100))
      
      blackNode.physicsBody = newPB
      blackNode.name     = "black"
      blackNode.position = pos
    }
    
    addChild(blackNode)
  }
  
  func spawnStopper() {
    
    let pos = CGPoint(x: 0, y: self.frame.minY - 15)
    let size = CGSize(width: frame.width, height: 10)
    
    let stopper = SKSpriteNode(color: .blue, size: size); do {
      let newPB = SKPhysicsBody(rectangleOf: size); do {
        newPB.affectedByGravity = false
        newPB.pinned            = true
        newPB.allowsRotation    = false
      }
      stopper.position    = pos
      stopper.physicsBody = newPB
    }
    
    addChild(stopper)
  }
  
  func spawnSideLines() {
    
    let sideL = SKSpriteNode(color: .orange, size: CGSize(width: 4, height: frame.size.height * 2)); do {
      let newPB = SKPhysicsBody(rectangleOf: sideL.frame.size); do {
        
        newPB.affectedByGravity = false
        newPB.allowsRotation = false
        newPB.pinned = true
      }
      sideL.physicsBody = newPB
      sideL.position.x = frame.minX - 2
      sideL.position.y = frame.maxY
    }
    
    let sideR = sideL.copy() as! SKSpriteNode; do {
      sideR.position.x = frame.maxX + 2
      sideR.position.y = frame.maxY
    }
    addChild(sideL)
    addChild(sideR)
  }
  
  func makeHorizontalLine(atY: Int) {
    var nextPoint = startingPoint
    nextPoint.y += (10 + CGFloat(atY) * 30)
    for _ in 1...numBoxesX {
      spawnBlackNode(pos: nextPoint)
      nextPoint.x += 32
    }
  }
  
  func dropBoxes() {
    for i in 1...numBoxesY+5 {
      makeHorizontalLine(atY: i)
    }
  }
  
  func spawnLabel() {
    
    play: do {
      let label = SKLabelNode(text: "Play!")
      label.fontColor = .black
      addChild(label)
      label.zPosition += 1
      label.setScale(3)
    }
    
    options: do {
      let label = SKLabelNode(text: "Options")
      label.fontColor = .black
      addChild(label)
      label.position.y -= 200
      label.zPosition += 1
      label.setScale(3)
    }
    
    sprites: do {
      let label = SKLabelNode(text: "Sprite Attack!")
      
      label.fontColor = .yellow
      addChild(label)
      label.position.y += 200
      label.zPosition += 1
      label.setScale(3.5)
    }
  }
  
  override func didMove(to view: SKView) {
    anchorPoint = CGPoint(x: 0.5, y: 0.5)
    spawnLabel()
    dropBoxes()
    spawnStopper()
    spawnSideLines()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view!.presentScene(GameScene(size: size))
  }
};
