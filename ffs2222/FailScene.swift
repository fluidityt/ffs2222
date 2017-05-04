//
//  OtherScenes.swift
//  ffs2222

import SpriteKit

final class FailScene: SKScene {

  private func makeLabels() {
    let scoreLabel = SKLabelNode(text: "SCORE: \(score)!")
    let hsLabel    = SKLabelNode(text: "HIGHSCORE: \(highscore)")
    let playLabel  = SKLabelNode(text: ">>> PLAY AGAIN :D <<<")
    hsLabel.position.y   -= (scoreLabel.frame.height + 25)
    playLabel.position.y -= (scoreLabel.frame.height + 25) * 2
  
    let labels = [scoreLabel, hsLabel, playLabel]
    changeFont(labels: labels)
    addChildren(labels)
  }
  
  override func didMove(to view: SKView) {
    scaleMode = .aspectFit
    anchorPoint = CGPoint(x: 0.5, y: 0.5)
    
    makeLabels()
    
    score = 0
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view!.presentScene(GameScene(size: size))
  }
};
