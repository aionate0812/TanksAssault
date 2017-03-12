//
//  GameScene.swift
//  TanksAssault
//
//  Created by Alexander Onate on 11/20/15.
//  Copyright (c) 2015 Alexander Onate. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var tank = SKSpriteNode()
    var etank = SKSpriteNode()
    var bg = SKSpriteNode()
    var bullet = SKSpriteNode()
    var ebullet = SKSpriteNode()
    var tempTank = SKSpriteNode()
    var tempBullet = SKSpriteNode()
 
    enum physicsCategory: UInt32{
        case player = 1
        case enemy = 2
        case projectile = 3
        
    }
    var lifeoutline = SKSpriteNode()
    var gameOver = false
    var scoreContainer = SKSpriteNode()
    var labelContainer = SKSpriteNode()
    var score = 0
    var scoreLabel = SKLabelNode()
    var movingObjects = SKSpriteNode()
    var tankHandler = [SKSpriteNode]()
    var bulletHandler = [SKSpriteNode]()
    var spawnRate = 2.0
    var gameoverLabel = SKLabelNode()
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
       physicsWorld.contactDelegate = self
        
        
        makeBg()
        
        makePlayer()
        
        randomEtankSpawner()
        
        self.addChild(movingObjects)
        labelContainer.zPosition = 9
        self.addChild(labelContainer)
        
        let ground = SKNode()
        ground.position = CGPoint(x: 0,y: 0)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
        ground.physicsBody!.isDynamic = false
        self.addChild(ground)
        
        
        let life = SKSpriteNode(color: UIColor.black, size: CGSize(width:150,height:15))
        life.position = CGPoint(x: 375,y: 750)
        life.zPosition = 5
        movingObjects.addChild(life)
        
        lifeoutline = SKSpriteNode(color: UIColor.red, size: CGSize(width:150,height:15))
        lifeoutline.position = CGPoint(x: 375,y: 750)
        lifeoutline.zPosition = 6
        movingObjects.addChild(lifeoutline)
        
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 60
        scoreLabel.text = "0"
        scoreLabel.position = CGPoint(x: 675, y: self.frame.size.height - 60)
        scoreLabel.zPosition = 7
        self.addChild(scoreLabel)
        
        
        
        let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipedRight(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        
        
        let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipedLeft(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        
        let swipeUp:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipedUp(_:)))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
        
        
        
        let swipeDown:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipedDown(_:)))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
        
        
        let shootBullet:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GameScene.shotBullet(_:)))
        shootBullet.numberOfTapsRequired = 1
            view.addGestureRecognizer(shootBullet)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       /* Called when a touch begins */
        if gameOver == true {
            
            score = 0
            
            scoreLabel.text = "0"
            
            
            
           
            
            movingObjects.removeAllChildren()
            
            self.makeBg()
            let life = SKSpriteNode(color: UIColor.black, size: CGSize(width:150,height:15))
            life.position = CGPoint(x: 375,y: 750)
            life.zPosition = 5
            movingObjects.addChild(life)
            
            lifeoutline = SKSpriteNode(color: UIColor.red, size: CGSize(width:150,height:15))
            lifeoutline.position = CGPoint(x: 375,y: 750)
            lifeoutline.zPosition = 6
            movingObjects.addChild(lifeoutline)
            
            self.speed = 1
            
            gameOver = false
            
            labelContainer.removeAllChildren()
            
        }
 
       
    }
   
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        
    }


    
    func makePlayer(){
        
        let tankTexture = SKTexture(imageNamed: "tank.gif")

        tank = SKSpriteNode(texture: tankTexture)
        
        let tankTexture2 = SKTexture(imageNamed: "tank2.gif")
        
        let animation = SKAction.animate(with: [tankTexture,tankTexture2],timePerFrame: 0.1)
        let tankMove = SKAction.repeatForever(animation)
        tank.run(tankMove)
        
        tank.physicsBody = SKPhysicsBody(rectangleOf: tankTexture.size())
        
        
        tank.physicsBody!.isDynamic = false
        
        
        tank.position = CGPoint(x:(self.frame.size.width) / 3.1, y: self.frame.midY-40)
        
        tank.physicsBody?.categoryBitMask = physicsCategory.player.rawValue
        tank.physicsBody?.contactTestBitMask = physicsCategory.enemy.rawValue
        
        
        
        self.addChild(tank)
    }



func  makeBullet() {
    
    let bulletTexture = SKTexture(imageNamed: "bullet.gif")
    bullet = SKSpriteNode(texture: bulletTexture)
    bullet.position = CGPoint(x: tank.position.x+40, y: tank.position.y+22)
    
    let moveBullet = SKAction.moveBy(x: 1000, y: 0, duration: 4)
    let removeBullet = SKAction.removeFromParent()
    let moveAndRemoveBullet = SKAction.sequence([moveBullet, removeBullet])
    
    bullet.run(moveAndRemoveBullet)

    
    bullet.physicsBody = SKPhysicsBody(rectangleOf: bulletTexture.size())
    bullet.physicsBody?.allowsRotation = false

    bullet.physicsBody?.affectedByGravity = false
    bullet.physicsBody?.categoryBitMask = physicsCategory.projectile.rawValue
    bullet.physicsBody?.contactTestBitMask = physicsCategory.enemy.rawValue
    bullet.physicsBody?.collisionBitMask = physicsCategory.projectile.rawValue
    bullet.physicsBody!.isDynamic = true
   
    movingObjects.addChild(bullet)
    
    
}
    
    
func makeBg(){
    let bgTexture = SKTexture(imageNamed: "background.gif")
    
    let movebg = SKAction.moveBy(x: -bgTexture.size().width, y: 0, duration: 14)
    let replacebg = SKAction.moveBy(x: bgTexture.size().width, y: 0, duration: 0)
    let movebgForever = SKAction.repeatForever(SKAction.sequence([movebg, replacebg]))
    
    
    var i: CGFloat = 0
    for _ in 0 ..< 3 {
        
        bg = SKSpriteNode(texture: bgTexture)
        
        bg.position = CGPoint(x: bgTexture.size().width/2 + bgTexture.size().width * i, y: self.frame.midY)
        
        bg.size.height = self.frame.height
        
        bg.zPosition = -5
        
        bg.run(movebgForever)
        
        movingObjects.addChild(bg)
        i += 1
        
    }
}


