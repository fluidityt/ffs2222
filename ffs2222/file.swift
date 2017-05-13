//
//  MainPlayer.swift
//  Primitive Survival
//
//  Created by Darin Wilson on 4/11/17.
//  Copyright © 2017 DarinDev. All rights reserved.
//

import SpriteKit

class Player2: SKSpriteNode {
  //ADDED FROM GRAPPLESCENE
  var chain: SKShapeNode!
  var chainTarget: SKSpriteNode!
  var hookTarget = CGPoint.zero
  
  struct ColliderType {
    
    static let Player: UInt32 = 0
    static let CollideBox: UInt32 = 1
    static let Collectables: UInt32 = 2
  }
  //DAW: Intialize player animations and locate images
  func intializePlayerAndAnimations() {
    
    let pb = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width, height: self.size.height)); do {
      pb.affectedByGravity = true
      pb.categoryBitMask   = ColliderType.Player
      pb.collisionBitMask  = ColliderType.CollideBox
      pb.collisionBitMask  = ColliderType.Collectables
      pb.allowsRotation    = false
      pb.linearDamping     = 0.5
    }
    self.physicsBody = pb
    
    self.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
    //ADDEDED FROM GRAPPLESCENE
    self.chain = SKShapeNode()
    self.addChild(chain)
    
    let chainTargetSize = CGSize(width: 10, height: 10)
    self.chainTarget = SKSpriteNode(color: UIColor.blue, size: chainTargetSize)
    self.addChild(chainTarget)
    self.chainTarget.physicsBody = SKPhysicsBody(circleOfRadius: 10)
    self.chainTarget.physicsBody?.isDynamic = false
  }
  
  // THE TOUCHES FUNCTIONS ARE ADDED FROM GRAPPLESCENE
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    hookTarget = location
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) { }
  
  func animatePlayer(moveLeft: Bool) { }
  
  func stopAnimation() {}
  
  //DAW: Moving Player.
  func movePlayer(moveLeft: Bool) {
    if moveLeft { self.position.x -= 5 } else { self.position.x += 5 }
  }
};

// MARK: - GrappleScene:
class GrappleScene: SKScene {

  var player = Player2(color: .black, size: CGSize(width: 100, height: 100))
  // ADDED FROM GRAPPLESCENE
  
  
  override func update(_ currentTime: TimeInterval) {

    guard let chainTarget = player.chainTarget else { return }
    let hookTarget  = player.hookTarget
    
    //DAW: Move the ropeTarget to the hookTarget position
    chainTarget.position.x -= (chainTarget.position.x - hookTarget.x) * 0.5
    chainTarget.position.y -= (chainTarget.position.y - hookTarget.y) * 0.5
    
    //DAW: Move the player to the hookTarget slower than the ropeTarget
    position.x -= (player.position.x - hookTarget.x) * 0.2
    position.y -= (player.position.y - hookTarget.y) * 0.2
    
    
    //DAW: Draw a line between the two positions
    let chainPath = CGMutablePath()
    chainPath.move(to: CGPoint(x: player.position.x, y: player.position.y))
    chainPath.addLine(to: chainTarget.position)
    
    player.chain.path = chainPath
    player.chain.strokeColor = UIColor.yellow
    player.chain.lineWidth = 4
  }
}
