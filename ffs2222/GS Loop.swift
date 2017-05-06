import SpriteKit

// MARK: - Game Loop:
extension GameScene {
  
  /// A bit of extra state just for game loop:
  struct gs {
    static var
    waiting      = false,     // Used for g.score increase at end of loop.
    hits         = 0,         // Player HP.
    hitThisFrame = false,     // Used to keep player alive when hit 2 black at same time.
    paused       = false
  }
  
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
      
      if !g.devmode.value { yellowNode.node?.setScale(g.gsi.difficulty.boxSize) }
      blackNode.node?.removeFromParent()
    } // ... you know what it is
    
    static func yellowAndLine (contact: SKPhysicsContact) {
      g.score += 1
      g.gsi.scoreLabel?.text = "Score \(g.score)"
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
    
    defer { if !g.devmode.value { UD.saveHighScore() } }
    
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
    
    switch g.score {
    // case <#num#>: if  <#excl#>gs.waiting { upDifficulty() }
    case 10: if !gs.waiting { upDifficulty() }
    case 20: if  gs.waiting { upDifficulty() }
    case 30: if !gs.waiting { upDifficulty() }
    default: ()
    }
  }
  
  
  func pause() {
    gs.paused.toggle()
    
    if gs.paused {
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
};
