//
//  OtherScenes.swift
//  ffs2222

import SpriteKit

final class WinScene: SKScene {
  override func didMove(to view: SKView) {
    scaleMode = .aspectFit
    anchorPoint = CGPoint(x: 0.5, y: 0.5)
    addChild(SKLabelNode(text: "YOU WON! PLAY AGAIN"))
    score = 0
  }
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view!.presentScene(GameScene(size: size))
  }
};

final class FailScene: SKScene {
  override func didMove(to view: SKView) {
    scaleMode = .aspectFit
    anchorPoint = CGPoint(x: 0.5, y: 0.5)
    addChild(SKLabelNode(text: "score: \(score)! | highscore: \(highscore) |   PLAY AGAIN"))
    
    score = 0
  }
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view!.presentScene(GameScene(size: size))
  }
};
