//
//  labels.swift

import SpriteKit

final class PlayLabel: SKLabelNode {
  
  init(texter: String) {
    super.init(fontNamed: "Chalkduster")

    self.text = {
      if      g.state == State.fail { return ">>> PLAY AGAIN :D <<<" }
      else if g.state == State.main { return "Play Game!"            }
      else                          { return "error"                 }
    }()
    
    isUserInteractionEnabled = true
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let scene = GameScene(size: self.scene!.size)
    g.gsi = scene
    self.scene!.view!.presentScene(scene)
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError("") }
  override init() { super.init() }
};

final class MainMenuLabel: SKLabelNode {
  
  init(texter: String) {
    super.init(fontNamed: "Chalkduster")
    self.text = ">>> MainMenu <<<"
    isUserInteractionEnabled = true
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let mm = g.mainmenu else { fatalError() }
    mm.updateScore()
    self.scene!.view!.presentScene(g.mainmenu!)
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError("") }; override init() { super.init() }
};

final class OptionLabel: SKLabelNode {
  
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
