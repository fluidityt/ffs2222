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
  
  private final class DevModeLabel: SKLabelNode {
    
    func devModeOff() {
      devmode.value = false
      self.text = "DevMode Off"
    }
    
    func devModeOn() {
      devmode.value = true
      self.text = "DevMode On"
    }
    
    init(texter: String) {
      super.init(fontNamed: "Chalkduster")
      self.text = "DevMode Off"
      isUserInteractionEnabled = true
      position.y -= 100
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      if devmode.value { devModeOff() } else { devModeOn() }
    }
    
    override init() { super.init() }
    required init?(coder aDecoder: NSCoder) { fatalError("") }
    
  };
  
  private final class SpinModeLabel: SKLabelNode {
    
    func spinModeOff() {
      spinning .value = false
      self.text = "SpinMode Off"
    }
    
    func spinModeOn() {
      spinning.value = true
      self.text = "SpinMode On"
    }
    
    init(texter: String) {
      super.init(fontNamed: "Chalkduster")
      self.text = "SpinMode Off"
      isUserInteractionEnabled = true
      position.y -= 200
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      if spinning.value { spinModeOff() } else { spinModeOn() }
    }
    
    override init() { super.init() }
    required init?(coder aDecoder: NSCoder) { fatalError("") }
  };
  
  private final class FadeModeLabel: SKLabelNode {
    
    func fadeModeOff() {
      fademode.value = false
      self.text = "FadeMode Off"
    }
    
    func fadeModeOn() {
      fademode.value = true
      self.text = "FadeMode On"
    }
    
    init(texter: String) {
      super.init(fontNamed: "Chalkduster")
      self.text = "FadeMode Off"
      isUserInteractionEnabled = true
      position.y -= 300
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      if fademode.value { fadeModeOff() } else { fadeModeOn() }
    }
    
    override init() { super.init() }
    required init?(coder aDecoder: NSCoder) { fatalError("") }
    
  };
  
  private final class FullModeLabel: SKLabelNode {
    
    func fullModeOff() {
      fullmode.value = false
      self.text = "FullMode Off"
    }
    
    func fullModeOn() {
      fullmode.value = true
      self.text = "FullMode On"
    }
    
    init(texter: String) {
      super.init(fontNamed: "Chalkduster")
      self.text = "FullMode Off"
      isUserInteractionEnabled = true
      position.y -= 400
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      if fullmode.value { fullModeOff() } else { fullModeOn() }
    }
    
    override init() { super.init() }
    required init?(coder aDecoder: NSCoder) { fatalError("") }
    
  }
  
  /// let isplaying = RefBool(false)
  
  private func makeLabels() {
    addChild(PlayLabel    (texter: ""))
    addChild(DevModeLabel (texter: ""))
    addChild(SpinModeLabel(texter: ""))
    addChild(FadeModeLabel(texter: ""))
    addChild(FullModeLabel(texter: ""))
    
    /// addChild(Toggler(labelName: "Play Game", refBool: isplaying))
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
