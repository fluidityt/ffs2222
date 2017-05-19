import SpriteKit
import PlaygroundSupport

print("hi")
let size = CGSize(width: 600, height: 500)
let view = SKView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
view.showsPhysics = true
let scene = GameScene(size: size)
scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)

PlaygroundPage.current.liveView = view
view.presentScene(scene)

class Sprite: SKSpriteNode {

  var category = ""
  var contact  = ""
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let t = touches.first else { return }
    self.position = t.location(in: self.scene!)
  }
}

class GameScene: SKScene {
  typealias CollidedNodes = (bodyA: SKSpriteNode, bodyB: SKSpriteNode)
  
  
  // Proppy:
  var categories: [String: Set<Sprite>] = ["": Set<Sprite>()]
  
  var playerIsOnPlatform = true
  
  lazy var player: Sprite = {
    let player = Sprite(color: .yellow, size: CGSize(width: 30, height: 30))
    player.isUserInteractionEnabled = true
    player.name = "player"
    player.category = "player"
    player.contact  = "enemy"
    self.addSpriteToCategory(player)
    return player
  }()
  
  lazy var playerJumper: PlayerJumper = {
    PlayerJumper(player: self.player, scene: self)
  }()
  
  lazy var enemy: Sprite = {
    let enemy = Sprite(color: .black, size: CGSize(width: 30, height: 30))
    enemy.isUserInteractionEnabled = true
    enemy.name = "enemy"
    enemy.category = "enemy"
    enemy.contact  = "player"
    self.addSpriteToCategory(enemy)
    return enemy
  }()

  lazy var missile: Sprite = {
    let missile = Sprite(color: .black, size: CGSize(width: 30, height: 30))
    missile.isUserInteractionEnabled = true
    missile.name = "missile"
    missile.category = "missile"
    missile.contact  = "player"
    self.addSpriteToCategory(missile)
    return missile
  }()
  
  func addSpriteToCategory(_ sprite: Sprite) {
    if categories[sprite.category] == nil { categories[sprite.category] = [sprite]      }
    else                                  { categories[sprite.category]!.insert(sprite) }
  }
  
  func checkCollisions() -> [CollidedNodes] {
    
    var collided: [CollidedNodes] = []
    
    func canAddToCollided(sprite0: Sprite, sprite1: Sprite) -> Bool {
      
      for i in collided {
        if i.0 == sprite1 && i.1 == sprite0 { return false }
      }
      
      // Base case:
      return true
    }
    
    var checkedKeys: [String] = []
    
    for key in categories.keys {
      
      for sprite in categories[key]! {
        
        for secondKey in categories.keys {
          
          if secondKey == key { continue }
          if checkedKeys.contains(secondKey) { continue }
          
          if sprite.contact == secondKey {
            
            for secondSprite in categories[secondKey]! {
              
              if sprite.frame.intersects(secondSprite.frame) {
                
                if canAddToCollided(sprite0: sprite, sprite1: secondSprite) {
                  collided.append((sprite, secondSprite))
                }
              }
            }
          }
        }
      }
    
     checkedKeys.append(key)
    }
    
    // Check if any of our collided have collided (3+ collided):
    
    /*
    for l in collided {
      print(l.0)
      print(l.1)
      print("")
    }*/
    
    return collided
  }
  
  override func didMove(to view: SKView) {
    addChild(player)
    addChild(enemy)
    addChild(missile)
  }
  
  // Game loop:
  override func didEvaluateActions() {
    let collidedNodes = checkCollisions()
    
    if collidedNodes.isEmpty { return }
    else {
      print("hiii")
    }
  }
  
  override func didSimulatePhysics() {
    if player.position.y <= playerJumper.startingY || playerIsOnPlatform == true {
      
    }
  }
}

class PlayerJumper {
  
  let scene:  GameScene
  let player: Sprite
  
  var startingY: CGFloat { return self.scene.frame.minY             }
  var maxHeight: CGFloat { return startingY + scene.size.height / 4 }
  
  let timeTomaxHeight = TimeInterval(0.5 )
  let delayBeforeFall = TimeInterval(0.25)
  let timeToMinHeight = TimeInterval(0.30)
  
  init(player: Sprite, scene: GameScene) { self.player = player; self.scene = scene }
  
}