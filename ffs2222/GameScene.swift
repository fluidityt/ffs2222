import SpriteKit

/// TODO: Recycle or kill old nodes.
/// TODO: Game mode... TWO yellow boxes??


func formula(size: CGSize, factor: Int = 10000) -> CGSize {
  let d = Int(size.width * size.height)
  let c = d / factor
  return CGSize(width: c, height: c)
}

public func randy(_ num: Int) -> Int { return Int(arc4random_uniform(UInt32(num)))+1 }

enum Category {
  static let
  zero =    UInt32 (0),
  yellow =  UInt32 (1),
  black =   UInt32 (2),
  three =   UInt32 (4),
  line  =   UInt32 (8),
  death =   UInt32 (16)
}

var score = 0 // Too lazy to make an init for other scenes...

//
// MARK: - GameScene init and stuff:
//
public class GameScene: SKScene, SKPhysicsContactDelegate {
  
  var
  difficultyBoxNum = 4,
  difficultyBoxSpeed = Double(1),
  difficultyBoxSize = CGFloat(1.5),
  action: SKAction?
  
  
  lazy var size30: CGSize = formula(size: self.frame.size)
  
  private func selfInit() {
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
  
  private func spawnYellowNode() {
    
    let yellowNode = Stuff(color: .blue, size: size30)
    yellowNode.position.x += 35
    let newPB = SKPhysicsBody(rectangleOf: size30)
    newPB.categoryBitMask =    Category.yellow
    newPB.contactTestBitMask = Category.black
    newPB.collisionBitMask   = Category.zero
    newPB.affectedByGravity  = false
    
    yellowNode.physicsBody = newPB
    addChild(yellowNode)
  }
  
  private func spawnBlackNode(pos: CGPoint)  {
    
    let blackNode = SKSpriteNode(color: .white, size: size30)
    let newPB = SKPhysicsBody(rectangleOf: size30)
    newPB.categoryBitMask = Category.black
    newPB.contactTestBitMask = Category.yellow
    newPB.collisionBitMask   = Category.zero
    
    blackNode.name     = "black"
    blackNode.position = pos
    blackNode.physicsBody = newPB
    addChild(blackNode)
  }
  
  private func spawnScanline(pos: CGPoint) {
    
    let lineNode = SKSpriteNode(color: .clear, size: CGSize(width: frame.width, height: 1))
    let newPB = SKPhysicsBody(rectangleOf: lineNode.size)
    newPB.categoryBitMask = Category.line
    newPB.contactTestBitMask = Category.yellow
    newPB.collisionBitMask  = Category.zero
    
    lineNode.physicsBody = newPB
    lineNode.position = pos
    addChild(lineNode)
  }
  
  private func spawnDeathLine() {
    let lineNode = SKSpriteNode(color: .clear, size: CGSize(width: frame.width, height: 1))
    let newPB = SKPhysicsBody(rectangleOf: lineNode.size)
    newPB.affectedByGravity = false
    newPB.categoryBitMask = Category.death
    newPB.contactTestBitMask = Category.black
    newPB.collisionBitMask  = Category.zero
    
    lineNode.physicsBody = newPB
    lineNode.position.y = frame.minY - size30.height
    addChild(lineNode)
  }
  
  func createLineOfBlackBoxes() {
    
    let yVal = frame.maxY + (size30.height/2)
    let numBoxes = difficultyBoxNum + randy(6)
    
    for _ in 1...numBoxes {
      let randomX = randy(Int(frame.maxX * 2))
      let xVal = CGFloat(randomX) - frame.maxX
      spawnBlackNode(pos: CGPoint(x: xVal, y: yVal))
    }
    
    spawnScanline(pos: CGPoint(x: 0, y: yVal))
  }
  
  func updateAction() {
    removeAction(forKey: "spawner")
    let wait     = SKAction.wait(forDuration: difficultyBoxSpeed)
    let run      = SKAction.run { self.createLineOfBlackBoxes() }
    let sequence = SKAction.sequence([wait, run])
    self.action  = SKAction.repeatForever(sequence)
    
    self.run(action!, withKey: "spawner")
  }
  
  public override func didMove(to view: SKView) {
    print("Welcome to Sprite Attack! Can you beat 100?")
    selfInit()
    spawnYellowNode()
    createLineOfBlackBoxes()
    spawnDeathLine()
    updateAction()

    // OMFG what have I become??
  }
}

//
// MARK: - Physics and stuff:
//
extension GameScene {
  struct gs {
    static var waiting = false
    static var hits = 0
    static var hitThisFrame = false
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
    
    yellowNode.node?.setScale(difficultyBoxSize)
    blackNode.node?.removeFromParent()
  }
  
  private func doYellowAndLine(contact: SKPhysicsContact) {
      score += 1
      print(score)
      
      if contact.bodyA.categoryBitMask == Category.line {
        contact.bodyA.node!.physicsBody = nil
      } else { contact.bodyB.node!.physicsBody = nil }
  }
  
  private func doDeathAndBlack(contact: SKPhysicsContact) {
    if contact.bodyA.categoryBitMask == Category.black {
      contact.bodyA.node!.removeFromParent()
    } else { contact.bodyB.node!.removeFromParent() }
  }
  
  public override func update(_ currentTime: TimeInterval) {
    gs.hitThisFrame = false
  }
  
  public func didBegin(_ contact: SKPhysicsContact) {

    let contactedCategories = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
    
    switch contactedCategories {
    case Category.black  | Category.yellow: doBlackAndYellow(contact: contact)
    case Category.yellow | Category.line:   doYellowAndLine (contact: contact)
    case Category.black  | Category.death:  doDeathAndBlack (contact: contact)
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
    case 40: if  gs.waiting { upDifficulty() }
    case 50: if !gs.waiting { upDifficulty() }
    case 60: if  gs.waiting { upDifficulty() }
    case 70: if !gs.waiting { upDifficulty() }
    case 80: if  gs.waiting { upDifficulty() }
    case 90: if !gs.waiting { upDifficulty() }
    case 100: view!.presentScene(WinScene(size: size))
    default: ()
    }
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


