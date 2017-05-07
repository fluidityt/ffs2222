import SpriteKit

/// Extra state for loop:
fileprivate var
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
    
    static func blackAndYellow(contact: SKPhysicsContact) {
      
      func assignYellowBlack() ->  (SKPhysicsBody, SKPhysicsBody) {
        if contact.bodyA.categoryBitMask == Category.yellow {
          return (contact.bodyA, contact.bodyB)
        }
        else {
          return (contact.bodyB, contact.bodyA)
        }
      }
      
      hitThisFrame = true
      
      let (yellowNode, blackNode) = assignYellowBlack()
      
      guard let yn = yellowNode.node, let bn = blackNode.node else { fatalError() }
      
      if !g.devmode.value { yn.setScale(g.gsi.difficulty.boxSize) }
      bn.removeFromParent()
    } // ... you know what it is
    
    static func yellowAndLine (contact: SKPhysicsContact) {
      
      defer { if !g.devmode.value { UD.saveHighScore() } }
      
      if isInvincible { return }
      
      g.score += 1
      // <#  g.gsi.scoreLabel?.text = "Score \(g.score)"
      if g.score > g.sessionScore { g.sessionScore = g.score }
      
      print(g.score)
      
      if contact.bodyA.categoryBitMask == Category.line {
        if let a = contact.bodyA.node { killNode(a) }
      }
      else {
        if let b = contact.bodyB.node { killNode(b) }
      }
    }
    
    static func deathAndBlack (contact: SKPhysicsContact) {
      if contact.bodyA.categoryBitMask == Category.black {
        if let a = contact.bodyA.node { killNode(a) }
      }
      else {
        if let b = contact.bodyB.node { killNode(b) }
      }
    }
    
    static func deathAndLine  (contact: SKPhysicsContact) {
      if contact.bodyA.categoryBitMask == Category.line {
        if let a = contact.bodyA.node { killNode(a) }
      }
      else {
        if let b = contact.bodyB.node { killNode(b) }
      }
    }
  };
  
  func didBegin(_ contact: SKPhysicsContact) {
    let contactedCategories = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
    
    switch contactedCategories {
    case Category.black  | Category.yellow : DoContact.blackAndYellow(contact: contact)
    case Category.yellow | Category.line   : DoContact.yellowAndLine (contact: contact)
    case Category.black  | Category.death  : DoContact.deathAndBlack (contact: contact)
    case Category.line   | Category.death  : DoContact.deathAndLine  (contact: contact)
    default: ()
    }
  }
  
  // MARK: - End contact:
  override func didSimulatePhysics() {
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
    
    if waiting { waiting = false }
    else { waiting = true }
  }
  
  override func didFinishUpdate() {
    
    switch g.score {
    // case <#num#>: if  <#excl#>waiting { upDifficulty() }
    case 10: if !waiting { upDifficulty() }
    case 20: if  waiting { upDifficulty() }
    case 30: if !waiting { upDifficulty() }
    default: ()
    }
  }
  
};
