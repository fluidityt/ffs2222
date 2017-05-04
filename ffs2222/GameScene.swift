import SpriteKit

// MARK: - Main:
class GameScene: SKScene, SKPhysicsContactDelegate {
  
  /// Bitmasks:
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
/// Ideally abstract:
fileprivate  struct Spawner {
    
    typealias C = GameScene.Category
    
    var _gsi: GameScene
    
    init(gsi: GameScene) { self._gsi = gsi }
    
    func yellowNode() {
      let yellowNode = Stuff(color: .blue, size: _gsi.size30); do {
        let newPB = SKPhysicsBody(rectangleOf: _gsi.size30); do {
          setMasks(pb: newPB, cat: C.yellow, cont: C.black, col: C.zero)
          newPB.affectedByGravity  = false
        }
        yellowNode.physicsBody = newPB
        yellowNode.position.x += 35
        yellowNode.position.y = _gsi.frame.minY + 35
      }
      
      _gsi.addChild(yellowNode)
      _gsi.player = yellowNode
    }
    
    func blackNode(pos: CGPoint)  {
      
      let blackNode = SKSpriteNode(color: .white, size: _gsi.size30); do {
        let newPB = SKPhysicsBody(rectangleOf: _gsi.size30)
        setMasks(pb: newPB, cat: C.black, cont: C.yellow | C.death, col: C.zero)
        blackNode.physicsBody = newPB
        blackNode.name     = "black"
        blackNode.position = pos
      }
      
      _gsi.addChild(blackNode)
    }
    
    func scanline(pos: CGPoint) {
      
      let lineNode = SKSpriteNode(color: .clear, size: CGSize(width: _gsi.frame.width, height: 1)); do {
        let newPB = SKPhysicsBody(rectangleOf: lineNode.size)
        setMasks(pb: newPB, cat: C.line, cont: C.yellow | C.death, col: C.zero)
        
        lineNode.physicsBody = newPB
        lineNode.position = pos
      }
      
      _gsi.addChild(lineNode)
    }
    
    func deathLine() {
      
      let lineNode = SKSpriteNode(color: .orange, size: CGSize(width: _gsi.frame.width + 1000, height: 2)); do {
        let newPB = SKPhysicsBody(rectangleOf: lineNode.size); do {
          setMasks(pb: newPB, cat: C.death, cont: C.black, col: C.zero)
          newPB.affectedByGravity = false
        }
        
        lineNode.physicsBody = newPB
        lineNode.position.y -= 30
      }
      _gsi.addChild(lineNode)
    }
    
    func touchPad() {
      let touchPad = TouchPad(player: _gsi.player!, scene: _gsi)
      touchPad.position.y -= touchPad.size.height / 2
      _gsi.addChild(touchPad)
    }
    
    func lineOfBlackBoxes() {
      
      func randomX() -> CGFloat {
        let randomX = randy(Int(_gsi.frame.maxX * 2))
        let xVal = CGFloat(randomX) - _gsi.frame.maxX
        return xVal
      }
      
      let yVal = _gsi.frame.maxY + (_gsi.size30.height/2)
      let numBoxes = _gsi.difficulty.boxNum + randy(6)
      
      let fairness = CGFloat(15) // 5 points on either side?
      let fairRect = CGRect(middle: CGPoint(x: randomX(), y: yVal),
                            width:  _gsi.size30.width + fairness,
                            height: _gsi.size30.height)
    
      // Oh my god this is awful:
      for _ in 1...numBoxes {
        
        func getRandomPoint() -> CGPoint { return CGPoint(x: randomX(), y: yVal) }
      
        var randomPoint = getRandomPoint()
    
        func randomizePoint() { randomPoint = getRandomPoint() }
        
        func getRandomRect()  -> CGRect {
          return CGRect(middle: randomPoint,
                        width: _gsi.size30.width,
                        height: _gsi.size30.height)
        }
        
        var randomRect = getRandomRect()
        
        while randomRect.intersects(fairRect) {
          randomizePoint()
          randomRect = getRandomRect()
        }
        
        blackNode(pos: randomPoint)
      }
      
      scanline(pos: CGPoint(x: 0, y: yVal))
    }
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
  }
  
  private func devMode() {
    gs.hits = -5000
    
    if devdifficulty > 0 {
      for _ in 1...devdifficulty {
        upDifficulty()
      }
    }
  }
  
