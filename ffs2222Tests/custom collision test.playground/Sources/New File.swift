import SpriteKit

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
