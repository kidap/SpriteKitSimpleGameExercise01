//
//  GameOverScene.swift
//  SpriteKitSimpleGame
//
//  Created by Karlo Pagtakhan on 05/03/2016.
//  Copyright © 2016 AccessIT. All rights reserved.
//

import Foundation
import SpriteKit


class GameOverScene:SKScene{

  init(size:CGSize, won:Bool){
    super.init(size:size)
    
    backgroundColor = SKColor.whiteColor()
    
    let message = won ? "You win":"You lose"
    
    let label = SKLabelNode(fontNamed: "Chalkduster")
  
    label.text = message
    label.fontSize = 40
    label.fontColor = UIColor.blueColor()
    label.position = CGPoint(x: size.width/2, y: size.height/2)
    addChild(label)
    
    runAction(SKAction.sequence([SKAction.waitForDuration(30), SKAction.runBlock{
      let reveal = SKTransition.flipVerticalWithDuration(0.5)
      let scene = GameScene(size: size)
      self.view?.presentScene(scene, transition: reveal)
    }
    ]))
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
