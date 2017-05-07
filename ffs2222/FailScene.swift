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
  
  private func selfInit() {
    scaleMode = .aspectFit
    anchorPoint = CGPoint(x: 0.5, y: 0.5)
    setBackGroundColor(forScene: self)
  }
  
  private func makeLabels() {
    
    let labels: [SKLabelNode] = [
      SKLabelNode(text: "SCORE: \(g.score)!"),
      SKLabelNode(text: "HIGHSCORE: \(g.highscore)"),
      SKLabelNode(text: "SESSION: \(g.sessionScore)"),
      PlayLabel(texter: ""),
      MainMenuLabel(texter: "")
    ]
  
    labels[0].position.y += 100
    
     //labels = [scoreLabel, hsLabel, sesLabel, playLabel, mmLabel]
    offSetLabel(labels)
    changeFont (labels)
    addChildren(labels)
  }
  
  // MARK: - DMV:
  override func didMove(to view: SKView) {
  selfInit()
    makeLabels()
    
    // Important this is last:
    g.score = 0
  }
};
