import SpriteKit

/// Globals:
struct g {
  
  static var
  view = SKView(),
  gsi   = GameScene(),
  score = 0, // Too lazy to make an init for other scenes...
  
  highscore: Int = 0,
  mainmenu: MainMenuScene? = nil,
  
  devdifficulty = 0,
  devmode    = RefBool(false),
  spinning   = RefBool(false),
  fademode   = RefBool(false),
  fullmode   = RefBool(false),
  
  state      = "launch"
}

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
  player: Stuff?,
  scoreLabel: SKLabelNode?
  
  lazy var size30: CGSize = CGSize(width: 30, height: 30)
  lazy var notificationHeight: CGFloat = self.size.height/7
  
};

// MARK: - Spawner
/// Ideally abstract:
fileprivate final class Spawner {
  
    typealias C = GameScene.Category
  
    private let localGS: GameScene
    private lazy var nh: CGFloat = self.localGS.notificationHeight
  
    init(gsi: GameScene) { localGS = g.gsi }
  
    func yellowNode() {
      let yellowNode = Stuff(color: .blue, size: localGS.size30); do {
        let newPB = SKPhysicsBody(rectangleOf: localGS.size30); do {
          setMasks(pb: newPB, cat: C.yellow, cont: C.black, col: C.zero)
          newPB.affectedByGravity  = false
        }
        yellowNode.physicsBody = newPB
        yellowNode.position.x += 35
        yellowNode.position.y = localGS.frame.minY + 35
      }
      
      localGS.addChild(yellowNode)
      localGS.player = yellowNode
    }
    
    func blackNode(pos: CGPoint)  {
      
      let blackNode = SKSpriteNode(color: .white, size: localGS.size30); do {
        let newPB = SKPhysicsBody(rectangleOf: localGS.size30)
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
      
      localGS.addChild(blackNode)
    }
    
    func scanline(pos: CGPoint) {
      
      let lineNode = SKSpriteNode(color: .clear, size: CGSize(width: localGS.frame.width, height: 1)); do {
        let newPB = SKPhysicsBody(rectangleOf: lineNode.size)
        setMasks(pb: newPB, cat: C.line, cont: C.yellow | C.death, col: C.zero)
        
        lineNode.physicsBody = newPB
        lineNode.position = pos
      }
      
      localGS.addChild(lineNode)
    }
    
    func deathLine() {
      
      let lineNode = SKSpriteNode(color: .orange, size: CGSize(width: localGS.frame.width + 1000, height: 2)); do {
        let newPB = SKPhysicsBody(rectangleOf: lineNode.size); do {
          setMasks(pb: newPB, cat: C.death, cont: C.black, col: C.zero)
          newPB.affectedByGravity = false
        }
        
        lineNode.physicsBody = newPB
        if g.fullmode.value { lineNode.position.y =  (localGS.frame.minY  - localGS.size30.height) }
        else                { lineNode.position.y -= (localGS.size30.height + nh) }
        
      }
      localGS.addChild(lineNode)
    }
    
    func touchPad() {
      let touchPad = TouchPad(player: localGS.player!, scene: localGS)
      if g.fullmode.value { }
      else {
        touchPad.position.y -= (touchPad.size.height / 2) + nh
      }
      localGS.addChild(touchPad)
    }
    
    func lineOfBlackBoxes() {
      
      func randomX() -> CGFloat {
        let randomX = randy(Int(localGS.frame.maxX * 2))
        let xVal = CGFloat(randomX) - localGS.frame.maxX
        return xVal
      }
      
      let yVal = (localGS.frame.maxY + localGS.size30.height/2) - nh
      let numBoxes = localGS.difficulty.boxNum + randy(6)
      
      let fairness = CGFloat(15) // 5 points on either side?
      let fairRect = CGRect(middle: CGPoint(x: randomX(), y: yVal),
                            width:  localGS.size30.width + fairness,
                            height: localGS.size30.height)
    
      // Oh my god this is awful:
      for _ in 1...numBoxes {
        
        func getRandomPoint() -> CGPoint { return CGPoint(x: randomX(), y: yVal) }
      
        var randomPoint = getRandomPoint()
    
        func randomizePoint() { randomPoint = getRandomPoint() }
        
        func getRandomRect()  -> CGRect {
          return CGRect(middle: randomPoint,
                        width: localGS.size30.width,
                        height: localGS.size30.height)
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
  
    func scoreLabel() {
      let background = SKSpriteNode(color: .white, size: CGSize(width: localGS.size.width, height: nh)); do {
        
        let scoreLabel = SKLabelNode(text: "Score: \(g.score)")
        scoreLabel.fontName = "Chalkduster"
        scoreLabel.fontColor = .black
        localGS.scoreLabel = scoreLabel
        
        background.zPosition += 1
        background.position.y = (localGS.frame.maxY - background.size.height/2)
        background.addChild(scoreLabel)
      }
      localGS.addChild(background)
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
    spawn.scoreLabel()
  }
  
  override func didMove(to view: SKView) {
    // OMFG what have I become??
    g.state = "game"
    
    print("Welcome to Sprite Attack! Your HS is \(g.highscore)")
    
    selfInit()
    
    spawnStuff()
    
    updateAction()
    
    if g.devmode.value { devMode() }
    if g.fullmode.value { difficulty.boxSpeed -= 0.15 }
    g.score = 0
  }
};

