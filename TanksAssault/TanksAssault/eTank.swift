//
//  eTank.swift
//  TanksAssault
//
//  Created by Alexander Onate on 10/31/16.
//  Copyright © 2016 Alexander Onate. All rights reserved.
//


import SpriteKit

class eTank: SKSpriteNode{
    
    var bullet = SKSpriteNode()
    var tank = SKSpriteNode()
    //var movingObjects = SKSpriteNode()
    var eTankY = CGFloat()
    var etankTexture = SKTexture()
    
    
    override init(texture: SKTexture!, color: UIColor, size: CGSize) {
    super.init(texture: texture, color: color, size: size)
         etankTexture = SKTexture(imageNamed: "etank.gif")
        self.texture = etankTexture
       print("the tank was created")
        
    }
    
    
    
    init(texture: SKTexture!) {
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        etankTexture = SKTexture(imageNamed: "etank.gif")
        self.texture = SKTexture(imageNamed: "etank.gif")
        
    
        print("the tank was created")
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
  /*  func    makeBullet() {
        
        let bulletTexture = SKTexture(imageNamed: "bullet.gif")
        bullet = SKSpriteNode(texture: bulletTexture)
        bullet.position = CGPoint(x: tank.position.x+40, y: tank.position.y+22)
        
        let moveBullet = SKAction.moveBy(x: 1000, y: 0, duration: 4)
        let removeBullet = SKAction.removeFromParent()
        let moveAndRemoveBullet = SKAction.sequence([moveBullet, removeBullet])
        
        bullet.run(moveAndRemoveBullet)
        print("bang!!!")
        movingObjects.addChild(bullet)
    }
 
 init(texture: SKTexture!) {
 //super.init(texture: texture) You can't do this because you are not calling a designated initializer.
 super.init(texture: texture, color: UIColor.clear, size: texture.size())
 }
 
 
 

 
 */
    func setETankY(GameScene:GameScene){
    eTankY  = CGFloat(arc4random() % UInt32(GameScene.frame.size.height / 2))
        print(eTankY)
    }

/*func  makeEtank(GameScene:GameScene) {
    
    
    
    let moveEtank = SKAction.moveBy(x: -self.size.width, y: 0, duration: TimeInterval(GameScene.frame.size.width/100))
        let removeEtank = SKAction.removeFromParent()
        let moveAndRemoveEtank = SKAction.sequence([moveEtank, removeEtank])
    
        
    
    
        self.position = CGPoint(x: self.frame.maxX , y: eTankY)
        self.run(moveAndRemoveEtank)
        self.zPosition = -3
        
        
        movingObjects.addChild(self)
        
        self.physicsBody = SKPhysicsBody(rectangleOf: etankTexture.size())
        self.physicsBody!.isDynamic = false
        
    print(self.frame.minX)
        
    }
    */
        
    }


