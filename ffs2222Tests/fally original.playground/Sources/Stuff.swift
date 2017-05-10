import SpriteKit



class Stuff: SKSpriteNode {
  
  init(color: SKColor, size: CGSize) {
    super.init(texture: nil, color: color, size: size)
    isUserInteractionEnabled = true
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError() }
  
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    position = touches.first!.location(in: self.scene!)
    
  }
  
}

public class WinScene: SKScene {
  public override func didMove(to view: SKView) {
    anchorPoint = CGPoint(x: 0.5, y: 0.5)
    addChild(SKLabelNode(text: "YOU WON! PLAY AGAIN"))
    score = 0
  }
  public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view!.presentScene(GameScene(size: size))
  }
  
};

public class FailScene: SKScene {
  public override func didMove(to view: SKView) {
    anchorPoint = CGPoint(x: 0.5, y: 0.5)
    addChild(SKLabelNode(text: "score: \(score)!    PLAY AGAIN"))
    score = 0
  }
  public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view!.presentScene(GameScene(size: size))
  }
};


