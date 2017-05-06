//
//  OtherScenes.swift
//  ffs2222

import SpriteKit

final class FailScene: SKScene {

  private final class PlayLabel: SKLabelNode {
    
    init(texter: String) {
      super.init(fontNamed: "Chalkduster")
      self.text = ">>> PLAY AGAIN :D <<<"
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
  
  private final class MainMenuLabel: SKLabelNode {
    
    init(texter: String) {
      super.init(fontNamed: "Chalkduster")
      self.text = ">>> MainMenu <<<"
      isUserInteractionEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      self.scene!.view!.presentScene(g.mainmenu!)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("") }; override init() { super.init() }
  };
  
  private func makeLabels() {
    
    let
    scoreLabel = SKLabelNode(text: "SCORE: \(g.score)!"),
    hsLabel    = SKLabelNode(text: "HIGHSCORE: \(g.highscore)"),
    playLabel  = PlayLabel(texter: ""),
    mmLabel    = MainMenuLabel(texter: "")
  
    scoreLabel.position.y += 100
    
    let labels = [scoreLabel, hsLabel, playLabel, mmLabel]
    offSetLabel(labels)
    changeFont (labels)
    addChildren(labels)
  }
  
  override func didMove(to view: SKView) {
    scaleMode = .aspectFit
    anchorPoint = CGPoint(x: 0.5, y: 0.5)
    makeLabels()
    
    g.score = 0
  }
};
