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
  
  private func spawnLabels() {
    
    options: do {
      let label = SKLabelNode(text: "Options")
      label.fontColor = .white
      label.position.y -= 200
      label.zPosition += 1
      label.setScale(3)
      addChild(label)
    }
    
    sprites: do {
      let label = SKLabelNode(text: "Sprite Attack!")
      label.fontColor = .yellow
      label.position.y += 200
      label.zPosition += 1
      label.setScale(3.5)
      addChild(label)
    }
  }
  
  override func didMove(to view: SKView) {
    mainmenu = self
    anchorPoint = CGPoint(x: 0.5, y: 0.5)
    addChild(PlayLabel   (texter: ""))
    addChild(DevModeLabel(texter: ""))
  }
};
