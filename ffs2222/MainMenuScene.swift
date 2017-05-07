//
// LaunchScene.swift

import SpriteKit

fileprivate final class PlayLabel: SKLabelNode {
  
  init(texter: String) {
    super.init(fontNamed: "Chalkduster")
    self.text = "Play Game!"
    isUserInteractionEnabled = true
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let scene = GameScene(size: self.scene!.size)
    g.gsi = scene
    self.scene!.view!.presentScene(scene)
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError("") }; override init() { super.init() }
};

fileprivate final class OptionLabel: SKLabelNode {
  
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

// MARK: - Scene:
final class MainMenuScene: SKScene {
  
  
  let mm_scoreLabel = SKLabelNode(text: "session: \(g.sessionScore) | high: \(g.highscore)")
  
  func updateScore() {
    mm_scoreLabel.text = "session: \(g.sessionScore) | high: \(g.highscore)"
  }
  
  private func selfInit() {
    setBackGroundColor(forScene: self)
    anchorPoint = CGPoint(x: 0.5, y: 0.5)
  }
  
  private func makeLabels() {
    
    let labels: [SKLabelNode] = [
      PlayLabel(texter: ""),
      mm_scoreLabel,
      Toggler(labelName: "SpinMode", refBool: g.spinning ),
      Toggler(labelName: "FadeMode", refBool: g.fademode ),
      Toggler(labelName: "FullMode", refBool: g.fullmode ),
      Toggler(labelName: "NHMode"  , refBool: g.nhmode   )
      // <# Toggler(labelName: "Scoring" , refBool: g.scoremode)
    ]
    
    labels[0].position.y += 250
    offSetLabel(labels, by: 50)
    changeFont(labels)
    addChildren(labels)
  }
  
  // ***COMPATIBILITY FOR iOS 9*** \\
  private var firstrun = true
  
  // MARK: - DMV:
  override func didMove(to view: SKView) {
    guard firstrun else { return }
    
    g.state = "menu"
    g.mainmenu = self
    g.sessionScore = 0
    
    UD.initUserDefaults()
    // UD.setHighScore(to: 0)
    UD.loadHighScore()
  
    selfInit()
    makeLabels()
    
    // ***COMPATIBILITY FOR iOS 9*** \\
    firstrun = false
  }
};
