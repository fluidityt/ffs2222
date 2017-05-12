//
//  labels.swift

import SpriteKit

// MARK: - PlayLabel:
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
    g.gameScene = scene
    self.scene!.view!.presentScene(scene)
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError("") };  override init() { super.init() }
};

// MARK: - MainMenuLabel:
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

// MARK: - OptionLabel:
final class OptionLabel: SKLabelNode {
  
  init(texter: String) {
    super.init(fontNamed: "Chalkduster")
    self.text = "Options"
    isUserInteractionEnabled = true
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError("") };  override init() { super.init() }
};

// MARK: - Toggler:
class Toggler: SKLabelNode {
  
  private var refBool: RefBool
  var value: Bool { return refBool.value }
  
  var labelName: String
  /*
   var offText = ""
   var onText = ""
   */
  
  func toggleOn() {
    refBool.value = true
    text = labelName + ": on"
  }
  
  func toggleOff() {
    refBool.value = false
    text = labelName + ": off"
  }
  
  /*init(offText: String, onText: String, refBool: RefBool) {
   ref = refBool
   super.init(fontNamed: "Chalkduster")
   if refBool.value { toggleOn() } else { toggleOff() }
   isUserInteractionEnabled = true
   }
   */
  
  init(labelName: String, refBool: RefBool) {
    self.refBool = refBool
    self.labelName = labelName
    super.init(fontNamed: "Chalkduster")
    isUserInteractionEnabled = true
    
    self.refBool = refBool
    self.labelName = labelName
    if refBool.value { toggleOn() } else { toggleOff() }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if refBool.value { toggleOff() } else { toggleOn() }
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError("") }
  override init() {
    self.refBool = RefBool(false)
    self.labelName = "ERROR"
    super.init()
  }
};
