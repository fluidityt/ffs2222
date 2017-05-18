//
//  file2.swift
//  ffs2222

import SpriteKit

class Spawner2 {
  
  private var localGS = GameScene2()
  private var spawnCount = 0
  
  // convenience:
  private var player: SKSpriteNode { return localGS.player }
  private var frame: CGRect        { return localGS.frame }
  
  // Difficulty:
  private let
  baseSpeed = 1.5,
  speedMod  = 2.5,
  baseSize  = 50,
  sizeMod   = 150
  
  // Init:
  init(gs: GameScene2) { self.localGS = gs }
  
  // Funky:
  private func addToHash(enemy: SKSpriteNode) {
    localGS.enemyHash[enemy.name!] = enemy
  }
  
  private func animate(enemy: SKSpriteNode) {
    /* fast = 2; let slow = 3; let norm = 2.5 */
    
    func findFirstPointX() -> CGFloat {
      if enemy.position.x < 0 { return frame.maxX } // move to right
      else { return frame.minX }                    // move to left
    }
    func findSecondPointX() -> CGFloat {
      if enemy.position.x < 0 { return frame.minX } // move to right
      else { return frame.maxX }                    // move to left
    }
    
    let
    pointY       = localGS.nextPos.y,
    firstPoint   = CGPoint(x: findFirstPointX(), y: pointY),
    secondPoint  = CGPoint(x: findSecondPointX(), y: pointY),
    
    randomSpeed = TimeInterval(baseSpeed + randy(speedMod)),
    action1     = SKAction.move(to: firstPoint,  duration: randomSpeed),
    action2     = SKAction.move(to: secondPoint, duration: randomSpeed),
    sequence    = SKAction.sequence([action1, action2]),
    repeating   = SKAction.repeatForever(sequence)
    
    enemy.run(repeating)
  }
  
  private func pickNextPos(spawnedNode node: SKSpriteNode) -> CGPoint {
    var returnPos = node.position
    returnPos.y += 2
    returnPos.y += node.size.height
    
    // Spawn two up?:
    if randy(2) == 1 { returnPos.y += node.size.height }
    
    // Spawn on left?
    if player.position.y > frame.midX - frame.size.width/4 {
      returnPos.x = frame.minX - node.size.width/2
    }
    else { returnPos.x = frame.maxX + node.size.width/2 }
    
    return returnPos
  }
  
  func startingLineAndPlayer() {
    spawnCount += 1
    let enemy = SKSpriteNode(color: .blue, size: CGSize(width: 200, height: 40)); do {
      let newPB = SKPhysicsBody(rectangleOf: enemy.size)
      newPB.restitution = 0
      newPB.isDynamic = false
    
      enemy.physicsBody = newPB
      enemy.position = CGPoint(x: 0, y: frame.minY)
      enemy.name = "enemy0"
    }
    addToHash(enemy: enemy)
    
    localGS.platformPlayerIsOn = enemy
    localGS.playerIsOnPlatform = true
    
    localGS.nextPos = pickNextPos(spawnedNode: enemy)
    localGS.addChild(enemy)
    localGS.addChild(player)
    localGS.putNodeOnTopOfAnother(put: player, on: enemy)
  }
  
  func blackLine(pos: CGPoint) {
    spawnCount += 1
    let randomWidth = CGFloat(baseSize + randy(sizeMod))
    
    let enemy = SKSpriteNode(color: .blue, size: CGSize(width: randomWidth, height: 40)); do {
      let newPB = SKPhysicsBody(rectangleOf: enemy.size)
      newPB.categoryBitMask = categoryEnemy
      newPB.contactTestBitMask = categoryPlayer
      newPB.restitution = 0
      newPB.isDynamic = false
      newPB.usesPreciseCollisionDetection = true
 
      enemy.physicsBody = newPB
      enemy.position = pos
      enemy.name = "enemy" + String(spawnCount)
      if randomWidth < 100 { enemy.color = .purple }
      
      animate(enemy: enemy)
    }
    addToHash(enemy: enemy)
    
    localGS.nextPos = pickNextPos(spawnedNode: enemy)
    localGS.addChild(enemy)
  }
}

class DoContact2 {
  var localGS = GameScene2(size: CGSize.zero)
  var contact = SKPhysicsContact()
  var player: SKSpriteNode { return localGS.player }
  
  init(contact: SKPhysicsContact, gameScene: GameScene2) {
    self.contact = contact
    localGS = gameScene
  }
  
  private func assignYellowBlack() ->  (player: SKPhysicsBody, enemy: SKPhysicsBody) {
    
    if contact.bodyA.categoryBitMask == categoryPlayer {
      return (contact.bodyA, contact.bodyB)
    }   else { return (contact.bodyB, contact.bodyA) }
  }
  
  func blackAndYellow() {
    
    let gs = localGS
    let (playerPB, enemyPB) = assignYellowBlack()
    guard
      let playerNode = playerPB.node as? SKSpriteNode,
      let enemyNode  = enemyPB .node as? SKSpriteNode else { fatalError("no nodes") }
    
    
    let playRightX = gs.convert(CGPoint(x: playerNode.position.x + playerNode.size.width/2,
                                        y: playerNode.position.y), from: playerNode).x
    let enemLeftX  = gs.convert(CGPoint(x: enemyNode .position.x - enemyNode.size.width/2,
                                        y: enemyNode.position.y), from: enemyNode).x
    let playLeftX  = gs.convert(CGPoint(x: playerNode.position.x - playerNode.size.width/2,
                                        y: playerNode.position.y), from: playerNode).x
    let enemRightX = gs.convert(CGPoint(x: enemyNode .position.x + enemyNode.size.width/2,
                                        y: enemyNode.position.y), from: enemyNode).x
    // CHeck left / right hit:
    if playRightX <= enemLeftX || playLeftX >= enemRightX {
      gs.dead = true
      return
    }
    
    // Check if same hit:
    else if enemyNode === gs.platformPlayerIsOn {
      return
    }
      
      // Player is above the contacted node:
      
      /*if (playerNode.position.y - playerNode.frame.size.height/2)
       > (enemyNode.position.y - enemyNode.frame.size.height/2) {*/
      
    else if playerNode.position.y > enemyNode.position.y {
      //gs.putNodeOnTopOfAnother(put: playerNode, on: enemyNode)
      gs.platformPlayerIsOn  = enemyNode
      gs.playerIsOnPlatform  = true
      playerNode.physicsBody = GameScene2.makePlayerPB(player: playerNode)
      return
    }
      
    else {
      gs.dead = true
    }
    
  }
  
}
// Not really a scene:
extension GameScene2: SKPhysicsContactDelegate {
  
  func didBegin(_ contact: SKPhysicsContact) {
    print("db")
    let doContact = DoContact2(contact: contact, gameScene: self)
    
    let contactedCategories = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
    
    switch contactedCategories {
    case categoryPlayer | categoryEnemy:
      doContact.blackAndYellow()
    default:
      ()
    }
  }
  
  func didEnd(_ contact: SKPhysicsContact) {
    //self.contact = contact
  }
  
}
