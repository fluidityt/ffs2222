import SpriteKit

// ************************************************************* //

fileprivate func killNode(_ node: SKNode) {
  node.physicsBody = nil
  node.removeAllChildren()
  node.removeAllActions()
  node.removeFromParent()
}

// Globals:
var gview = SKView()
var score = 0 // Too lazy to make an init for other scenes...
var highscore: Int = 0


func randy(_ num: Int) -> Int { return Int(arc4random_uniform(UInt32(num)))+1 }

struct UD {
  
  static let userDefaults = UserDefaults.standard
  
  struct Keys {
    static let highscore = "highschore"
  }
  
  static func saveHighScore() {
    
    guard let oldHS = userDefaults.value(forKey: Keys.highscore) as? Int else { print("bad key"); return }
    if score > oldHS {
      userDefaults.setValue(score, forKey: Keys.highscore)
      print("saved high score!")
    }
  }
  static func loadHighScore() {
    guard let value = userDefaults.value(forKey: Keys.highscore) else { print("no hs in UD"); return }
    guard let hs = value as? Int else { print("value was not Int"); return }
    highscore = hs
    print("loaded high score!")
  }
  static func initUserDefaults() {
    if userDefaults.value(forKey: Keys.highscore) == nil {
      userDefaults.setValue(0, forKey: Keys.highscore)
    }
  }
};

func setMasks(pb: SKPhysicsBody, cat: UInt32, cont: UInt32, col: UInt32) {
  pb.categoryBitMask = cat
  pb.contactTestBitMask = cont
  pb.collisionBitMask = col
}
// ************************************************************* //

//
// MARK: - GameScene init and stuff:
//
class GameScene: SKScene, SKPhysicsContactDelegate {
  
  enum Category {
    static let
    zero =    UInt32 (0),    yellow =  UInt32 (1),    black =   UInt32 (2),
    three =   UInt32 (4),    line  =   UInt32 (8),    death =   UInt32 (16)
  };
  
  /// Static funcs to spawn stuff:
  struct Spawn {
    
    private typealias C = Category
    
    private var gsi: GameScene
    
    init(gsi: GameScene) { self.gsi = gsi }
    
    func yellowNode() {
      
      let newPB = SKPhysicsBody(rectangleOf: gsi.size30)
      setMasks(pb: newPB, cat: C.yellow, cont: C.black, col: C.zero)
      newPB.affectedByGravity  = false
      
      let yellowNode = Stuff(color: .blue, size: gsi.size30)
      yellowNode.position.x += 35
      yellowNode.position.y = gsi.frame.minY + 35
      yellowNode.physicsBody = newPB
      gsi.addChild(yellowNode)
      
      gsi.player = yellowNode
    }
    
    func blackNode(pos: CGPoint)  {
      
      let newPB = SKPhysicsBody(rectangleOf: gsi.size30)
      setMasks(pb: newPB, cat: C.black, cont: C.yellow | C.death, col: C.zero)
      
      let blackNode = SKSpriteNode(color: .white, size: gsi.size30)
      blackNode.name     = "black"
      blackNode.position = pos
      blackNode.physicsBody = newPB
      gsi.addChild(blackNode)
    }
    
    func scanline(pos: CGPoint) {
      
      let lineNode = SKSpriteNode(color: .clear, size: CGSize(width: gsi.frame.width, height: 1))
      let newPB = SKPhysicsBody(rectangleOf: lineNode.size)
      setMasks(pb: newPB, cat: C.line, cont: C.yellow | C.death, col: C.zero)
      
      lineNode.physicsBody = newPB
      lineNode.position = pos
      gsi.addChild(lineNode)
    }
    
    func deathLine() {
      
      let lineNode = SKSpriteNode(color: .orange, size: CGSize(width: gsi.frame.width + 1000,
                                                               height: 2))
      let newPB = SKPhysicsBody(rectangleOf: lineNode.size)
      newPB.affectedByGravity = false
      setMasks(pb: newPB, cat: C.death, cont: C.black, col: C.zero)
      
      lineNode.physicsBody = newPB
      // lineNode.position.y = frame.minY - size30.height
      gsi.addChild(lineNode)
    }
    
