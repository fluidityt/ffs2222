import SpriteKit
import PlaygroundSupport

let size = CGSize(width: 600, height: 500)
let view = SKView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
view.showsPhysics = true
let scene = GameScene(size: size)
scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
scene.physicsBody = SKPhysicsBody(edgeLoopFrom: scene.frame)
PlaygroundPage.current.liveView = view
view.presentScene(scene)
//view.frameInterval = 4
struct Category {
  static let
  none = UInt32(0), player = UInt32(1), enemy = UInt32(2)
}

struct DoContact {
  var contact: SKPhysicsContact
  
  func blackAndYellow() {
    
  }
  
  
}

class GameScene: SKScene {
 
  var playerIsJumping = false
  var playerIsOnPlatform = false
  
  var playerStarting = CGPoint.zero
  var enemyStarting  = CGPoint.zero
  
  func keepPlayerOnPlatform() {
    let enemyDX = enemyStarting.x - enemy.position.x
    player.position.x += enemyDX
  }
  
  func collide() {
    if playerIsJumping {
      return
    }
    
    if playerIsOnPlatform {
      return
    }
    
    if player.position.y > enemy.position.y {
      player.position.y = enemy.position.y
      player.position.y += player.size.height/2
      player.position.y += enemy.size.height/2
      player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
      player.run(enemy.action(forKey: "sup")!)
    }
    
    playerIsOnPlatform = true
  }
  
  func jump() {
    let vector = CGVector(dx: 0, dy: 30)
    playerIsJumping = true
    
    if playerIsOnPlatform {
      playerIsOnPlatform = false
    }
    
    player.removeAllActions()
    player.physicsBody?.applyImpulse(vector)
  }
  
  func keepPlayerInBounds(){
    if player.position.y  < frame.minY {
      player.position.y = frame.minY + player.size.height/2
    }
  }
  
  override func didFinishUpdate() {
    if playerIsJumping { playerIsJumping = false }
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
    // keepPlayerInBounds()
  }
  
  override func update(_ currentTime: TimeInterval) {
    playerStarting = player.position
     enemyStarting = enemy.position
  }
  
  // http://stackoverflow.com/questions/31574049/moving-node-on-top-of-a-moving-platform
  // http://www.learn-cocos2d.com/2013/08/physics-engine-platformer-terrible-idea/
  
  var player: SKSpriteNode = {
    let player = SKSpriteNode(color: .green, size: CGSize(width: 30, height: 30))
    let newPB = SKPhysicsBody(rectangleOf: player.size)
    
    player.physicsBody = newPB
    
      return player
  }()
  
  var enemy: SKSpriteNode = {
   let enemy = SKSpriteNode(color: .blue, size: CGSize(width: 200, height: 10))
    enemy.position.x += 200
    
    let newPB = SKPhysicsBody(rectangleOf: enemy.size)
    newPB.isDynamic = false
    enemy.physicsBody = newPB
      return enemy
  }()

  func enemyAnimation() {
    let leftPoint = CGPoint(x: frame.minX, y: frame.midY)
    let rightPoint = CGPoint(x: frame.maxX, y: frame.midY)
    
    let action1 = SKAction.move(to: leftPoint, duration: 3)
    let action2 = SKAction.move(to: rightPoint, duration: 3)
    let sequence = SKAction.sequence([action1, action2])
    let repeating = SKAction.repeatForever(sequence)
    enemy.run(repeating, withKey: "sup")
  }

  override func didMove(to view: SKView) {
    addChild(player)
    addChild(enemy)
  enemyAnimation()
    
  }


  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    jump()
  }
  
}
