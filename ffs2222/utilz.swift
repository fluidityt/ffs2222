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
func randy(_ num: CGFloat) -> CGFloat { return CGFloat(arc4random_uniform(UInt32(num)))+1 }
func randy(_ num: Double) -> Double { return Double(arc4random_uniform(UInt32(num)))+1 }

func setMasks(pb: SKPhysicsBody, cat: UInt32, cont: UInt32, col: UInt32) {
  pb.categoryBitMask = cat
  pb.contactTestBitMask = cont
  pb.collisionBitMask = col
}

func changeFont(_ labels: [SKLabelNode]) {
  for label in labels {
    label.fontName = "Chalkduster"
    label.fontColor = .black
  }
}

/// Top label is [0]
func offSetLabel(_ labels: [SKLabelNode], by amount: CGFloat = 50) {
  var counter = CGFloat(0); for label in labels {
    if label == labels[0] { continue } else { counter += 1 }
    label.position.y = labels[0].position.y - (labels[0].frame.height + amount) * counter
  }
}

/// For use with anchorpoints and pbs
func pbCenter(on node: SKSpriteNode) -> CGPoint {
  return  CGPoint(x: CGFloat(node.size.width * (node.anchorPoint.x - 0.5) - node.size.width),
                  y: CGFloat(node.size.height * (0.5 - node.anchorPoint.y)))
}

extension CGRect {
  
  init(middle: CGPoint, width: CGFloat, height: CGFloat) {
    
    let x = middle.x - (width/2)
    let y = middle.y - (height/2)
    
    self.origin = CGPoint(x: x, y: y)
    self.size   = CGSize(width: width, height: height)
  }
}

func setBackGroundColor(forScene: SKScene) {
  forScene.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
}

extension SKNode {
  
  func addChildren(_ nodes: [SKNode]) {
    for node in nodes {
      self.addChild(node)
    }
  }
}

extension SKSpriteNode {
  func center() -> CGPoint {
    return CGPoint(x: CGFloat(size.width  * (anchorPoint.x - 0.5)),
                   y: CGFloat(size.height * (0.5 - anchorPoint.y)))
  }
}

extension CGRect {
  func center() -> CGPoint {
    return CGPoint(x: self.midX, y: self.midY)
  }
}


struct SKPoint {
  static let topLeft     = CGPoint(x: 0, y: 1)
  static let topRight    = CGPoint(x: 1, y: 1)
  static let bottomLeft  = CGPoint(x: 0, y: 0)
  static let bottomRight = CGPoint(x: 1, y: 0)
  static let middle      = CGPoint(x: 0.5, y: 0.5)
  static let middleLeft  = CGPoint(x: 0,   y: 0.5)
  static let middleRight = CGPoint(x: 1,   y: 0.5)
}

extension Bool {
  mutating func toggle() {
    if self == true {
      self = false
    } else { self = true }
  }
}