func swipedRight(_ sender:UISwipeGestureRecognizer){
    print("swiped right")
}

func swipedLeft(_ sender:UISwipeGestureRecognizer){
    print("swiped left")
}

func swipedUp(_ sender:UISwipeGestureRecognizer){
    print("swiped up")
    
    if tank.position.y+tank.size.height/2 > self.frame.midY-40{
        tank.position.y = self.frame.midY-40
    }
    else{
        let moveTank = SKAction.moveBy(x: 0, y: 40, duration: 0.2)
        tank.run(moveTank)
        print(tank.position.y)}
}

func swipedDown(_ sender:UISwipeGestureRecognizer){
    print("swiped down")
    if tank.position.y < self.frame.minY+65{
        tank.position.y = self.frame.minY+40
    }
    else {
        let moveTank = SKAction.moveBy(x: 0, y: -40, duration: 0.2)
        tank.run(moveTank)
        print(tank.position.y, self.frame.minY)
    }
}

func shotBullet(_ sender: UITapGestureRecognizer){
 
    self.makeBullet()
    
    
 
}

    func makeEtank() {
        let random: CGFloat = self.frame.midY-60
        let eTankY = CGFloat(arc4random_uniform(UInt32(random))+40)
        
        let etankTexture = SKTexture(imageNamed: "etank.gif")
        let etank = SKSpriteNode (texture: etankTexture)
        etank.physicsBody = SKPhysicsBody(rectangleOf: etankTexture.size())
        etank.physicsBody?.affectedByGravity = false
        etank.physicsBody?.allowsRotation = false
        etank.physicsBody?.categoryBitMask = physicsCategory.enemy.rawValue
        etank.physicsBody?.contactTestBitMask = physicsCategory.projectile.rawValue
        etank.physicsBody?.collisionBitMask = physicsCategory.enemy.rawValue
        etank.physicsBody!.isDynamic = true

        etank.position = CGPoint(x: self.frame.maxX , y: eTankY)
       
        let moveEtank = SKAction.moveBy(x: -frame.size.width, y: 0, duration: TimeInterval(self.frame.size.width/100))
        let removeEtank = SKAction.removeFromParent()
        
        let moveAndRemoveEtank = SKAction.sequence([moveEtank, removeEtank])
        etank.run(moveAndRemoveEtank)
        
        
       movingObjects.addChild(etank)
        
     
    }
    
    func randomEtankSpawner(){
    
        let spawnEtankTimer = SKAction.wait(forDuration: spawnRate)
        
        let spawn = SKAction.run {
            
            
           self.makeEtank()
            
        }
        
        
            
        
        let sequence = SKAction.sequence([spawnEtankTimer,spawn])
    
        self.run(SKAction.repeatForever(sequence))
        
       
    
    
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let firstBody : SKPhysicsBody = contact.bodyA
        let secondBody : SKPhysicsBody = contact.bodyB
        
        
        if ((firstBody.categoryBitMask == physicsCategory.projectile.rawValue)&&(secondBody.categoryBitMask == physicsCategory.enemy.rawValue) || (firstBody.categoryBitMask == physicsCategory.enemy.rawValue)&&(secondBody.categoryBitMask == physicsCategory.projectile.rawValue)){
            score += 1
            
            scoreLabel.text = String(score)
            projectileCollision(enemyTemp: firstBody.node as! SKSpriteNode, projectileTemp: secondBody.node as! SKSpriteNode)
            
            
        
        }
        
        if ((firstBody.categoryBitMask == physicsCategory.enemy.rawValue)&&(secondBody.categoryBitMask == physicsCategory.player.rawValue) || (firstBody.categoryBitMask == physicsCategory.player.rawValue)&&(secondBody.categoryBitMask == physicsCategory.enemy.rawValue)){
            enemyPlayerCollision(enemyTemp: firstBody.node as! SKSpriteNode, playerTemp: secondBody.node as! SKSpriteNode)
            
            
        }
    }
    
    func projectileCollision(enemyTemp: SKSpriteNode, projectileTemp: SKSpriteNode){
       
        print (bullet.position.x)
        enemyTemp.removeFromParent()
        projectileTemp.removeFromParent()
        
    }
    
    func enemyPlayerCollision(enemyTemp: SKSpriteNode, playerTemp: SKSpriteNode){
      self.lifeoutline.size.width=self.lifeoutline.size.width-50
      self.lifeoutline.position.x = self.lifeoutline.position.x-25
        print(lifeoutline.size.width)
        playerTemp.removeFromParent()
        if(lifeoutline.size.width==0){
        if gameOver == false {
            
            gameOver = true
            
            self.speed = 0
            
            gameoverLabel.fontName = "Helvetica"
            gameoverLabel.fontSize = 30
            gameoverLabel.text = "Game Over! Tap to play again."
            gameoverLabel.position = CGPoint(x: 525, y: 300)
            gameoverLabel.zPosition = 8
           
            labelContainer.addChild(gameoverLabel)
            
        }

        }
    }
}



