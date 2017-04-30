//
//  GameViewController.swift
//  ffs2222
//
//  Created by justin fluidity on 4/26/17.
//  Copyright © 2017 justin fluidity. All rights reserved.
//

import SpriteKit

// FIXME: memory leak? 600+ nodes...

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
          
          view.frame = CGRect(x: 0, y: 0, width: 600, height: 500)
          // Load the SKScene from 'GameScene.sks'
          let scene = GameScene(size: CGSize(width: 600, height: 600))

          // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFit
          
          // Present the scene
            view.presentScene(scene)
          
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
