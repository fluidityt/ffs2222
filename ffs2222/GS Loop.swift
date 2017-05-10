import SpriteKit

/// Extra state for loop:
var
waiting      = false,     // Used for g.score increase at end of loop.
hits         = 0,         // Player HP.
hitThisFrame = false,     // Used to keep player alive when hit 2 black at same time.
paused       = false

// MARK: - Game Loop:
extension GameScene {

  // MARK: - TB:
  func pause() {
    // FIXME: FULLMODE BUG HOTFIX:
    if g.fullmode.value { return }
    
    paused.toggle()
    
    if paused {
      view!.isPaused = true
      view!.frame = CGRect(middle: CGPoint(x: view!.frame.midX, y: view!.frame.midY),
                           width: size.width/3, height: size.height/3)
    } else {
      view!.isPaused = false
      view!.frame = CGRect(middle: CGPoint(x: view!.frame.midX, y: view!.frame.midY),
                           width:  UIWindow().frame.width, height: UIWindow().frame.height)
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    pause()
  }
  
  // MARK: - Update:
  private func keepPlayerInBounds() {
    guard let playa = player else { fatalError("issue with player") }
    
    let nh = notificationHeight
    let bounds = (fullBottom: frame.minY + playa.size.height/2,
                  bottom:     frame.midY + playa.size.height/2,
                  top:        frame.maxY - playa.size.height/2,
                  left:       frame.minX + playa.size.width/2,
                  right:      frame.maxX - playa.size.width/2)
    
    if g.fullmode.value {
      if playa.position.y < bounds.fullBottom { playa.position.y = bounds.fullBottom }
    }
    else {
      if playa.position.y < bounds.bottom-nh  { playa.position.y = bounds.bottom-nh  }
    }
    
    if playa.position.y > bounds.top-nh { playa.position.y = bounds.top-nh }
    if playa.position.x < bounds.left   { playa.position.x = bounds.left   }
    if playa.position.x > bounds.right  { playa.position.x = bounds.right  }
  }
  
  override func update(_ currentTime: TimeInterval) {
    hitThisFrame = false
    
    keepPlayerInBounds()
  }
  
  // MARK: - Contact:
  private struct DoContact {
    
    static var contact = SKPhysicsContact()
    
    /// ... you know what it is ...
    static func blackAndYellow() {
      
      func assignYellowBlack() ->  (SKPhysicsBody, SKPhysicsBody) {
        if contact.bodyA.categoryBitMask == Category.yellow {
          return (contact.bodyA, contact.bodyB)
        }
        else {
          return (contact.bodyB, contact.bodyA)
        }
      }
      
      let (yellowPB, blackPB) = assignYellowBlack()
      
      guard let yellowNode = yellowPB.node, let blackNode = blackPB.node else { fatalError() }
      
      if !g.devmode.value { yellowNode.setScale(g.gameScene.difficulty.boxSize) }
      
      func removeANode(blackNode: SKNode) {
        
        // Find nodes at left and right:
        let oneLeft    = blackNode.frame.minX - 0.9
        let oneRight   = blackNode.frame.maxX + 0.9
        let pointLeft  = CGPoint(x: oneLeft, y: blackNode.position.y)
        let pointRight = CGPoint(x: oneRight, y: blackNode.position.y)
        
        blackNode.removeFromParent()
        
        let leftNodes  = g.gameScene.nodes(at: pointLeft)
        let rightNodes = g.gameScene.nodes(at: pointRight)
        
        for ln in leftNodes  {
          if ln.name != nil { removeANode(blackNode: ln) }
        }
        for rn in rightNodes {
          if rn.name != nil { removeANode(blackNode: rn) }
        }
      }
      
      removeANode(blackNode: blackNode)
      
      // Send signal to take dps at end of physics:
      hitThisFrame = true
    }
    
    static func yellowAndLine() {
      
      defer { if !g.devmode.value { UD.saveHighScore() } }
      
      g.linesCleared += 1
      
      // Increase score:
      if g.gameScene.isInvincible == false {
        g.score += 1
        // <#  g.gsi.scoreLabel?.text = "Score \(g.score)"
        if g.score > g.sessionScore { g.sessionScore = g.score }
        print("score:", g.score)
      }
      
      // Kill nodes:
      if contact.bodyA.categoryBitMask == Category.line {
        if let a = contact.bodyA.node { killNode(a) }
      }
      else {
        if let b = contact.bodyB.node { killNode(b) }
      }
    }
    
    static func deathAndBlack() {
      if contact.bodyA.categoryBitMask == Category.black {
        if let a = contact.bodyA.node { killNode(a) }
      }
      else {
        if let b = contact.bodyB.node { killNode(b) }
      }
    }
    
    static func deathAndLine() {
      if contact.bodyA.categoryBitMask == Category.line {
        if let a = contact.bodyA.node { killNode(a) }
      }
      else {
        if let b = contact.bodyB.node { killNode(b) }
      }
    }
  };
  
  func didBegin(_ contact: SKPhysicsContact) {
    DoContact.contact = contact
  
    let contactedCategories = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
    
    switch contactedCategories {
      case Category.black  | Category.yellow : DoContact.blackAndYellow()
      case Category.yellow | Category.line   : DoContact.yellowAndLine ()
      case Category.black  | Category.death  : DoContact.deathAndBlack ()
      case Category.line   | Category.death  : DoContact.deathAndLine  ()
      default: ()
    }
  }
  
  // MARK: - End contact:
  override func didSimulatePhysics() {
    if isInvincible { return }
    
    if hitThisFrame { hits += 1 }
    if hits >= 2    {
      hits = 0
      view!.presentScene(FailScene(size: size))
    }
  }
  
  // MARK: - Post:
  func upDifficulty() {
    print("difficulty up!")
    difficulty.boxNum += 1
    difficulty.boxSpeed -= 0.1
    updateAction()
    
    waiting.toggle()
    player?.toggleColor()
  }
  
  func upBoxes() {
    print("boxes up!")
    difficulty.boxNum += 1
    updateAction()
    
    waiting.toggle()
    player?.toggleColor()
  }
  
  override func didFinishUpdate() {
  
    switch g.linesCleared {
    // case <#num#>: if  <#excl#>waiting { upDifficulty() }
    case   0: waiting = false
    case  10: if !waiting { upDifficulty() }
    case  20: if  waiting { upDifficulty() }
    case  30: if !waiting { upDifficulty() }
    case  40: if  waiting { upBoxes()      }
    case  50: if !waiting { upBoxes()      }
    default: ()
    }
  }
  
};
