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
fileprivate struct Spawner {
  
    typealias C = GameScene.Category
    
    private var localgsi: GameScene
    
    init(gsi: GameScene) { self.localgsi = g.gsi }
    
    func yellowNode() {
      let yellowNode = Stuff(color: .blue, size: localgsi.size30); do {
        let newPB = SKPhysicsBody(rectangleOf: localgsi.size30); do {
          setMasks(pb: newPB, cat: C.yellow, cont: C.black, col: C.zero)
          newPB.affectedByGravity  = false
        }
        yellowNode.physicsBody = newPB
        yellowNode.position.x += 35
        yellowNode.position.y = localgsi.frame.minY + 35
      }
      
      localgsi.addChild(yellowNode)
      localgsi.player = yellowNode
    }
    
    func blackNode(pos: CGPoint)  {
      
      let blackNode = SKSpriteNode(color: .white, size: localgsi.size30); do {
        let newPB = SKPhysicsBody(rectangleOf: localgsi.size30)
        setMasks(pb: newPB, cat: C.black, cont: C.yellow | C.death, col: C.zero)
        blackNode.physicsBody = newPB
        blackNode.name     = "black"
        blackNode.position = pos
        
        if g.fademode.value {
          let
          fin      = SKAction.fadeAlpha(to: 0.10, duration: 0.00),
          fout1    = SKAction.fadeAlpha(to: 0.25, duration: 1.00),
          fout2    = SKAction.fadeAlpha(to: 1.00, duration: 0.25),
          sequence = SKAction.sequence([fin, fout1, fout2]),
          forever  = SKAction.repeatForever(sequence)
          
          blackNode.run(forever)
        }
        
        if g.spinning.value {
          let action: SKAction = {
            if randy(2) == 1 { return SKAction.rotate(byAngle:  90, duration: 1) }
            else             { return SKAction.rotate(byAngle: -90, duration: 1) }
          }()
          let forever = SKAction.repeatForever(action)
          blackNode.run(forever)
        }
      }
      
      localgsi.addChild(blackNode)
    }
    
    func scanline(pos: CGPoint) {
      
      let lineNode = SKSpriteNode(color: .clear, size: CGSize(width: localgsi.frame.width, height: 1)); do {
        let newPB = SKPhysicsBody(rectangleOf: lineNode.size)
        setMasks(pb: newPB, cat: C.line, cont: C.yellow | C.death, col: C.zero)
        
        lineNode.physicsBody = newPB
        lineNode.position = pos
      }
      
      localgsi.addChild(lineNode)
    }
    
    func deathLine() {
      
      let lineNode = SKSpriteNode(color: .orange, size: CGSize(width: localgsi.frame.width + 1000, height: 2)); do {
        let newPB = SKPhysicsBody(rectangleOf: lineNode.size); do {
          setMasks(pb: newPB, cat: C.death, cont: C.black, col: C.zero)
          newPB.affectedByGravity = false
        }
        
        lineNode.physicsBody = newPB
        if g.fullmode.value { lineNode.position.y = (localgsi.frame.minY - localgsi.size30.height) }
        else              { lineNode.position.y -= localgsi.size30.height }
        
      }
      localgsi.addChild(lineNode)
    }
    
    func touchPad() {
      let touchPad = TouchPad(player: localgsi.player!, scene: localgsi)
      if g.fullmode.value { }
      else { touchPad.position.y -= touchPad.size.height / 2 }
      localgsi.addChild(touchPad)
    }
    
    func lineOfBlackBoxes() {
      
      func randomX() -> CGFloat {
        let randomX = randy(Int(localgsi.frame.maxX * 2))
        let xVal = CGFloat(randomX) - localgsi.frame.maxX
        return xVal
      }
      
      let yVal = localgsi.frame.maxY + (localgsi.size30.height/2)
      let numBoxes = localgsi.difficulty.boxNum + randy(6)
      
      let fairness = CGFloat(15) // 5 points on either side?
      let fairRect = CGRect(middle: CGPoint(x: randomX(), y: yVal),
                            width:  localgsi.size30.width + fairness,
                            height: localgsi.size30.height)
    
      // Oh my god this is awful:
      for _ in 1...numBoxes {
        
        func getRandomPoint() -> CGPoint { return CGPoint(x: randomX(), y: yVal) }
      
        var randomPoint = getRandomPoint()
    
        func randomizePoint() { randomPoint = getRandomPoint() }
        
        func getRandomRect()  -> CGRect {
          return CGRect(middle: randomPoint,
                        width: localgsi.size30.width,
                        height: localgsi.size30.height)
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
    
    if g.devdifficulty > 0 {
      for _ in 1...g.devdifficulty {
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
    
    print("Welcome to Sprite Attack! Your HS is \(g.highscore)")
    
    selfInit()
    
    spawnStuff()
    
    updateAction()
    
    if g.devmode.value { devMode() }
    if g.fullmode.value { difficulty.boxSpeed -= 0.15 }
    g.score = 0
  }
};

