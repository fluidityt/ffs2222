//
//  Utilz.swift
//  ffs2222

import SpriteKit

func killNode(_ node: SKNode) {
  node.physicsBody = nil
  node.removeAllChildren()
  node.removeAllActions()
  node.removeFromParent()
}

func randy(_ num: Int) -> Int { return Int(arc4random_uniform(UInt32(num)))+1 }

func setMasks(pb: SKPhysicsBody, cat: UInt32, cont: UInt32, col: UInt32) {
  pb.categoryBitMask = cat
  pb.contactTestBitMask = cont
  pb.collisionBitMask = col
}

func changeFont(labels: [SKLabelNode]) {
  for label in labels {
    label.fontName = "Chalkduster"
  }
}


func beFair() -> CGRect {
    return CGRect.zero
}

extension CGRect {
  
  init(middle: CGPoint, width: CGFloat, height: CGFloat) {
    
    let x = middle.x - (width/2)
    let y = middle.y - (height/2)
    
    self.origin = CGPoint(x: x, y: y)
    self.size   = CGSize(width: width, height: height)
  }
}

extension SKNode {
  func addChildren(_ nodes: [SKNode]) {
    for node in nodes {
      self.addChild(node)
    }
  }
}

