import SpriteKit

// MARK: - Main:
class GameScene: SKScene, SKPhysicsContactDelegate {
  
  enum Category {
    static let
    zero =    UInt32 (0),    yellow =  UInt32 (1),    black =   UInt32 (2),
    three =   UInt32 (4),    line  =   UInt32 (8),    death =   UInt32 (16)
  };
  
  var
  difficulty = (boxNum: 4, boxSpeed: 1.0, boxSize: CGFloat(1.5)),
  action: SKAction?,
  player: Stuff?
  
  lazy var size30: CGSize = CGSize(width: 30, height: 30)
  
};

// MARK: - Spawner
extension GameScene {
  struct Spawner {
    
    typealias C = Category
    
    var gsi: GameScene
    
    init(gsi: GameScene) { self.gsi = gsi }
    
    func yellowNode() {
      let yellowNode = Stuff(color: .blue, size: gsi.size30); do {
        let newPB = SKPhysicsBody(rectangleOf: gsi.size30); do {
          setMasks(pb: newPB, cat: C.yellow, cont: C.black, col: C.zero)
          newPB.affectedByGravity  = false
        }
        yellowNode.physicsBody = newPB
        yellowNode.position.x += 35
        yellowNode.position.y = gsi.frame.minY + 35
      }
      
      gsi.addChild(yellowNode)
      gsi.player = yellowNode
    }
    
    func blackNode(pos: CGPoint)  {
      
      let blackNode = SKSpriteNode(color: .white, size: gsi.size30); do {
        let newPB = SKPhysicsBody(rectangleOf: gsi.size30)
        setMasks(pb: newPB, cat: C.black, cont: C.yellow | C.death, col: C.zero)
        blackNode.physicsBody = newPB
        blackNode.name     = "black"
        blackNode.position = pos
      }
      
      gsi.addChild(blackNode)
    }
    
    func scanline(pos: CGPoint) {
      
      let lineNode = SKSpriteNode(color: .clear, size: CGSize(width: gsi.frame.width, height: 1)); do {
        let newPB = SKPhysicsBody(rectangleOf: lineNode.size)
        setMasks(pb: newPB, cat: C.line, cont: C.yellow | C.death, col: C.zero)
        
        lineNode.physicsBody = newPB
        lineNode.position = pos
      }
      
      gsi.addChild(lineNode)
    }
    
    func deathLine() {
      
      let lineNode = SKSpriteNode(color: .orange, size: CGSize(width: gsi.frame.width + 1000, height: 2)); do {
        let newPB = SKPhysicsBody(rectangleOf: lineNode.size); do {
          setMasks(pb: newPB, cat: C.death, cont: C.black, col: C.zero)
          newPB.affectedByGravity = false
        }
        
        lineNode.physicsBody = newPB
        // lineNode.position.y = frame.minY - size30.height
      }
      gsi.addChild(lineNode)
    }
    
    func touchPad() {
      let touchPad = TouchPad(player: gsi.player!, scene: gsi)
      touchPad.position.y -= touchPad.size.height / 2
      gsi.addChild(touchPad)
    }
    
    func lineOfBlackBoxes() {
      
      let yVal = gsi.frame.maxY + (gsi.size30.height/2)
      let numBoxes = gsi.difficulty.boxNum + randy(6)
      
      for _ in 1...numBoxes {
        let randomX = randy(Int(gsi.frame.maxX * 2))
        let xVal = CGFloat(randomX) - gsi.frame.maxX
        blackNode(pos: CGPoint(x: xVal, y: yVal))
      }
      
      scanline(pos: CGPoint(x: 0, y: yVal))
    }
  };
};

// MARK: - updateAction():
extension GameScene {
  func updateAction() {
    
    removeAction(forKey: "spawner")
    let wait     = SKAction.wait(forDuration: difficulty.boxSpeed)
    let run      = SKAction.run { Spawner(gsi: self).lineOfBlackBoxes() }
    let sequence = SKAction.sequence([wait, run])
    self.action  = SKAction.repeatForever(sequence)
    
    self.run(action!, withKey: "spawner")
  }
};

// MARK: - DMV:
extension GameScene {
  
  private func selfInit() {
    //view!.frame = CGRect(x: 0, y: 0, width: 350, height: 350)
    scaleMode = .aspectFit
    anchorPoint = CGPoint(x: 0.5, y: 0.5)
    physicsWorld.contactDelegate = self
    physicsWorld.gravity = CGVector(dx: 0, dy: -0.25)
    
    let starterLabel = SKLabelNode(text: "DODGE FALLING BOXES!! Win at 50!!")
    let starterNode = SKSpriteNode(); do {
      starterNode.size = starterLabel.frame.size
      starterNode.physicsBody = SKPhysicsBody(rectangleOf: starterNode.size)
      starterNode.addChild(starterLabel)
      starterNode.position.y -= 50
    }
    
    addChild(starterNode)
  }
  
  override func didMove(to view: SKView) {
    
    UD.initUserDefaults()
    UD.loadHighScore()
    
    print("Welcome to Sprite Attack! Your HS is \(highscore)")
    
    selfInit()
    let spawn = Spawner(gsi: self); do {
      spawn.yellowNode()
      spawn.lineOfBlackBoxes()
      spawn.deathLine()
      spawn.touchPad()
    }
    
    updateAction()
    //gs.hits = -500
    score = 0
    // OMFG what have I become??
  }
}

// MARK: - Game Loop:
extension GameScene {
  private struct gs {
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
      difficulty.boxNum += 1
      difficulty.boxSpeed -= 0.1
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
