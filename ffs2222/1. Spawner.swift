//
//  Spawner.swift
//  ffs2222

import SpriteKit

// MARK: - Spawner
struct Spawner {
  
  typealias C = Category
  
  private let localGS: GameScene
  private lazy var nh: CGFloat = g.notificationHeight
  
  init(gsi: GameScene) {
    localGS = g.gameScene
    
    if g.mode.nh.value == false { g.notificationHeight = 0 }
  }
  
  func yellowNode() {
    let yellowNode = Player(color: .yellow, size: g.size30); do {
      let newPB = SKPhysicsBody(rectangleOf: g.size30); do {
        setMasks(pb: newPB, cat: C.yellow, cont: C.black, col: C.zero)
        newPB.affectedByGravity  = false
      }
      yellowNode.physicsBody = newPB
      yellowNode.position.x += 35
      yellowNode.position.y = localGS.frame.minY + 35
    }
    
    localGS.addChild(yellowNode)
    g.player = yellowNode
  }
  
  func blackNode(pos: CGPoint)  {
    
    let blackNode = SKSpriteNode(color: .black, size: g.size30); do {
      let newPB = SKPhysicsBody(rectangleOf: g.size30)
      setMasks(pb: newPB, cat: C.black, cont: C.yellow | C.death, col: C.zero)
      blackNode.physicsBody = newPB
      blackNode.name     = "black"
      blackNode.position = pos
      
      // MODES:
      if g.mode.fade.value {
        let
        fin      = SKAction.fadeAlpha(to: 0.10, duration: 0.00),
        fout1    = SKAction.fadeAlpha(to: 0.25, duration: 1.00),
        fout2    = SKAction.fadeAlpha(to: 1.00, duration: 0.25),
        sequence = SKAction.sequence([fin, fout1, fout2]),
        forever  = SKAction.repeatForever(sequence)
        
        blackNode.run(forever)
      }
      
      if g.mode.spin.value {
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
  
  mutating func lineOfBlackBoxes(difficulty: (base: Int, mod: Int)) {
    // Data:
    let yVal = (localGS.frame.maxY + g.size30.height/2) - nh
    let numBoxes = difficulty.base + difficulty.mod
    var listOfXes: [CGFloat] = []
    
    // Helper:
    func randomX() -> CGFloat {
      
      func subRandomX() -> CGFloat {
        let randX = randy(Int(localGS.frame.maxX * 2))
        return CGFloat(randX) - localGS.frame.maxX
      }
      
      // Can I please do recursion lol:
      var restart = true
      var xReturn = subRandomX()
      
      if listOfXes.isEmpty { restart = false }
      
      while restart {
        xReturn = subRandomX()
        restart = false
        
        for x in listOfXes {
          if xReturn == x { restart = true }
        }
      }
      
      return xReturn
    }
    
    // Helper 2:
    func getFairPoint(fairness: CGFloat) -> CGPoint {
      
      let fairRect = CGRect(middle: CGPoint(x: randomX(), y: yVal),
                            width:  g.size30.width + fairness,
                            height: g.size30.height)
      
      func getRandomPoint() -> CGPoint { return CGPoint(x: randomX(), y: yVal) }
      
      var randomPoint = getRandomPoint()
      
      func getRandomRect()  -> CGRect {
        return CGRect(middle: randomPoint,
                      width: g.size30.width,
                      height: g.size30.height)
      }
      
      // Logic:
      var randomRect = getRandomRect()
      
      while randomRect.intersects(fairRect) {
        randomPoint = getRandomPoint()
        randomRect = getRandomRect()
      }
      
      return randomPoint
    }
    
    // Assignment:
    for _ in 1...numBoxes {
      blackNode(pos: getFairPoint(fairness: CGFloat(g.fairness)))
    }
    
    scanline(pos: CGPoint(x: 0, y: yVal))
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
  
  mutating func deathLine() {
    
    let lineNode = SKSpriteNode(color: .orange, size: CGSize(width: localGS.frame.width + 1000, height: 2)); do {
      let newPB = SKPhysicsBody(rectangleOf: lineNode.size); do {
        setMasks(pb: newPB, cat: C.death, cont: C.black, col: C.zero)
        newPB.affectedByGravity = false
      }
      
      lineNode.physicsBody = newPB
      if g.mode.full.value { lineNode.position.y =  (localGS.frame.minY  - g.size30.height) }
      else                 { lineNode.position.y -= (g.size30.height + nh) }
      
    }
    localGS.addChild(lineNode)
  }
  
  mutating func touchPad() {
    let touchPad = TouchPad(player: g.player!, scene: localGS)
    if g.mode.full.value { }
    else {
      touchPad.position.y -= (touchPad.size.height / 2) + nh
    }
    localGS.addChild(touchPad)
  }
  
  mutating func scoreLabel() {
    
    let background = SKSpriteNode(color: .black, size: CGSize(width: localGS.size.width, height: nh)); do {
      let newScoreLabel = SKLabelNode(text: "Score: \(g.score)")
      newScoreLabel.fontName = "Chalkduster"
      newScoreLabel.fontColor = .black
      g.scoreLabel = newScoreLabel
      
      background.zPosition += 1
      background.position.y = (localGS.frame.maxY - background.size.height/2)
      if g.mode.score.value { background.addChild(newScoreLabel) }
    }
    localGS.addChild(background)
  }
};

