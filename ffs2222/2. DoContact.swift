//
//  DoContact.swift
//  ffs2222

import SpriteKit

struct DoContact {
  
  var contact: SKPhysicsContact
  
  init(contact: SKPhysicsContact) { self.contact = contact }
  
  /// ... you know what it is ...
  func blackAndYellow() {
    
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
    
    if !g.mode.dev.value { yellowNode.setScale(g.difficulty.boxSize) }
    
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
    g.hitThisFrame = true
  }
  
   func yellowAndLine() {
    
    defer { if !g.mode.dev.value { UD.saveHighScore() } }
    
    g.linesCleared += 1
    
    // Increase score:
    if g.isInvincible == false {
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
  
   func deathAndBlack() {
    if contact.bodyA.categoryBitMask == Category.black {
      if let a = contact.bodyA.node { killNode(a) }
    }
    else {
      if let b = contact.bodyB.node { killNode(b) }
    }
  }
  
   func deathAndLine() {
    if contact.bodyA.categoryBitMask == Category.line {
      if let a = contact.bodyA.node { killNode(a) }
    }
    else {
      if let b = contact.bodyB.node { killNode(b) }
    }
  }
};
