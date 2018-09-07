import SpriteKit

public class FlappyCatScene: SKScene, SKPhysicsContactDelegate {
    let verticalPipeGap = 150.0

    var cat: SKSpriteNode!
    var skyColor = SKColor(red: 255.0/255.0, green: 240.0/255.0, blue: 251.0/255.0, alpha: 1.0)
    var pipeTextureUp: SKTexture!
    var pipeTextureDown: SKTexture!
    var movePipesAndRemove: SKAction!
    var moving: SKNode!
    var pipes: SKNode!
    var canRestart = false
    var scoreLabelNode: SKLabelNode!
    var score = NSInteger()

    let catCategory: UInt32 = 1 << 0
    let worldCategory: UInt32 = 1 << 1
    let pipeCategory: UInt32 = 1 << 2
    let scoreCategory: UInt32 = 1 << 3
    
    override public func didMove(to view: SKView) {
        canRestart = true

        // setup physics
        physicsWorld.gravity = CGVector( dx: 0.0, dy: -5.0 )
        physicsWorld.contactDelegate = self

        backgroundColor = skyColor

        moving = SKNode()
        addChild(moving)
        pipes = SKNode()
        moving.addChild(pipes)

        // ground
        let groundTexture = SKTexture(imageNamed: "land")
        groundTexture.filteringMode = .nearest

        let moveGroundSprite = SKAction.moveBy(x: -groundTexture.size().width * 2.0, y: 0, duration: TimeInterval(0.02 * groundTexture.size().width * 2.0))
        let resetGroundSprite = SKAction.moveBy(x: groundTexture.size().width * 2.0, y: 0, duration: 0.0)
        let moveGroundSpritesForever = SKAction.repeatForever(SKAction.sequence([moveGroundSprite, resetGroundSprite]))

        for index in 0 ..< 2 + Int(frame.size.width / ( groundTexture.size().width * 2 )) {
            let sprite = SKSpriteNode(texture: groundTexture)
            sprite.setScale(2.0)
            sprite.position = CGPoint(x: CGFloat(index) * sprite.size.width, y: sprite.size.height / 2.0)
            sprite.run(moveGroundSpritesForever)
            moving.addChild(sprite)
        }

        // skyline
        let skyTexture = SKTexture(imageNamed: "sky")
        skyTexture.filteringMode = .nearest

        let moveSkySprite = SKAction.moveBy(x: -skyTexture.size().width * 2.0, y: 0, duration: TimeInterval(0.1 * skyTexture.size().width * 2.0))
        let resetSkySprite = SKAction.moveBy(x: skyTexture.size().width * 2.0, y: 0, duration: 0.0)
        let moveSkySpritesForever = SKAction.repeatForever(SKAction.sequence([moveSkySprite,resetSkySprite]))

        for index in 0 ..< 2 + Int(frame.size.width / ( skyTexture.size().width * 2 )) {
            let sprite = SKSpriteNode(texture: skyTexture)
            sprite.setScale(2.0)
            sprite.zPosition = -20
            sprite.position = CGPoint(x: CGFloat(index) * sprite.size.width, y: sprite.size.height / 2.0 + groundTexture.size().height * 2.0)
            sprite.run(moveSkySpritesForever)
            moving.addChild(sprite)
        }

        // create the pipes textures
        pipeTextureUp = SKTexture(imageNamed: "PipeUp")
        pipeTextureUp.filteringMode = .nearest
        pipeTextureDown = SKTexture(imageNamed: "PipeDown")
        pipeTextureDown.filteringMode = .nearest

        // create the pipes movement actions
        let distanceToMove = CGFloat(frame.size.width + 2.0 * pipeTextureUp.size().width)
        let movePipes = SKAction.moveBy(x: -distanceToMove, y:0.0, duration:TimeInterval(0.01 * distanceToMove))
        let removePipes = SKAction.removeFromParent()
        movePipesAndRemove = SKAction.sequence([movePipes, removePipes])

        // spawn the pipes
        let spawn = SKAction.run(spawnPipes)
        let delay = SKAction.wait(forDuration: TimeInterval(2.0))
        let spawnThenDelay = SKAction.sequence([spawn, delay])
        let spawnThenDelayForever = SKAction.repeatForever(spawnThenDelay)
        run(spawnThenDelayForever)

        // setup our cat
        let catTexture1 = SKTexture(imageNamed: "cat-01")
        catTexture1.filteringMode = .nearest
        let catTexture2 = SKTexture(imageNamed: "cat-02")
        catTexture2.filteringMode = .nearest

        let animationAction = SKAction.animate(with: [catTexture1, catTexture2], timePerFrame: 0.2)
        let flapAction = SKAction.repeatForever(animationAction)

        cat = SKSpriteNode(texture: catTexture1)
        cat.setScale(2.0)
        cat.position = CGPoint(x: frame.size.width * 0.35, y:frame.size.height * 0.6)
        cat.run(flapAction)

        cat.physicsBody = SKPhysicsBody(circleOfRadius: cat.size.height / 2.0)
        cat.physicsBody?.isDynamic = true
        cat.physicsBody?.allowsRotation = false

        cat.physicsBody?.categoryBitMask = catCategory
        cat.physicsBody?.collisionBitMask = worldCategory | pipeCategory
        cat.physicsBody?.contactTestBitMask = worldCategory | pipeCategory

        addChild(cat)

        // create the ground
        let ground = SKNode()
        ground.position = CGPoint(x: 0, y: groundTexture.size().height)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: frame.size.width, height: groundTexture.size().height * 2.0))
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = worldCategory
        addChild(ground)

        // Initialize label and create a label which holds the score
        score = 0
        scoreLabelNode = SKLabelNode(fontNamed:"MarkerFelt-Wide")
        scoreLabelNode.position = CGPoint( x: frame.midX, y: 3 * frame.size.height / 4 )
        scoreLabelNode.zPosition = 100
        scoreLabelNode.text = String(score)
        scoreLabelNode.fontColor = .black
        addChild(scoreLabelNode)
        
    }

    func spawnPipes() {
        let pipePair = SKNode()
        pipePair.position = CGPoint( x: frame.size.width + pipeTextureUp.size().width * 2, y: 0 )
        pipePair.zPosition = -10

        let height = UInt32( frame.size.height / 4)
        let y = Double(arc4random_uniform(height) + height)

        let pipeDown = SKSpriteNode(texture: pipeTextureDown)
        pipeDown.setScale(2.0)
        pipeDown.position = CGPoint(x: 0.0, y: y + Double(pipeDown.size.height) + verticalPipeGap)

        pipeDown.physicsBody = SKPhysicsBody(rectangleOf: pipeDown.size)
        pipeDown.physicsBody?.isDynamic = false
        pipeDown.physicsBody?.categoryBitMask = pipeCategory
        pipeDown.physicsBody?.contactTestBitMask = catCategory
        pipePair.addChild(pipeDown)

        let pipeUp = SKSpriteNode(texture: pipeTextureUp)
        pipeUp.setScale(2.0)
        pipeUp.position = CGPoint(x: 0.0, y: y)

        pipeUp.physicsBody = SKPhysicsBody(rectangleOf: pipeUp.size)
        pipeUp.physicsBody?.isDynamic = false
        pipeUp.physicsBody?.categoryBitMask = pipeCategory
        pipeUp.physicsBody?.contactTestBitMask = catCategory
        pipePair.addChild(pipeUp)

        let contactNode = SKNode()
        contactNode.position = CGPoint( x: pipeDown.size.width + cat.size.width / 2, y: frame.midY )
        contactNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize( width: pipeUp.size.width, height: frame.size.height ))
        contactNode.physicsBody?.isDynamic = false
        contactNode.physicsBody?.categoryBitMask = scoreCategory
        contactNode.physicsBody?.contactTestBitMask = catCategory
        pipePair.addChild(contactNode)

        pipePair.run(movePipesAndRemove)
        pipes.addChild(pipePair)
    }

    func resetScene() {
        // Move cat to original position and reset velocity
        cat.position = CGPoint(x: frame.size.width / 2.5, y: frame.midY)
        cat.physicsBody?.velocity = CGVector( dx: 0, dy: 0 )
        cat.physicsBody?.collisionBitMask = worldCategory | pipeCategory
        cat.speed = 1.0
        cat.zRotation = 0.0

        // Remove all existing pipes
        pipes.removeAllChildren()

        // Reset canRestart
        canRestart = false

        // Reset score
        score = 0
        scoreLabelNode.text = String(score)

        // Restart animation
        moving.speed = 1
    }

    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if moving.speed > 0  {
            for _ in touches { // do we need all touches?
                cat.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                cat.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 30))
            }
        } else if canRestart {
            resetScene()
        }
    }

    /* Called before each frame is rendered */
    override public func update(_ currentTime: TimeInterval) {
        guard let physicsBody = cat.physicsBody else {
            return
        }

        let value = physicsBody.velocity.dy * (physicsBody.velocity.dy < 0 ? 0.003 : 0.001)
        cat.zRotation = min( max(-1, value), 0.5 )
    }

    public func didBegin(_ contact: SKPhysicsContact) {
        if moving.speed > 0 {
            if ( contact.bodyA.categoryBitMask & scoreCategory ) == scoreCategory || ( contact.bodyB.categoryBitMask & scoreCategory ) == scoreCategory {
                // Cat has contact with score entity
                score += 1
                scoreLabelNode.text = String(score)

                // Add a little visual feedback for the score increment
                scoreLabelNode.run(SKAction.sequence([SKAction.scale(to: 1.5, duration:TimeInterval(0.1)), SKAction.scale(to: 1.0, duration:TimeInterval(0.1))]))
            } else {
                moving.speed = 0

                cat.physicsBody?.collisionBitMask = worldCategory
                cat.run(SKAction.rotate(byAngle: CGFloat(Double.pi) * CGFloat(cat.position.y) * 0.01, duration:1), completion: {
                    self.cat.speed = 0
                })

                // Flash background if contact is detected
                removeAction(forKey: "flash")
                run(SKAction.sequence([SKAction.repeat(SKAction.sequence([SKAction.run({
                    self.backgroundColor = SKColor(red: 255.0/255.0, green: 193.0/255.0, blue: 199.0/255.0, alpha: 1.0)
                }),SKAction.wait(forDuration: TimeInterval(0.05)), SKAction.run({
                    self.backgroundColor = self.skyColor
                }), SKAction.wait(forDuration: TimeInterval(0.05))]), count:4), SKAction.run({
                    self.canRestart = true
                })]), withKey: "flash")
            }
        }
    }
}
