//
//  Utilz.swift
//  ffs2222

import SpriteKit

// MARK: - SKExtensions:
public extension SKPhysicsBody {
  public func setMasks(cat: UInt32, cont: UInt32, col: UInt32) {
    self.categoryBitMask    = cat
    self.contactTestBitMask = cont
    self.collisionBitMask   = col
  }
  
  public convenience init(rectangleOf s: CGSize,
                   affectedGravity: Bool?  = nil,
                   category: UInt32?       = nil,
                   contact: UInt32?        = nil,
                   collision: UInt32?      = nil,
                   dynamic: Bool?          = nil,
                   friction: CGFloat?      = nil,
                   mass: CGFloat?          = nil,
                   pinned: Bool?           = nil,
                   restitution: CGFloat?   = nil) {
    
    self.init(rectangleOf: s)
    if let cat = category   { self.categoryBitMask = cat }
    if let con = contact    { self.contactTestBitMask = con }
    if let col = collision  { self.collisionBitMask = col }
    if let dyn = dynamic    { self.isDynamic = dyn }
    if let pin = pinned     { self.pinned = pin }
    if let fri = friction   { self.friction = fri }
    if let mas = mass       { self.mass = mas }
    if let res = restitution { self.restitution = res }
    if let ag  = affectedGravity { self.affectedByGravity = ag }
  }
  
}

public extension SKNode {
  
  public func addChildren(_ nodes: [SKNode]) {
    for node in nodes {
      self.addChild(node)
    }
  }
}

public extension SKSpriteNode {
  
  public convenience init(color: SKColor,
                   size: CGSize,
                   name: String? = nil,
                   position: CGPoint? = nil,
                   physicsBody: SKPhysicsBody? = nil) {
    
    self.init(texture: nil, color: color, size: size)
    if let n   = name        { self.name = n         }
    if let pos = position    { self.position = pos   }
    if let pb  = physicsBody { self.physicsBody = pb }
  }
}

// MARK: - CG Extensions:
public extension CGRect {
  
  public init(middle: CGPoint, width: CGFloat, height: CGFloat) {
    
    let x = middle.x - (width/2 )
    let y = middle.y - (height/2)
    
    self.origin = CGPoint(x: x, y: y)
    self.size   = CGSize(width: width, height: height)
  }
  
  var point:
    (topLeft:   CGPoint, topMiddle:    CGPoint, topRight:    CGPoint,
    middleLeft: CGPoint, middle:       CGPoint, middleRight: CGPoint,
    bottomLeft: CGPoint, bottomMiddle: CGPoint, bottomRight: CGPoint)  {
    return (
      CGPoint(x : self.minX, y : self.maxY), // top
      CGPoint(x : self.midX, y : self.maxY),
      CGPoint(x : self.maxX, y : self.maxY),
      CGPoint(x : self.minX, y : self.midY), // middle
      CGPoint(x : self.midX, y : self.midY),
      CGPoint(x : self.maxX, y : self.midY),
      CGPoint(x : self.minX, y : self.minY), // bottom
      CGPoint(x : self.midX, y : self.minY),
      CGPoint(x : self.maxX, y : self.minY)
    )
  }
}

extension CGSize {
  var halfHeight: CGFloat { return self.height/2 }
  var halfWidth:  CGFloat { return self.width/2  }
}

public extension CGPoint {
  static let topLeft     = CGPoint(x : 0, y : 1)
  static let topMiddle   = CGPoint(x: 0.5, y: 1)
  static let topRight    = CGPoint(x : 1, y : 1)
  static let middle      = CGPoint(x : 0.5, y : 0.5)
  static let middleLeft  = CGPoint(x : 0,   y : 0.5)
  static let middleRight = CGPoint(x : 1,   y : 0.5)
  static let bottomLeft  = CGPoint(x : 0, y : 0)
  static let bottomMid   = CGPoint(x: 0.5, y: 0)
  static let bottomRight = CGPoint(x : 1, y : 0)
}

// MARK: - Base swift extensions:
extension Bool {
  var isOn    : Bool { if  self { return true } else { return false } }
  var isOff   : Bool { if !self { return true } else { return false } }
  var isFalse : Bool { if !self { return true } else { return false } }
  var isTrue  : Bool { if  self { return true } else { return false } }
  
  
  mutating func toggle() {
    if self == true {
      self        = false
    } else { self = true }
  }
}

extension CGFloat {
  var d: Double       { return Double(self)       }
  var t: TimeInterval { return TimeInterval(self) }
  var i: Int          { return Int(self)          }
}

extension Double {
  var f: CGFloat      { return CGFloat(self)      }
  var t: TimeInterval { return TimeInterval(self) }
  var i: Int          { return Int(self)          }
}

extension Int {
  var f: CGFloat      { return CGFloat(self)      }
  var d: Double       { return Double(self)       }
  var t: TimeInterval { return TimeInterval(self) }
  var i: Int          { return Int(self)          }
}

func randy(_ num: Int)     -> Int     { return Int(    arc4random_uniform(UInt32(num)))+1 }
func randy(_ num: CGFloat) -> CGFloat { return CGFloat(arc4random_uniform(UInt32(num)))+1 }
func randy(_ num: Double)  -> Double  { return Double( arc4random_uniform(UInt32(num)))+1 }


  




