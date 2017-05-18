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
  private let baseSpeed = 1,
  speedMod  = 3,
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
    
    randomSpeed = TimeInterval(1 + randy(3)),
    action1     = SKAction.move(to: firstPoint,  duration: randomSpeed),
    action2     = SKAction.move(to: secondPoint, duration: randomSpeed),
    sequence    = SKAction.sequence([action1, action2]),
    repeating   = SKAction.repeatForever(sequence)
    
    enemy.run(repeating)
  }
  
  private func pickNextPos(spawnedNode node: SKSpriteNode) -> CGPoint {
    var returnPos = node.position
    returnPos.y += node.size.height
    
    // Spawn two up?:
    if randy(2) == 1 { returnPos.y += node.size.height }
    
    // Spawn on left?
    if randy(2) == 1 { returnPos.x = frame.minX - node.size.width/2 }
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
      newPB.restitution = 0
      newPB.isDynamic = false
 
      enemy.physicsBody = newPB
      enemy.position = pos
      enemy.name = "enemy" + String(spawnCount)
      if randomWidth < 75 { enemy.color = .purple }
      
      animate(enemy: enemy)
    }
    addToHash(enemy: enemy)
    
    localGS.nextPos = pickNextPos(spawnedNode: enemy)
    localGS.addChild(enemy)
  }
}

// Not really a scene:
class PhysicsDelegate: SKScene, SKPhysicsContactDelegate {

  var localGS = GameScene2(size: CGSize.zero)
  var contact = SKPhysicsContact()
  
  var player: SKSpriteNode { return localGS.player }
  
  private func assignYellowBlack() ->  (player: SKPhysicsBody, enemy: SKPhysicsBody) {
    
    if contact.bodyA.categoryBitMask == categoryPlayer {
      return (contact.bodyA, contact.bodyB)
    }   else { return (contact.bodyB, contact.bodyA) }
  }
  
  func blackAndYellow() {
    
    let (playerPB, enemyPB) = assignYellowBlack()
    
    guard let playerNode = playerPB.node, let enemyNode = enemyPB.node else { fatalError("no nodes") }
    
    if playerNode
    
  }
  
  func didBegin(_ contact: SKPhysicsContact) {
    self.contact = contact
    
    let contactedCategories = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
    
    
    switch contactedCategories {
    case categoryPlayer | categoryPlayer:
      blackAndYellow()
    default:
      ()
    }
  }
  
  func didEnd(_ contact: SKPhysicsContact) {
    self.contact = contact
  }
  
}
