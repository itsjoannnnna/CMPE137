import SpriteKit
import GameplayKit

struct GameTwelvePhysicsCategory{
    static let Aliens: UInt32 = 1 //lets the last bit equal to 1
    static let Bullet: UInt32 = 2 // lets the last bits equal to 2
    static let Player: UInt32 = 3 //lets the last bits equal to 3
    static let Money: UInt32 = 4
    static let Boss: UInt32 = 5
    static let BossBullet: UInt32 = 6
}

class GameScene12: SKScene, SKPhysicsContactDelegate {
    
    //TAKE OUT AFTER TESTING
    var returnBtn : UIButton!
    
    var HighScore = Int()
    var Level12Score = Int()
    var pauseButton: SKSpriteNode?
    var playButton: SKSpriteNode?
    let backgroundMusic = SKAudioNode(fileNamed: "NewYork.mp3")
    var lastTouch: CGPoint? = nil
    
    @IBInspectable
    let PlayerName = "player"
    let PlayerBulletName = "playerbullet"
    
    let player = SKSpriteNode(imageNamed: "rocket1.png")
    
    var ScoreLabel = UILabel()
    
    //testing to see if tapping works in this scene
    var tapQueue = [Int]()
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var bossMovementDirection: BossMovementDirection = .right
    var timeOfLastMove: CFTimeInterval = 0.0
    var timePerMove: CFTimeInterval = 1.0
    var contactQueue = [SKPhysicsContact]()
    var bossHealth: Float = 1.0
    var gameEnding: Bool = false
    let MinBossBottomHeight: Float = 32.0
    var contentCreated = false
    let BossName = "boss"
    let BossSize = CGSize(width: 50, height: 25)
    let PlayerSize = CGSize(width: 30, height:16)
    
    enum BossType {
        case a
        
        static var size: CGSize {
            return CGSize(width: 24, height: 16)
        }
        
        static var name: String {
            return "boss"
        }
    }
    
    enum BossMovementDirection {
        case right
        case left
        case downThenRight
        case downThenLeft
        case none
    }
    
    enum BulletType {
        case bossFired
        case playerFired
    }
    
    let BossGridSpacing = CGSize(width: 12, height: 12)
    let BossRowCount = 1
    let BossColCount = 1
    let HealthHudName = "healthHud"
    let BossFiredBulletName = "bossFiredBullet"
    let PlayerFiredBulletName = "playerFiredBullet"
    let BulletSize = CGSize(width:4, height:8)
    
    let BossCategory: UInt32 = 0x1 << 0
    let SceneEdgeCategory: UInt32 = 0x1 << 3
    let BossFiredBulletCategory: UInt32 = 0x1 << 4
    let PlayerFiredBulletCategory: UInt32 = 0x1 << 5
    let PlayerCategory: UInt32 = 0x1 << 1
    
    override func didMove(to view: SKView) {
        
        //Background Music
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
        
        self.scene?.backgroundColor = UIColor.black
        
        //Adding Stars
        if let stars = SKEmitterNode(fileNamed: "movingStars") {
            stars.position = CGPoint(x: frame.size.width / 2, y: frame.size.height)
            stars.zPosition = -1
            addChild(stars)
        }
        
        if(!self.contentCreated){
            self.createContent()
            self.contentCreated = true
        }
        
        playButton = childNode(withName: "playButton") as? SKSpriteNode
        playButton?.isHidden = true
        pauseButton = childNode(withName: "pauseButton") as? SKSpriteNode
        
        let HighscoreDefault = UserDefaults.standard
        if (HighscoreDefault.value(forKey: "Highscore") != nil){
            HighScore = HighscoreDefault.value(forKey: "Highscore") as! Int //as! NSInteger
        }
        else{
            HighScore = 0
        }
        
        physicsWorld.contactDelegate = self
        
        //adds the score label to the top of the screen
        ScoreLabel.text = "\(Level12Score)"
        ScoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        ScoreLabel.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.3)
        self.view?.addSubview(ScoreLabel)
        
