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
