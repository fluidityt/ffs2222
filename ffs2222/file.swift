import SpriteKit

// http://stackoverflow.com/questions/31574049/moving-node-on-top-of-a-moving-platform
// http://www.learn-cocos2d.com/2013/08/physics-engine-platformer-terrible-idea/

class GameScene2: SKScene {

  // Proppy:
  var playerIsJumping = false
  var playerIsOnPlatform = false
  
  var playerY = CGFloat(0)
  var enemyStarting  = CGPoint.zero
  
  let gravityUp   = CGVector(dx: 0, dy: -20)
  let gravityDown = CGVector(dx: 0, dy: -30)
  let jumpPower   = CGVector(dx: 0, dy: 45 )
  let playerMass  = CGFloat(1)

  
  // Funky:
  private static func makePlayerPB(player: SKSpriteNode) -> SKPhysicsBody {
    
    let newPB = SKPhysicsBody(rectangleOf: player.size)
    newPB.restitution = 0
    // newPB.mass = playerMass
    return newPB
  }
  
  func putPlayerOnTopOfPlatform() {
    player.position.y = enemy.position.y
    player.position.y += player.size.height/2
    player.position.y += enemy.size.height/2
  }
  
  func collide() {
    if playerIsJumping {
      return
    }
    
    if playerIsOnPlatform {
      return
    }
    
    if player.position.y > enemy.position.y {
      putPlayerOnTopOfPlatform()
      player.physicsBody = GameScene2.makePlayerPB(player: player)
    }
    
    playerIsOnPlatform = true
  }
  
  func keepPlayerOnPlatform() {
    let enemyDX = enemyStarting.x - enemy.position.x
    putPlayerOnTopOfPlatform()
    player.position.x -= enemyDX
  }
  
  func jump() {
    player.physicsBody = GameScene2.makePlayerPB(player: player)
    
    playerIsJumping = true
    
    physicsWorld.gravity = gravityUp
    
    if playerIsOnPlatform {
      playerIsOnPlatform = false
    }
    
    player.removeAllActions()
    player.physicsBody?.applyImpulse(jumpPower)
  }
  
  func keepPlayerInBounds(){
    if player.position.y  < frame.minY {
      player.position.y = frame.minY + player.size.height/2
    }
  }
  
  func enemyAnimation() {
    let leftPoint = CGPoint(x: frame.minX, y: frame.midY)
    let rightPoint = CGPoint(x: frame.maxX, y: frame.midY)
    
    let action1 = SKAction.move(to: leftPoint, duration: 3)
    let action2 = SKAction.move(to: rightPoint, duration: 3)
    let sequence = SKAction.sequence([action1, action2])
    let repeating = SKAction.repeatForever(sequence)
    enemy.run(repeating, withKey: "sup")
  }
  
  override func update(_ currentTime: TimeInterval) {
    enemyStarting = enemy.position // set for keepOnPlatform()
    playerY = player.position.y    // set for dfu check
  }
  
  override func didEvaluateActions() {
    if player.frame.intersects(enemy.frame) {
      collide()
    }
    
    if playerIsOnPlatform {
      keepPlayerOnPlatform()
    }
  }
  
  override func didSimulatePhysics() {
    keepPlayerInBounds()
  }
  
  override func didFinishUpdate() {
    if playerIsJumping { playerIsJumping = false }
    
    // Player will fall with more gravity than jump:
    if player.position.y < playerY {
      physicsWorld.gravity = gravityDown
    }
    
  }
  
  var player: SKSpriteNode = {
    let player2 = SKSpriteNode(color: .green, size: CGSize(width: 30, height: 30))

    player2.physicsBody = GameScene2.makePlayerPB(player: player2)
    
    return player2
  }()
  
  var enemy: SKSpriteNode = {
    let enemy = SKSpriteNode(color: .blue, size: CGSize(width: 200, height: 10))
    enemy.position.x += 200
    
    
    let newPB = SKPhysicsBody(rectangleOf: enemy.size)
    newPB.restitution = 0
    newPB.isDynamic = false
    enemy.physicsBody = newPB
    return enemy
  }()
  
  
  
  override func didMove(to view: SKView) {
    self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    addChild(player)
    
    enemyAnimation()
    
    self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    self.physicsWorld.gravity = gravityUp
    
    player.position.y = 0
  }
  
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    jump()
  }
  
}