        //Return button for going back to HomeScreen
        returnBtn = UIButton (frame: CGRect(x: 0, y:0, width: view.frame.size.width/3, height: 30))
        returnBtn.center = CGPoint(x: view.frame.midX-160, y: view.frame.midY-350)
        
        returnBtn.setTitle("Return", for: UIControlState.normal)
        returnBtn.setTitleColor(UIColor.red, for: UIControlState.normal)
        returnBtn.addTarget(self, action: #selector(GameShop.Return), for: UIControlEvents.touchUpInside)
        self.view!.addSubview(returnBtn)
    }
    
    //Return function to redirect scene to HomeScreen
    func Return(){
        //move to specified scene
        let scene = GameScene(fileNamed: "GameScene")
        //starting transition between scenes
        self.view?.presentScene(scene)
        returnBtn.removeFromSuperview()
    }
    
    func createContent(){
        self.scene?.backgroundColor = UIColor.black
        
        //Adding Stars
        if let stars = SKEmitterNode(fileNamed: "movingStars") {
            stars.position = CGPoint(x: frame.size.width / 2, y: frame.size.height)
            stars.zPosition = -1
            addChild(stars)
        }
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody!.categoryBitMask = SceneEdgeCategory
        setupHud()
        setupBoss()
        setupPlayer()
    }
    
    func makeBoss() -> SKNode {
        let boss = SKSpriteNode(imageNamed: "giantalien.png")
        boss.name = BossName
        boss.physicsBody = SKPhysicsBody(rectangleOf: boss.frame.size)
        boss.physicsBody!.isDynamic = false
        boss.physicsBody!.categoryBitMask = BossCategory
        boss.physicsBody!.contactTestBitMask = 0x0
        boss.physicsBody!.collisionBitMask = 0x0
        return boss
    }
    
    func makePlayer()->SKNode{
        player.name = PlayerName
        return player
    }
    
    func setupPlayer() {
        let player = makePlayer()
        player.position = CGPoint(x: PlayerSize.width*8, y: PlayerSize.height * 8)
        addChild(player)
    }
    
    func setupBoss() {
        let boss = makeBoss()
        boss.position = CGPoint(x: BossSize.width*8, y: (BossSize.height-1)*24)
        addChild(boss)
    }
    
    //Health bar
    func setupHud() {
        let healthLabel = SKLabelNode(fontNamed: "Courier")
        healthLabel.name = HealthHudName
        healthLabel.fontSize = 25
        healthLabel.fontColor = SKColor.red
        healthLabel.text = String(format: "Health: %.1f%%", bossHealth * 100.0)
        healthLabel.position = CGPoint(
            x: frame.size.width/2,
            y: size.height - (40 + healthLabel.frame.size.height/2)
        )
        addChild(healthLabel)
    }
    
    func adjustScore() {
        Level12Score += 1
        if Level12Score == 180{
            let sendLevel6Score = UserDefaults.standard
            sendLevel6Score.set(Level12Score, forKey: "Score")
            self.view?.presentScene(GameScene1())
        }
    }
    
    func adjustBossHealth(by healthAdjustment: Float) {
        bossHealth = max(bossHealth + healthAdjustment, 0)
        
        if let health = childNode(withName: HealthHudName) as? SKLabelNode {
            health.text = String(format: "Health: %.1f%%", self.bossHealth * 100)
        }
    }
    
