//
//  file2.swift
//  ffs2222

import SpriteKit

class Spawner2 {
  
  static var nextPoint = CGPoint.zero
  let localGS = SKScene()
  
  func blackLine(pos: CGPoint) {
    let enemy = SKSpriteNode(color: .blue, size: CGSize(width: 200, height: 10))
    enemy.position.x += 200
    
    
    let newPB = SKPhysicsBody(rectangleOf: enemy.size)
    newPB.restitution = 0
    newPB.isDynamic = false
    enemy.physicsBody = newPB
   localGS.addChild(enemy)
  }
  
  
}
