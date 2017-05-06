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

func changeFont(_ labels: [SKLabelNode]) {
  for label in labels { label.fontName = "Chalkduster" }
}

/// Top label is [0]
func offSetLabel(_ labels: [SKLabelNode], by amount: CGFloat = 50) {
  var counter = CGFloat(0); for label in labels {
    if label == labels[0] { continue } else { counter += 1 }
    label.position.y = labels[0].position.y - (labels[0].frame.height + amount) * counter
  }
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

class RefBool {
  var value: Bool
  init(_ value: Bool) {
    self.value = value
  }
}

struct SKPoint {
  static let topLeft     = CGPoint(x: 0, y: 1)
  static let topRight    = CGPoint(x: 1, y: 1)
  static let bottomLeft  = CGPoint(x: 0, y: 0)
  static let bottomRight = CGPoint(x: 1, y: 0)
  static let middle      = CGPoint(x: 0.5, y: 0.5)
}
