//
// LaunchScene.swift

import SpriteKit

final class MainMenuScene: SKScene {
  
  private final class PlayLabel: SKLabelNode {
    
    init(texter: String) {
      super.init(fontNamed: "Chalkduster")
      self.text = "Play Game! Best Score: \(highscore)"
      isUserInteractionEnabled = true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      let scene = GameScene(size: self.scene!.size)
      gsi = scene
      self.scene!.view!.presentScene(scene)
    }

    required init?(coder aDecoder: NSCoder) { fatalError("") }
    override init() { super.init() }
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
  

  
  /// let isplaying = RefBool(false)
  
  private func makeLabels() {
    
    let labels: [SKLabelNode] = [
      PlayLabel(texter: ""),
      Toggler(labelName: "DevMode", refBool: devmode),
      Toggler(labelName: "SpinMode", refBool: spinning),
      Toggler(labelName: "FadeMode", refBool: fademode),
      Toggler(labelName: "FullMode", refBool: fullmode)
    ]
    offSetLabel(labels, by: 50)
    addChildren(labels)
    

  }
  
  /**
  override func update(_ currentTime: TimeInterval) {
    if isplaying.value {
    isplaying.value = false
      view!.presentScene(GameScene(size: size))
    }
  }*/
  
  // COMPATIBILITY FOR iOS 9:
  private var firstrun = true
  
  override func didMove(to view: SKView) {
    guard firstrun else { return }

    UD.initUserDefaults()
    UD.loadHighScore()
    
    mainmenu = self
    anchorPoint = CGPoint(x: 0.5, y: 0.5)
    print("hi")
    makeLabels()
    
    // COMPATIBILITY IOS 9
    firstrun = false
  }
};
