//
//  GameScene (loop).swift
//  ffs2222
//
//  Created by justin fluidity on 4/30/17.
//  Copyright © 2017 justin fluidity. All rights reserved.
//

import SpriteKit

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
  
  func randomMass(_ range: Int) -> CGFloat { return (CGFloat(randy(range)) / 100) }
  
  typealias C = Category
  
  func spawnBlackNode(pos: CGPoint)  {
    
    let blackNode = SKSpriteNode(color: .white, size: size30)
    let newPB = SKPhysicsBody(rectangleOf: size30)
    newPB.velocity.dy -= CGFloat(randy(100))
    blackNode.physicsBody = newPB
    

    blackNode.name     = "black"
    blackNode.position = pos
    addChild(blackNode)
  }
  
  func spawnStopper() {
    let pos = CGPoint(x: 0, y: self.frame.minY - 15)
    let size = CGSize(width: frame.width, height: 10)
    let stopper = SKSpriteNode(color: .blue, size: size)
    stopper.position = pos
    
    let newPB = SKPhysicsBody(rectangleOf: size)
    newPB.affectedByGravity = false
    newPB.pinned = true
    newPB.allowsRotation = false

    
    stopper.physicsBody = newPB
    addChild(stopper)
  }
  
  func spawnSideLines() {
    let sideL = SKSpriteNode(color: .orange, size: CGSize(width: 4,
                                                        height: frame.size.height * 2))
    let newPB = SKPhysicsBody(rectangleOf: sideL.frame.size)
    newPB.affectedByGravity = false
    newPB.allowsRotation = false
    newPB.pinned = true
    sideL.physicsBody = newPB
    
    let sideR = sideL.copy() as! SKSpriteNode
    
    sideL.position.x = frame.minX - 2
    sideL.position.y = frame.maxY
    
    sideR.position.x = frame.maxX + 2
    sideR.position.y = frame.maxY
    
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
    for i in 1...5 { //numBoxesY {
      makeHorizontalLine(atY: i)
    }
  }
  
  override func didMove(to view: SKView) {
    anchorPoint = CGPoint(x: 0.5, y: 0.5)
    
    dropBoxes()
    spawnStopper()
    spawnSideLines()
  }
};
