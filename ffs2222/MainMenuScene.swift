//
// LaunchScene.swift

import SpriteKit

 

// MARK: - Scene:
final class MainMenuScene: SKScene {
  
  private static let scoreText = "Session: \(g.sessionScore) | High: \(g.highscore)"
  let mm_scoreLabel = SKLabelNode(text: MainMenuScene.scoreText)
  
  func updateScore() { mm_scoreLabel.text = MainMenuScene.scoreText }
  
  private func selfInit() {
    setBackGroundColor(forScene: self)
    anchorPoint = CGPoint(x: 0.5, y: 0.5)
  }
  
  private func makeLabels() {
    
    let labels: [SKLabelNode] = [
      PlayLabel(texter: ""),
      mm_scoreLabel,
      Toggler(labelName: "DevMode",  refBool: g.devmode  ),
      Toggler(labelName: "SpinMode", refBool: g.spinning ),
      Toggler(labelName: "FadeMode", refBool: g.fademode ),
      Toggler(labelName: "FullMode", refBool: g.fullmode )
      //Toggler(labelName: "NHMode"  , refBool: g.nhmode   )
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
    // UD.setHighScore(to: 158)
    UD.loadHighScore()
  
    selfInit()
    makeLabels()
    
    // ***COMPATIBILITY FOR iOS 9*** \\
    firstrun = false
  }
};