    func touchPad() {
      let touchPad = TouchPad(player: gsi.player!, scene: gsi)
      touchPad.position.y -= touchPad.size.height / 2
      gsi.addChild(touchPad)
    }
    
    func lineOfBlackBoxes() {
      
      let yVal = gsi.frame.maxY + (gsi.size30.height/2)
      let numBoxes = gsi.difficultyBoxNum + randy(6)
      
      for _ in 1...numBoxes {
        let randomX = randy(Int(gsi.frame.maxX * 2))
        let xVal = CGFloat(randomX) - gsi.frame.maxX
        blackNode(pos: CGPoint(x: xVal, y: yVal))
      }
      
      scanline(pos: CGPoint(x: 0, y: yVal))
    }
  };
  
  /// Props:
  var
  difficultyBoxNum = 4,
  difficultyBoxSpeed = Double(1),
  difficultyBoxSize = CGFloat(1.5),
  action: SKAction?
  
  var player: Stuff?
  
  lazy var size30: CGSize = CGSize(width: 30, height: 30)
  
  private lazy var spawn: Spawn = Spawn(gsi: self)
  
  private func selfInit() {
    //view!.frame = CGRect(x: 0, y: 0, width: 350, height: 350)
    scaleMode = .aspectFit
    anchorPoint = CGPoint(x: 0.5, y: 0.5)
    physicsWorld.contactDelegate = self
    physicsWorld.gravity = CGVector(dx: 0, dy: -0.25)
    
    let starterLabel = SKLabelNode(text: "DODGE FALLING BOXES!! Win at 50!!")
    let starterNode = SKSpriteNode()
    starterNode.size = starterLabel.frame.size
    starterNode.physicsBody = SKPhysicsBody(rectangleOf: starterNode.size)
    starterNode.addChild(starterLabel)
    starterNode.position.y -= 50
    
    addChild(starterNode)
  }
  
  func updateAction() {
    
    removeAction(forKey: "spawner")
    let wait     = SKAction.wait(forDuration: difficultyBoxSpeed)
    let run      = SKAction.run { self.spawn.lineOfBlackBoxes() }
    let sequence = SKAction.sequence([wait, run])
    self.action  = SKAction.repeatForever(sequence)
    
    self.run(action!, withKey: "spawner")
  }
  
  override func didMove(to view: SKView) {
    
    UD.initUserDefaults()
    UD.loadHighScore()
    
    print("Welcome to Sprite Attack! Your HS is \(highscore)")
    
    selfInit()
    spawn.yellowNode()
    spawn.lineOfBlackBoxes()
    spawn.deathLine()
    spawn.touchPad()
  
    updateAction()
    //gs.hits = -500
    score = 0
    // OMFG what have I become??
  }
}

//
// MARK: - Game Loop:
//
extension GameScene {
  struct gs {
    static var waiting = false      // Used for score increase at end of loop.
    static var hits = 0             // Player HP.
    static var hitThisFrame = false // Used to keep player alive when hit 2 black at same time.
  }
  
  override func update(_ currentTime: TimeInterval) {
    gs.hitThisFrame = false
    
    if (player?.position.y)! < frame.midY {
      player!.position.y = frame.midY
    }
  }
  
  private func doBlackAndYellow(contact: SKPhysicsContact) {
    
    func assignYellowBlack() ->  (SKPhysicsBody, SKPhysicsBody) {
      if contact.bodyA.categoryBitMask == Category.yellow {
        return (contact.bodyA, contact.bodyB)
      } else {
        return (contact.bodyB, contact.bodyA)
      }
    }
    
    gs.hitThisFrame = true
    
    let (yellowNode, blackNode) = assignYellowBlack()
    
    // yellowNode.node?.setScale(difficultyBoxSize)
    blackNode.node?.removeFromParent()
  }
  
  private func doYellowAndLine(contact: SKPhysicsContact) {
    score += 1
    print(score)
    
    if contact.bodyA.categoryBitMask == Category.line {
      if let a = contact.bodyA.node { killNode(a) }
    } else {
      if let b = contact.bodyB.node { killNode(b) }
    }
  }
  