    func makeBullet(ofType bulletType: BulletType) -> SKNode {
        var bullet: SKNode
        
        switch bulletType {
        case .bossFired:
            bullet = SKSpriteNode(color: SKColor.green, size: BulletSize)
            bullet.name = BossFiredBulletName
            
            bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.frame.size)
            bullet.physicsBody!.isDynamic = true
            bullet.physicsBody!.affectedByGravity = false
            bullet.physicsBody!.categoryBitMask = BossFiredBulletCategory
            bullet.physicsBody!.contactTestBitMask = PlayerCategory
            bullet.physicsBody!.collisionBitMask = 0x0
        case .playerFired:
            bullet = SKSpriteNode(color: SKColor.red, size: BulletSize)
            bullet.name = PlayerFiredBulletName
            bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.frame.size)
            bullet.physicsBody!.isDynamic = true
            bullet.physicsBody!.affectedByGravity = false
            bullet.physicsBody!.categoryBitMask = PlayerFiredBulletCategory
            bullet.physicsBody!.contactTestBitMask = BossCategory
            bullet.physicsBody!.collisionBitMask = 0x0
            break
            
        }
        return bullet
    }
    
    func moveBoss(forUpdate currentTime: CFTimeInterval) {
        if(currentTime - timeOfLastMove < timePerMove) {
            return
        }
        
        determineBossMovementDirection()
        
        enumerateChildNodes(withName: BossType.name) {
            node, stop in
            switch self.bossMovementDirection{
            case .right:
                node.position = CGPoint(x: node.position.x + 10, y: node.position.y)
            case .left:
                node.position = CGPoint(x: node.position.x - 10, y: node.position.y)
            case .downThenLeft, .downThenRight:
                node.position = CGPoint(x: node.position.x, y: node.position.y - 10)
            case .none:
                break
            }
            self.timeOfLastMove = currentTime
        }
    }
    
    func adjustBossMovement(to timePerMove: CFTimeInterval) {
        if self.timePerMove <= 0 {
            return
        }
        
        let ratio: CGFloat = CGFloat(self.timePerMove/timePerMove)
        self.timePerMove = timePerMove
        
        enumerateChildNodes(withName: BossType.name) {
            node, stop in
            node.speed = node.speed * ratio
        }
    }
    
    func fireBossBullets(forUpdate currentTime: CFTimeInterval) {
        let existingBullet = childNode(withName: BossFiredBulletName)
        
        if existingBullet == nil {
            var allBoss = [SKNode]()
            
            enumerateChildNodes(withName: BossType.name) {
                node, stop in
                allBoss.append(node)
            }
            
            if allBoss.count > 0 {
                let allBossIndex = Int(arc4random_uniform(UInt32(allBoss.count)))
                
                let boss = allBoss[allBossIndex]
                
                let bullet = makeBullet(ofType: .bossFired)
                bullet.position = CGPoint(
                    x: boss.position.x,
                    y: boss.position.y - boss.frame.size.height/2 + bullet.frame.size.height/2
                )
                
                let bulletDestination = CGPoint(x: boss.position.x, y: -(bullet.frame.size.height/2))
                
                fireBullet(
                    bullet: bullet,
                    toDestination: bulletDestination,
                    withDuration: 2.0
                )
            }
        }
    }
    
    func fireBullet(bullet: SKNode, toDestination destination: CGPoint, withDuration duration: CFTimeInterval) {
        let bulletAction = SKAction.sequence([
            SKAction.move(to: destination, duration: duration),
            SKAction.wait(forDuration: 3.0 / 60.0),
            SKAction.removeFromParent()
            ])
        
        bullet.run(SKAction.group([bulletAction]))
        addChild(bullet)
    }
    
    func firePlayerBullets(forUpdate currentTime: CFTimeInterval ){
        //        let existingBullet = childNode(withName: PlayerFiredBulletName)
        //        if existingBullet == nil{
        if let Player = childNode(withName: PlayerName){
            let bullet = makeBullet(ofType: .playerFired)
            bullet.position = CGPoint(x: Player.position.x, y: Player.position.y + Player.frame.size.height - bullet.frame.size.height/2)
            let bulletDestination = CGPoint(x: Player.position.x, y: frame.size.height + bullet.frame.size.height/2)
            fireBullet(bullet: bullet, toDestination: bulletDestination, withDuration: 0.8)
        }
        //}
        
    }
    
    func processContacts(forUpdate currentTime: CFTimeInterval) {
        for contact in contactQueue {
            handle(contact)
            
            if let index = contactQueue.index(of: contact) {
                contactQueue.remove(at: index)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        processContacts(forUpdate: currentTime)
        if isGameOver() {
            endGame()
        }
        moveBoss(forUpdate: currentTime)
        fireBossBullets(forUpdate: currentTime)
        firePlayerBullets(forUpdate: currentTime)
    }
    
    func determineBossMovementDirection() {
        var proposedMovementDirection: BossMovementDirection = bossMovementDirection
        enumerateChildNodes(withName: BossType.name) {
            node, stop in
            switch self.bossMovementDirection {
            case .right:
                if(node.frame.maxX >= node.scene!.size.width - 1.0) {
                    proposedMovementDirection = .downThenLeft
                    
                    self.adjustBossMovement(to: self.timePerMove * 0.8)
                    stop.pointee = true
                }
            case .left:
                if(node.frame.minX <= 1.0) {
                    proposedMovementDirection = .downThenRight
                    
                    self.adjustBossMovement(to: self.timePerMove * 0.8)
                    
                    stop.pointee = true
                }
            case .downThenLeft:
                proposedMovementDirection = .left
                stop.pointee = true
                
            case .downThenRight:
                proposedMovementDirection = .right
                stop.pointee = true
                
            default:
                break
            }
        }
        if(proposedMovementDirection != bossMovementDirection) {
            bossMovementDirection = proposedMovementDirection
        }
    }
    
    func handle(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.parent == nil || contact.bodyB.node?.parent == nil {
            return
        }
        
        let nodeNames = [contact.bodyA.node!.name!, contact.bodyB.node!.name!]
        
        if nodeNames.contains(PlayerName) && nodeNames.contains(BossFiredBulletName) {
            //Boss bullet hit ship
            
            adjustBossHealth(by: -0.334)
            if bossHealth <= 0.0 {
                contact.bodyA.node!.removeFromParent()
                contact.bodyB.node!.removeFromParent()
                let Level1Score = UserDefaults.standard
                Level1Score.set(Level12Score, forKey: "Level1Score")
                self.view?.presentScene(GameScene1())
            } else {
                if let boss = childNode(withName: BossType.name) {
                    boss.alpha = CGFloat(bossHealth)
                    
                    if contact.bodyA.node == boss {
                        contact.bodyB.node!.removeFromParent()
                    } else {
                        contact.bodyA.node!.removeFromParent()
                    }
                }
            }
        } else if nodeNames.contains(BossType.name) && nodeNames.contains(PlayerBulletName) {
            contact.bodyA.node!.removeFromParent()
            contact.bodyB.node!.removeFromParent()
        }
    }
    
    func isGameOver() -> Bool {
        let boss = childNode(withName: BossType.name)
        
        var bossTooLow = false
        
        enumerateChildNodes(withName: BossType.name) {
            node, stop in
            if(Float(node.frame.minY) <= self.MinBossBottomHeight) {
                bossTooLow = true
                stop.pointee = true
            }
        }
        let ship = childNode(withName: PlayerName)
        return boss == nil || bossTooLow || ship == nil
    }
    
    func endGame() {
        if !gameEnding {
            gameEnding = true
            
            //let gameOverScene: EndScene = EndScene(size: size)
            
            //view?.presentScene(gameOverScene, transition: SKTransition.doorsOpenHorizontal(withDuration: 1.0))
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let location = touch.location(in: self)
            player.position.x = location.x
        }
        
        let touch = touches.first! as UITouch
        let touchLocation = touch.location(in: self)
        //print(touchLocation)
        
        let nodes = self.atPoint(touchLocation)
        if nodes.name == "pauseButton" {
            let showPlayButtonAction = SKAction.run(showPlayButton)
            let pauseGameAction = SKAction.run(pauseGame)
            let pauseSequence = SKAction.sequence([showPlayButtonAction, pauseGameAction])
            run(pauseSequence)
        }
        else if nodes.name == "playButton"{
            self.resumeGame()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let location = touch.location(in: self)
            player.position.x = location.x
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if (touch.tapCount == 1) {
                tapQueue.append(1)
            }
        }
    }
    
    func pauseGame() {
        self.view!.isPaused = true
    }
    
    func resumeGame() {
        playButton!.isHidden = true
        pauseButton!.isHidden = false
        self.view?.isPaused = false
    }
    
    func showPlayButton() {
        pauseButton!.isHidden = true
        playButton!.isHidden = false
    }
}
