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
    
    let
    pointY      = localGS.nextPos.y,
    leftPoint   = CGPoint(x: frame.minX, y: pointY),
    rightPoint  = CGPoint(x: frame.maxX, y: pointY),
    
    randomSpeed = TimeInterval(1 + randy(3)),
    action1     = SKAction.move(to: leftPoint,  duration: randomSpeed),
    action2     = SKAction.move(to: rightPoint, duration: randomSpeed),
    sequence    = SKAction.sequence([action1, action2]),
    repeating   = SKAction.repeatForever(sequence)
    
    enemy.run(repeating)
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
    
    localGS.nextPos = enemy.position
    localGS.nextPos.y += enemy.size.height
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
    localGS.nextPos = enemy.position
    localGS.nextPos.y += enemy.size.height
    localGS.addChild(enemy)
  }
}