  private func doDeathAndBlack(contact: SKPhysicsContact) {
    if contact.bodyA.categoryBitMask == Category.black {
      if let a = contact.bodyA.node { killNode(a) }
    } else {
      if let b = contact.bodyB.node { killNode(b) }
    }
  }
  
  private func doDeathAndLine(contact: SKPhysicsContact) {
    if contact.bodyA.categoryBitMask == Category.line {
      if let a = contact.bodyA.node { killNode(a) }
    } else {
      if let b = contact.bodyB.node { killNode(b) }
    }
  }
  
  func didBegin(_ contact: SKPhysicsContact) {
    
    defer { UD.saveHighScore() }
    
    let contactedCategories = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
    
    switch contactedCategories {
    case Category.black  | Category.yellow : doBlackAndYellow(contact: contact)
    case Category.yellow | Category.line   : doYellowAndLine (contact: contact)
    case Category.black  | Category.death  : doDeathAndBlack (contact: contact)
    case Category.line   | Category.death  : doDeathAndLine  (contact: contact)
    default: ()
    }
  }
  
  override func didSimulatePhysics() {
    if gs.hitThisFrame { gs.hits += 1 }
    if gs.hits >= 2    {
      gs.hits = 0 // FIXME: Reset for next game since this is not an instance variable... what?
      view!.presentScene(FailScene(size: size))
    }
  }
  
  /// Difficulty:
  override func didFinishUpdate() {
    
    func upDifficulty() {
      print("difficulty up!")
      difficultyBoxNum += 1
      difficultyBoxSpeed -= 0.1
      updateAction()
      
      if gs.waiting { gs.waiting = false }
      else { gs.waiting = true }
    }
    
    switch score {
    // case <#num#>: if  <#excl#>gs.waiting { upDifficulty() }
    case 10: if !gs.waiting { upDifficulty() }
    case 20: if  gs.waiting { upDifficulty() }
    case 30: if !gs.waiting { upDifficulty() }
      //case 40: if  gs.waiting { upDifficulty() }
      /*    case 50: if !gs.waiting { upDifficulty() }
       case 60: if  gs.waiting { upDifficulty() }
       case 70: if !gs.waiting { upDifficulty() }
       case 80: if  gs.waiting { upDifficulty() }
       case 90: if !gs.waiting { upDifficulty() }
       case 100: view!.presentScene(WinScene(size: size))*/
    default: ()
    }
  }
};

//
// MARK: - Other classes:
//
final class TouchPad: SKSpriteNode {
  
  private var playerInstance: Stuff
  
  init(player: Stuff, scene: SKScene) {
    playerInstance = player
    
    let color = SKColor.white
    let size = CGSize(width: scene.size.width, height: (scene.size.height/2))
    super.init(texture: nil, color: color, size: size)
    
    isUserInteractionEnabled = true
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError() }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    let t = touches.first!
    
    let dx = (t.location(in: self).x - t.previousLocation(in: self).x)
    let dy = (t.location(in: self).y - t.previousLocation(in: self).y)
    
    playerInstance.position.x += dx
    playerInstance.position.y += dy
  }
};

final class Stuff: SKSpriteNode {
  
  init(color: SKColor, size: CGSize) {
    super.init(texture: nil, color: color, size: size)
    isUserInteractionEnabled = true
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError() }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    position = touches.first!.location(in: self.scene!)
    
  }
  
}

class WinScene: SKScene {
  override func didMove(to view: SKView) {
    scaleMode = .aspectFit
    anchorPoint = CGPoint(x: 0.5, y: 0.5)
    addChild(SKLabelNode(text: "YOU WON! PLAY AGAIN"))
    score = 0
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view!.presentScene(GameScene(size: size))
  }
  
};

class FailScene: SKScene {
  override func didMove(to view: SKView) {
    scaleMode = .aspectFit
    anchorPoint = CGPoint(x: 0.5, y: 0.5)
    addChild(SKLabelNode(text: "score: \(score)! | highscore: \(highscore) |   PLAY AGAIN"))
    
    score = 0
  }
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view!.presentScene(GameScene(size: size))
  }
};


