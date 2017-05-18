import SpriteKit

// http://stackoverflow.com/questions/31574049/moving-node-on-top-of-a-moving-platform
// http://www.learn-cocos2d.com/2013/08/physics-engine-platformer-terrible-idea/


// try a contacter, or just do a fake physics body? 

let categoryPlayer = UInt32(1)
let categoryEnemy  = UInt32(2)

class GameScene2: SKScene {
  
  // var:
  var
  playerIsJumping = false,
  playerIsOnPlatform = false,
  platformPlayerIsOn: SKSpriteNode? = SKSpriteNode(),
  enemyHash = ["first": SKSpriteNode()],
  hitEnemy = SKSpriteNode(),
  
  playerY = CGFloat(0),
  enemyStarting  = CGPoint.zero,
  nextPos = CGPoint(x: 0, y: 0),
  
  dead = false
  
  // let:
  let
  gravityUp   = CGVector(dx: 0, dy: -20),
  gravityDown = CGVector(dx: 0, dy: -30),
  jumpPower   = CGVector(dx: 0, dy: 55 ),
  playerMass  = CGFloat(1)
  
  // Player:
  let player: SKSpriteNode = {
    let player2 = SKSpriteNode(color: .green, size: CGSize(width: 30, height: 50))
    
    player2.physicsBody = GameScene2.makePlayerPB(player: player2)
    
    return player2
  }()
  
  // MARK: - Funky:
  private static func makePlayerPB(player: SKSpriteNode) -> SKPhysicsBody {
    
    let newPB = SKPhysicsBody(rectangleOf: player.size)
    newPB.restitution = 0
    // newPB.mass = playerMass
    return newPB
  }
  
  private func selfInit() {
    anchorPoint = CGPoint(x: 0.5, y: 0.5)
    physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    physicsWorld.gravity = gravityUp
  }
  
  func putNodeOnTopOfAnother(put node1: SKSpriteNode, on node2: SKSpriteNode) {
    node1.position.y = node2.position.y
    node1.position.y += node1.size.height/2
    node1.position.y += node2.size.height/2
  }
  
  func checkCollision() -> SKSpriteNode? {
    
    for node in enemyHash.values {
      guard player.frame.intersects(node.frame) else { continue }
    
      if let ppio = platformPlayerIsOn {
        print("found ppio")
        // Isn't there a better way to just ensure that ppio is never found once set?
        if ppio == node { continue }
      }
      else {
        print("found not ppio")
        hitEnemy = node
        return node
      }
    }
    // Base case:
    return nil
  }
  
  func collide(with node: SKSpriteNode) {
    // if playerIsJumping { return }
    // if playerIsOnPlatform { return }
    
    assert(node != platformPlayerIsOn) // handled in checker.
    
    if (player.position.y - player.size.height/2) > (node.position.y - node.size.height/2) {
      putNodeOnTopOfAnother(put: player, on: node)
      player.physicsBody = GameScene2.makePlayerPB(player: player)
      platformPlayerIsOn = node // will stop calling collide on this node until jump.
      playerIsOnPlatform = true
    }
    
    else {
      dead = true
      // TODO: playDeathAnimation()
    }
    
  }
  
  func keepPlayerOnPlatform() {
    assert(playerIsOnPlatform, "wtf happened")
    guard let ppio = platformPlayerIsOn else { fatalError("why is this called") }
    
    let enemyDX = enemyStarting.x - ppio.position.x
    putNodeOnTopOfAnother(put: player, on: ppio)
    player.position.x -= enemyDX
  }
  
  func jump() {
    platformPlayerIsOn = nil
    playerIsJumping    = true
    playerIsOnPlatform = false
    
    physicsWorld.gravity = gravityUp
    player.physicsBody   = GameScene2.makePlayerPB(player: player)
    player.removeAllActions()
    player.physicsBody?.applyImpulse(jumpPower)
  }
  
  func keepPlayerInBounds(){
    if player.position.y  < frame.minY {
      player.position.y = frame.minY + player.size.height/2
    }
  }
  
  func updateSpawner() {
    let wait = SKAction.wait(forDuration: 3)
    let run = SKAction.run {
      Spawner2(gs: self).blackLine(pos: self.nextPos)
      self.updateSpawner()
    }
    let sequence = SKAction.sequence([wait, run])
    self.run(sequence)
  }
  
  // Initials + touches:
  override func didMove(to view: SKView) {
    selfInit()
    Spawner2(gs: self).startingLineAndPlayer()
    updateSpawner()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    jump()
  }
}

// MARK: - Game loop:
extension GameScene2 {
  
  override func update(_ currentTime: TimeInterval) {
    if let ppio = platformPlayerIsOn {
      enemyStarting = ppio.position // set for keepOnPlatform()
    }
    
    playerY = player.position.y    // set for dfu check
  }
  
  override func didEvaluateActions() {
  }
  
  override func didSimulatePhysics() {
    if let hitNode = checkCollision() {
      collide(with: hitNode)
    }
    
    if playerIsOnPlatform { keepPlayerOnPlatform() }

    keepPlayerInBounds()
  }
  
  override func didFinishUpdate() {
    if playerIsJumping { playerIsJumping = false }
    
    // Player will fall with more gravity than jump:
    if player.position.y < playerY {
      physicsWorld.gravity = gravityDown
    }
    
    if dead {
      view?.presentScene(GameScene2(size: size))
    }
    
  }

}