  private func spawnStuff() {
    let spawn = Spawner(gsi: self)
    spawn.yellowNode()
    spawn.lineOfBlackBoxes()
    spawn.deathLine()
    spawn.touchPad()
  }
  
  override func didMove(to view: SKView) {
    // OMFG what have I become??
    
    UD.initUserDefaults()
    UD.loadHighScore()
    
    print("Welcome to Sprite Attack! Your HS is \(highscore)")
    
    selfInit()
    
    spawnStuff()
    
    updateAction()
    
    if devmode { devMode() }

    score = 0
  }
};

// MARK: - Game Loop:
extension GameScene {
  
  /// A bit of extra state just for game loop:
  struct gs {
    static var
    waiting      = false,     // Used for score increase at end of loop.
    hits         = 0,         // Player HP.
    hitThisFrame = false      // Used to keep player alive when hit 2 black at same time.
  }
  
  private func keepPlayerInBounds() {
    guard let playa = player else { fatalError("issue with player") }
    
    let bounds = (bottom: frame.midY + playa.size.height/2,
                  top:    frame.maxY - playa.size.height/2,
                  left:   frame.minX + playa.size.width/2,
                  right:  frame.maxX + playa.size.width/2)
    
    if playa.position.y < bounds.bottom { playa.position.y = bounds.bottom }
    if playa.position.y > bounds.top    { playa.position.y = bounds.top   }
    if playa.position.x < bounds.left   { playa.position.x = bounds.left   }
    if playa.position.x > bounds.right  { playa.position.x = bounds.right  }
  }
  
  override func update(_ currentTime: TimeInterval) {
    gs.hitThisFrame = false
    
    keepPlayerInBounds()
  }
  
  /// Static methods for didBegin():
  private struct DoContact {
    
    static func blackAndYellow(contact: SKPhysicsContact) {
      
      func assignYellowBlack() ->  (SKPhysicsBody, SKPhysicsBody) {
        if contact.bodyA.categoryBitMask == Category.yellow {
          return (contact.bodyA, contact.bodyB)
        }
        else {
          return (contact.bodyB, contact.bodyA)
        }
      }
      
      gs.hitThisFrame = true
      
      let (yellowNode, blackNode) = assignYellowBlack()
      
      yellowNode.node?.setScale(gsi.difficulty.boxSize)
      blackNode.node?.removeFromParent()
    }
    
    static func yellowAndLine(contact: SKPhysicsContact) {
      score += 1
      print(score)
      
      if contact.bodyA.categoryBitMask == Category.line {
        if let a = contact.bodyA.node { killNode(a) }
      }
      else {
        if let b = contact.bodyB.node { killNode(b) }
      }
    }
    
    static func deathAndBlack(contact: SKPhysicsContact) {
      if contact.bodyA.categoryBitMask == Category.black {
        if let a = contact.bodyA.node { killNode(a) }
      }
      else {
        if let b = contact.bodyB.node { killNode(b) }
      }
    }
    
    static  func deathAndLine(contact: SKPhysicsContact) {
      if contact.bodyA.categoryBitMask == Category.line {
        if let a = contact.bodyA.node { killNode(a) }
      }
      else {
        if let b = contact.bodyB.node { killNode(b) }
      }
    }
  };
  
  func didBegin(_ contact: SKPhysicsContact) {
    
    defer { UD.saveHighScore() }
    
    let contactedCategories = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
    
    switch contactedCategories {
    case Category.black  | Category.yellow : DoContact.blackAndYellow(contact: contact)
    case Category.yellow | Category.line   : DoContact.yellowAndLine (contact: contact)
    case Category.black  | Category.death  : DoContact.deathAndBlack (contact: contact)
    case Category.line   | Category.death  : DoContact.deathAndLine  (contact: contact)
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
  func upDifficulty() {
    print("difficulty up!")
    difficulty.boxNum += 1
    difficulty.boxSpeed -= 0.1
    updateAction()
    
    if gs.waiting { gs.waiting = false }
    else { gs.waiting = true }
  }
  
  override func didFinishUpdate() {
    
    switch score {
    // case <#num#>: if  <#excl#>gs.waiting { upDifficulty() }
    case 10: if !gs.waiting { upDifficulty() }
    case 20: if  gs.waiting { upDifficulty() }
    case 30: if !gs.waiting { upDifficulty() }
    default: ()
    }
  }
};
