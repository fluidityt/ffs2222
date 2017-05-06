//
// LaunchScene.swift

import SpriteKit

final class MainMenuScene: SKScene {
  
  private final class PlayLabel: SKLabelNode {
    
    init(texter: String) {
      super.init(fontNamed: "Chalkduster")
      self.text = "Play Game! Best Score: \(g.highscore)"
      isUserInteractionEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      let scene = GameScene(size: self.scene!.size)
      g.gsi = scene
      self.scene!.view!.presentScene(scene)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("") }; override init() { super.init() }
  };
  
  private final class OptionLabel: SKLabelNode {
    
    init(texter: String) {
      super.init(fontNamed: "Chalkduster")
      self.text = "Options"
      isUserInteractionEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("") }
    override init() { super.init() }
  };

  private func makeLabels() {
    
    let labels: [SKLabelNode] = [
      PlayLabel(texter: ""),
      Toggler(labelName: "DevMode", refBool: g.devmode),
      Toggler(labelName: "SpinMode", refBool: g.spinning),
      Toggler(labelName: "FadeMode", refBool: g.fademode),
      Toggler(labelName: "FullMode", refBool: g.fullmode)
    ]
    offSetLabel(labels, by: 50)
    addChildren(labels)
  }
  
  // COMPATIBILITY FOR iOS 9:
  private var firstrun = true
  
  
  // MARK: - DMV:
  override func didMove(to view: SKView) {
    guard firstrun else { return }
    
    g.state = "menu"
    
    UD.initUserDefaults()
    //UD.setHighScore(to: 0)
    UD.loadHighScore()
    
    
    g.mainmenu = self
    anchorPoint = CGPoint(x: 0.5, y: 0.5)
    print("hi")
    makeLabels()
    
    // COMPATIBILITY IOS 9
    firstrun = false
  }
};
