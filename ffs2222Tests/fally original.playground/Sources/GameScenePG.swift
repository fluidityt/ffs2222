import SpriteKit

/// TODO: Recycle or kill old nodes.
/// TODO: Game mode... TWO yellow boxes??

public func randy(_ num: Int) -> Int { return Int(arc4random_uniform(UInt32(num)))+1 }

enum Category {
  static let
  zero =    UInt32 (0),
  yellow =  UInt32 (1),
  black =   UInt32 (2),
  three =   UInt32 (4),
  line  =   UInt32 (8)
}

var score = 0 // Too lazy to make an init for other scenes...

// MARK: - GameScene init and stuff:
public class GameScene: SKScene, SKPhysicsContactDelegate {
  
  var
  difficultyBoxNum = 4,
  difficultyBoxSpeed = Double(1),
  difficultyBoxSize = CGFloat(1.5),
  action: SKAction?
  
  let size30 = CGSize(width: 30, height: 30)
  
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
    print("Welcome to Sprite Attack! Can you beat 50?")
    selfInit()
    spawnYellowNode()
    createLineOfBlackBoxes()
    updateAction()
    // OMFG what have I become??
  }
}


// MARK: - Physics and stuff:

extension GameScene {
  struct gs {
    static var waiting = false
    static var hits = 0
  }
  
  private func doBlackAndYellow(contact: SKPhysicsContact) {
    
    func assignYellowBlack() ->  (SKPhysicsBody, SKPhysicsBody) {
      if contact.bodyA.categoryBitMask == Category.yellow {
        return (contact.bodyA, contact.bodyB)
      } else {
        return (contact.bodyB, contact.bodyA)
      }
    }
    
    gs.hits += 1
    
    let (yellowNode, blackNode) = assignYellowBlack()
    
    if gs.hits >= 2 {
      gs.hits = 0
      view?.presentScene(FailScene(size: size))
    }
    
    yellowNode.node?.setScale(difficultyBoxSize)
    blackNode.node?.removeFromParent()
  }
  
  public func didBegin(_ contact: SKPhysicsContact) {
  
    let contactedCategories = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
    
    switch contactedCategories {
      
    case Category.black  | Category.yellow: doBlackAndYellow(contact: contact)
      
      
    case Category.yellow | Category.line:
      do {
        score += 1
        print(score)
        
        if contact.bodyA.categoryBitMask == Category.line {
          contact.bodyA.node!.physicsBody = nil
        } else { contact.bodyB.node!.physicsBody = nil }
        
      }
    default: ()
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
    case 10: if !gs.waiting { upDifficulty() }
    case 20: if  gs.waiting { upDifficulty() }
    case 30: if !gs.waiting { upDifficulty() }
    case 40: if  gs.waiting { upDifficulty() }
    case 50: view!.presentScene(WinScene(size: size))
    default: ()
    }
  }
}
