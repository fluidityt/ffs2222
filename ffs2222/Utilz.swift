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

class BackLabel: SKLabelNode {
  
  init(texter: String) {
    super.init(fontNamed: "Chalkduster")
    self.text = "Back to Main Menu"
    isUserInteractionEnabled = true
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let main = mainmenu else { fatalError() }
    self.scene!.view!.presentScene(main)
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError("") }
  override init() { super.init() }
};

class OptionScene: SKScene {
  

}
