import SpriteKit

/// DESIGN: Have boxes laugh at you once you die...
/// TODO: Recycle or kill old nodes.
/// TODO: Game mode... TWO yellow boxes??

// FIXME: Why does the screen squash after you lose and replay??

// ************************************************************* //
func killNode(_ node: SKNode) {
  node.physicsBody = nil
  node.removeAllChildren()
  node.removeAllActions()
  node.removeFromParent()
}

// Globals:
var gview = SKView()
var score = 0 // Too lazy to make an init for other scenes...

func randy(_ num: Int) -> Int { return Int(arc4random_uniform(UInt32(num)))+1 }

func setMasks(pb: SKPhysicsBody, cat: UInt32, cont: UInt32, col: UInt32) {
    pb.categoryBitMask = cat
    pb.contactTestBitMask = cont
    pb.collisionBitMask = col
}
// ************************************************************* //

//
// MARK: - GameScene init and stuff:
//
public class GameScene: SKScene, SKPhysicsContactDelegate {
  
  enum Category {
    static let
    zero =    UInt32 (0),
    yellow =  UInt32 (1),
    black =   UInt32 (2),
    three =   UInt32 (4),
    line  =   UInt32 (8),
    death =   UInt32 (16)
  }

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
    view!.frame = CGRect(x: 0, y: 0, width: 350, height: 350)
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
  
  /// Static funcs to spawn stuff:
  private struct Spawn {
    
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
  }
  
  func updateAction() {
    
    removeAction(forKey: "spawner")
    let wait     = SKAction.wait(forDuration: difficultyBoxSpeed)
    let run      = SKAction.run { self.spawn.lineOfBlackBoxes() }
    let sequence = SKAction.sequence([wait, run])
    self.action  = SKAction.repeatForever(sequence)
    
    self.run(action!, withKey: "spawner")
  }
  
  public override func didMove(to view: SKView) {
    print("Welcome to Sprite Attack! Can you beat 100?")
    
    selfInit()
    spawn.yellowNode()
    spawn.lineOfBlackBoxes()
    spawn.deathLine()
    spawn.touchPad()
    
    updateAction()
    //gs.hits = -500
    score = 1
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
  
  public override func update(_ currentTime: TimeInterval) {
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

  public func didBegin(_ contact: SKPhysicsContact) {

    let contactedCategories = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
    
    switch contactedCategories {
    case Category.black  | Category.yellow : doBlackAndYellow(contact: contact)
    case Category.yellow | Category.line   : doYellowAndLine (contact: contact)
    case Category.black  | Category.death  : doDeathAndBlack (contact: contact)
    case Category.line   | Category.death  : doDeathAndLine  (contact: contact)
    default: ()
    }
  }
  
  public override func didSimulatePhysics() {
    if gs.hitThisFrame { gs.hits += 1 }
    if gs.hits >= 2    {
      gs.hits = 0 // FIXME: Reset for next game since this is not an instance variable... what?
      view!.presentScene(FailScene(size: size))
    }
  }

  /// Difficulty:
  public override func didFinishUpdate() {
    
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
}

class TouchPad: SKSpriteNode {
  
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
}


class Stuff: SKSpriteNode {
  
  init(color: SKColor, size: CGSize) {
    super.init(texture: nil, color: color, size: size)
    isUserInteractionEnabled = true
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError() }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    position = touches.first!.location(in: self.scene!)
    
  }
  
}

public class WinScene: SKScene {
  public override func didMove(to view: SKView) {
    //resetView()
    anchorPoint = CGPoint(x: 0.5, y: 0.5)
    addChild(SKLabelNode(text: "YOU WON! PLAY AGAIN"))
    score = 0
    
  }
  public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view!.presentScene(GameScene(size: size))
  }
  
};

public class FailScene: SKScene {
  public override func didMove(to view: SKView) {

    anchorPoint = CGPoint(x: 0.5, y: 0.5)
    addChild(SKLabelNode(text: "score: \(score)!    PLAY AGAIN"))
    score = 0
  }
  public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view!.presentScene(GameScene(size: size))
  }
};


