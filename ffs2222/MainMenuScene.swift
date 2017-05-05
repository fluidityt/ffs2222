//
// LaunchScene.swift

import SpriteKit

final class MainMenuScene: SKScene {
  
  private final class PlayLabel: SKLabelNode {
    
    init(texter: String) {
      super.init(fontNamed: "Chalkduster")
      self.text = "PlayGame!"
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
      devmode = false
      self.text = "DevMode Off"
    }
    
    func devModeOn() {
      devmode = true
      self.text = "DevMode On"
    }
    
    init(texter: String) {
      super.init(fontNamed: "Chalkduster")
      self.text = "DevMode Off"
      isUserInteractionEnabled = true
      position.y -= 100
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      if devmode { devModeOff() } else { devModeOn() }
    }
    
    override init() { super.init() }
    required init?(coder aDecoder: NSCoder) { fatalError("") }
    
  };
  
  private final class SpinModeLabel: SKLabelNode {
    
    func spinModeOff() {
      spinning = false
      self.text = "SpinMode Off"
    }
    
    func spinModeOn() {
      spinning = true
      self.text = "SpinMode On"
    }
    
    init(texter: String) {
      super.init(fontNamed: "Chalkduster")
      self.text = "SpinMode Off"
      isUserInteractionEnabled = true
      position.y -= 200
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      if spinning { spinModeOff() } else { spinModeOn() }
    }
    
    override init() { super.init() }
    required init?(coder aDecoder: NSCoder) { fatalError("") }
  };
  
  private final class FadeModeLabel: SKLabelNode {
    
    func fadeModeOff() {
      fademode = false
      self.text = "FadeMode Off"
    }
    
    func fadeModeOn() {
      fademode = true
      self.text = "FadeMode On"
    }
    
    init(texter: String) {
      super.init(fontNamed: "Chalkduster")
      self.text = "FadeMode Off"
      isUserInteractionEnabled = true
      position.y -= 300
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      if fademode { fadeModeOff() } else { fadeModeOn() }
    }
    
    override init() { super.init() }
    required init?(coder aDecoder: NSCoder) { fatalError("") }
    
  };
  
  private func makeLabels() {
    addChild(PlayLabel    (texter: ""))
    addChild(DevModeLabel (texter: ""))
    addChild(SpinModeLabel(texter: ""))
    addChild(FadeModeLabel(texter: ""))
  }
  
  override func sceneDidLoad() {
    mainmenu = self
    anchorPoint = CGPoint(x: 0.5, y: 0.5)
    
    makeLabels()
  }
};
