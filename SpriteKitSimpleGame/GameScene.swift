//
//  GameScene.swift
//  SpriteKitSimpleGame
//
//  Created by Karlo Pagtakhan on 05/03/2016.
//  Copyright (c) 2016 AccessIT. All rights reserved.
//

import SpriteKit

func + (left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
  return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
  return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
  func sqrt(a: CGFloat) -> CGFloat {
    return CGFloat(sqrtf(Float(a)))
  }
#endif

extension CGPoint {
  func length() -> CGFloat {
    return sqrt(x*x + y*y)
  }
  
  func normalized() -> CGPoint {
    return self / length()
  }
}

struct PhysicsCategory{
  static let None: UInt32 = 0
  static let All: UInt32 = UInt32.max
  static let Monster: UInt32 = 0b1
  static let Star: UInt32 = 0b10
  
}

class GameScene: SKScene, SKPhysicsContactDelegate {
  
  let player = SKSpriteNode(imageNamed: "player")
  
  override func didMoveToView(view: SKView) {
    backgroundColor = SKColor.whiteColor()
    player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
    addChild(player)
    
    runAction(SKAction.repeatActionForever(
      SKAction.sequence([
        SKAction.runBlock(addMonster),
        SKAction.waitForDuration(1.0)
        ])
      ))
    
    
    physicsWorld.gravity = CGVectorMake(0, 0)
    physicsWorld.contactDelegate = self
    
  }
  func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
  }
  
  func random(min min: CGFloat, max: CGFloat) -> CGFloat {
    return random() * (max - min) + min
  }
  
  func addMonster() {
    
    let monster = SKSpriteNode(imageNamed: "monster")
    
    //Random Y position
    let actualY = random(min: monster.size.height/2, max: size.height - monster.size.height/2)
    
    //Set position of monster
    monster.position = CGPoint(x: size.width + monster.size.width/2, y: actualY)
    
    //Monster physics
    monster.physicsBody = SKPhysicsBody(rectangleOfSize: monster.size)
    monster.physicsBody?.dynamic = true
    monster.physicsBody?.categoryBitMask = PhysicsCategory.Monster
    monster.physicsBody?.contactTestBitMask = PhysicsCategory.Star
    monster.physicsBody?.collisionBitMask = PhysicsCategory.None
    
    // Add the monster to the scene
    addChild(monster)
    
    //Speed of monster
    let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
    
    //Monster actions
    let actionMove = SKAction.moveTo(CGPoint(x: -monster.size.width/2, y: actualY), duration: NSTimeInterval(actualDuration))
    let actionMoveDone = SKAction.removeFromParent()
    monster.runAction(SKAction.sequence([actionMove, actionMoveDone]))
    
  }
  
  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    guard let touch = touches.first else {return}
    
    // Location of touch in node
    let touchLocation = touch.locationInNode(self)
    
    //Create stars
    let stars = SKSpriteNode(imageNamed: "projectile")
    stars.position = player.position
    
    //Get the difference between touch and player position
    let offset = touchLocation - player.position
    
    //Forward throw only
    if offset.x < 0 {return}
    
    stars.physicsBody = SKPhysicsBody(circleOfRadius: stars.size.width/2)
    stars.physicsBody?.dynamic = true
    stars.physicsBody?.categoryBitMask = PhysicsCategory.Star
    stars.physicsBody?.collisionBitMask = PhysicsCategory.Monster
    stars.physicsBody?.contactTestBitMask = PhysicsCategory.None
    stars.physicsBody?.usesPreciseCollisionDetection = true
    
    //Add star to scene
    addChild(stars)
    
    //Determin the star's final position
    let finalPosition = player.position + (offset.normalized() * 1000)
    
    //Star actions
    let actionMove = SKAction.moveTo(finalPosition, duration: 2.0)
    let actionEnd = SKAction.removeFromParent()
    stars.runAction(SKAction.sequence([actionMove, actionEnd]))
    
    
  }
  
  func starCollideWithMonster(star:SKSpriteNode, monster:SKSpriteNode){
    print("Hit")
    star.removeFromParent()
    monster.removeFromParent()
  }
  
  func didEndContact(contact: SKPhysicsContact) {
    var monsterBody:SKPhysicsBody
    var starBody:SKPhysicsBody
    
//    if contact.bodyA.categoryBitMask ==
    monsterBody = contact.bodyA.categoryBitMask == PhysicsCategory.Monster ? contact.bodyA:contact.bodyB
    starBody = contact.bodyA.categoryBitMask == PhysicsCategory.Star ? contact.bodyA:contact.bodyB
    
    starCollideWithMonster(starBody.node as! SKSpriteNode, monster: monsterBody.node as! SKSpriteNode)
    
  }

}


























