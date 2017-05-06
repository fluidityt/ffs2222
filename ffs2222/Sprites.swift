//
//  Sprites.swift
//  ffs2222

import SpriteKit


final class TouchPad: SKSpriteNode {
  
  private var playerInstance: Stuff
  
  init(player: Stuff, scene: SKScene) {
    playerInstance = player
    
    let color: SKColor
    let size: CGSize
    if g.fullmode.value {
      color = .clear
      size = g.gsi.size
      assert(g.gsi.size.height > 10)
    } else {
      color = .white
      size = CGSize(width: scene.size.width, height: (scene.size.height/2))
    }
    
    super.init(texture: nil, color: color, size: size)
    zPosition += 1
    isUserInteractionEnabled = true
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError() }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

    for t in touches {
      
      let dx = (t.location(in: self).x - t.previousLocation(in: self).x)
      let dy = (t.location(in: self).y - t.previousLocation(in: self).y)
      
      playerInstance.position.x += dx
      playerInstance.position.y += dy
    }
  }
};

final class Stuff: SKSpriteNode {
  
  init(color: SKColor, size: CGSize) {
    super.init(texture: nil, color: color, size: size)
   // isUserInteractionEnabled = true
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError() }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    // position = touches.first!.location(in: self.scene!)
    
  }
};
