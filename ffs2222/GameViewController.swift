//  Created by justin fluidity on 4/26/17.

import SpriteKit

/// Globals:

struct g {
  
  static var
  view = SKView(),
  gsi   = GameScene(),
  score = 0, // Too lazy to make an init for other scenes...
  
  highscore: Int = 0,
  mainmenu: MainMenuScene? = nil,
  
  devdifficulty = 0,
  devmode    = RefBool(false),
  spinning   = RefBool(false),
  fademode   = RefBool(false),
  fullmode   = RefBool(false)
}

class GameViewController: UIViewController {
  
  private let mySize = CGSize(width: 600, height: 500)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // UD.setHighScore(to: 0)
    
    guard let view = self.view as! SKView? else { fatalError("wtf happened") }; do {
      view.ignoresSiblingOrder = true
      view.showsFPS = true
      view.showsNodeCount = true
      view.frame = CGRect(x: 0, y: 0, width: mySize.width, height: mySize.height)
      // g.view = view
    }
    
    let scene = MainMenuScene(size: CGSize(width: 600, height: 1000))
    scene.scaleMode = .aspectFit
    view.presentScene(scene)
  }
  
  override var shouldAutorotate: Bool { return true }
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    if UIDevice.current.userInterfaceIdiom == .phone { return .allButUpsideDown }
    else { return .all }
  }
  override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
  override var prefersStatusBarHidden: Bool { return true }
}

