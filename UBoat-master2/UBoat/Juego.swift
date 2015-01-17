//
//  Juego.swift
//  UBoat LEX
//
//  Created by Berganza on 16/12/2014.
//  Copyright (c) 2014 Berganza. All rights reserved.
//


import SpriteKit




class Juego: SKScene, SKPhysicsContactDelegate {
    
    var pausedButon = SKSpriteNode()
    var playButon = SKSpriteNode()
    let constraint = SKConstraint.zRotation(SKRange(constantValue: 0))
    var fondo = SKSpriteNode()
    var fdcielo = SKSpriteNode()
    
    
    var contadorImpactos = NSInteger()
    var contadorImpactosLabel = SKLabelNode()
    var puntuacion = NSInteger()
    var contadorPuntuacionLabel = SKLabelNode()
    
    var submarino = SKSpriteNode()
    let submarinoAtlas = SKTextureAtlas(named: "UBoat.atlas")
    var estelaSubmarino = SKEmitterNode()
    
    var prisma = SKSpriteNode()
    var enemigo = SKSpriteNode()
    var misil = SKSpriteNode()
    var gameOverLabel = SKLabelNode()
    var menuLabel = SKLabelNode()
    
    
    var moverArriba = SKAction()
    var moverAbajo = SKAction()
    var contadorEscala: CGFloat = 0.5
    
    
    
    let velocidadMar: CGFloat = 2
    let velocidadCielo: CGFloat = 1
    
    
    
    var velocidadJuego = 9.0
    var velocidadBarcoEnemigo = 10.0
    
    let categoriaSubmarino : UInt32 = 1<<0
    let categoriaEnemigo : UInt32 = 1<<1
    let categoriaMisil : UInt32 = 1<<2
    let categoriaAcorazado : UInt32 = 1<<3
    
    var escena = SKNode()
    
    

    
    override func didMoveToView(view: SKView) {
        
        
        self.addChild(escena)
        self.physicsWorld.gravity = CGVectorMake(0.0, 0.0)
        self.physicsWorld.contactDelegate  = self
        backgroundColor = UIColor.cyanColor()
        
        
        heroe()
        prismaticos()
        crearCielo()
        crearOceano ()
        mostrarColisiones()
        mostrarPuntuacion()
        playEscena()
        pauseEscena()
        
        
        
        
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([SKAction.runBlock(aparecerEnemigo),
                SKAction.waitForDuration(velocidadJuego)])))
        
        
    }
    
    func playEscena(){
        playButon = SKSpriteNode(imageNamed: "playButon")
        playButon.setScale(0.5)
        playButon.zPosition = 6
        playButon.position = CGPointMake(55, 20)
        escena.addChild(playButon)
    }
    
    func pauseEscena(){
        pausedButon = SKSpriteNode(imageNamed: "pausedButon")
        pausedButon.setScale(0.5)
        pausedButon.zPosition = 6
        pausedButon.position = CGPointMake(20, 20)
        escena.addChild(pausedButon)
    }

    
    func volverMenu(){
        menuLabel.fontName = "Avenir"
        menuLabel.fontSize  = 50
        menuLabel.fontColor = UIColor.whiteColor()
        menuLabel.alpha = 1
        menuLabel.zPosition = 6
        menuLabel.position = CGPointMake(self.frame.width / 2, self.frame.height / 2 - 100)
        menuLabel.text = "Volver al Menú"
        escena.addChild(menuLabel)
    }
    
    func gameOver(){
        gameOverLabel.fontName = "Avenir"
        gameOverLabel.fontSize  = 50
        gameOverLabel.fontColor = UIColor.redColor()
        gameOverLabel.alpha = 1
        gameOverLabel.zPosition = 6
        gameOverLabel.position = CGPointMake(self.frame.width / 2, self.frame.height / 2 + 50)
        gameOverLabel.text = "GAME OVER"
        escena.addChild(gameOverLabel)
    }


    
    func mostrarPuntuacion(){
        puntuacion = 0
        contadorPuntuacionLabel.fontName = "Avenir"
        contadorPuntuacionLabel.fontSize  = 20
        contadorPuntuacionLabel.fontColor = UIColor.greenColor()
        contadorPuntuacionLabel.alpha = 1
        contadorPuntuacionLabel.zPosition = 5
        contadorPuntuacionLabel.position = CGPointMake(120, self.frame.height - 25)
        contadorPuntuacionLabel.text = "\(puntuacion): " + "Enemigos abatidos"
        escena.addChild(contadorPuntuacionLabel)
    }
    
    
    func mostrarColisiones(){
        contadorImpactos = 5
        contadorImpactosLabel.fontName = "Avenir"
        contadorImpactosLabel.fontSize  = 20
        contadorImpactosLabel.fontColor = UIColor.redColor()
        contadorImpactosLabel.alpha = 1
        contadorImpactosLabel.zPosition = 5
        contadorImpactosLabel.position = CGPointMake(self.frame.width - 120, self.frame.height - 25)
        contadorImpactosLabel.text = "Impactos restantes: " + "\(contadorImpactos)"
        escena.addChild(contadorImpactosLabel)
    }
    
    func heroe(){
        
        submarino = SKSpriteNode(texture: submarinoAtlas.textureNamed("Uboat12"))
        submarino.setScale(0.5)
        submarino.zPosition = 4
        submarino.position = CGPointMake((submarino.size.width ), self.frame.height / 2)
        submarino.constraints = [constraint]
        submarino.name = "heroe"
        
        let estelaSubmarino1 = SKEmitterNode(fileNamed: "estelaSubDer.sks")
        estelaSubmarino1.zPosition = 0
        estelaSubmarino1.alpha = 1
        estelaSubmarino1.setScale(0.36)
        estelaSubmarino1.position = CGPointMake(87, -22)
        submarino.addChild(estelaSubmarino1)
        
        let estelaSubmarino2 = SKEmitterNode(fileNamed: "estelaSubIzq.sks")
        estelaSubmarino2.zPosition = -1
        estelaSubmarino2.alpha = 1
        estelaSubmarino2.setScale(0.34)
        estelaSubmarino2.position = CGPointMake(87, -7)
        submarino.addChild(estelaSubmarino2)
        
        
        submarino.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(submarino.size.width - 30, 15))
        submarino.physicsBody?.dynamic = true
        submarino.physicsBody?.categoryBitMask = categoriaSubmarino
        submarino.physicsBody?.collisionBitMask = categoriaEnemigo
        submarino.physicsBody?.contactTestBitMask  = categoriaEnemigo
        escena.addChild(submarino)
        
        submarinoNavega()
        
        moverArriba = SKAction.moveByX(0, y: 10, duration: 0.1)
        moverAbajo = SKAction.moveByX(0, y: -10, duration: 0.1)

        }
   
    
    
    // Sprite Submarino navegando no funciona
    
    func submarinoNavega (){
        
        var u1 = submarinoAtlas.textureNamed("Uboat06")
        var u2 = submarinoAtlas.textureNamed("Uboat07")
        var u3 = submarinoAtlas.textureNamed("Uboat08")
        var u4 = submarinoAtlas.textureNamed("Uboat09")
        var u5 = submarinoAtlas.textureNamed("Uboat10")
        var u6 = submarinoAtlas.textureNamed("Uboat11")
        var u7 = submarinoAtlas.textureNamed("Uboat12")
//        var u8 = submarinoAtlas.textureNamed("Uboat12")
//        var u9 = submarinoAtlas.textureNamed("Uboat11")
//        var u10 = submarinoAtlas.textureNamed("Uboat10")
//        var u11 = submarinoAtlas.textureNamed("Uboat09")
//        var u12 = submarinoAtlas.textureNamed("Uboat08")
//        var u13 = submarinoAtlas.textureNamed("Uboat07")
//        var u14 = submarinoAtlas.textureNamed("Uboat06")
//        var u15 = submarinoAtlas.textureNamed("Uboat06")

        
        //let arraySubmarino = [u1,u2,u3,u4,u5,u6,u7,u8,u9,u10,u11,u12,u13,u14,u15]
        
        let arraySubmarino = [u7,u7,u7,u7,u7,u6,u5,u4,u3,u2,u1,u2,u3,u4,u5,u6,u7]
        
        var submarinoNavega = SKAction.animateWithTextures(arraySubmarino, timePerFrame: 0.2)
        
        submarinoNavega = SKAction.repeatActionForever(submarinoNavega)
        
        submarino.runAction(submarinoNavega)
        
    }

    
    
    
    
    
    
    
    func aparecerEnemigo(){
        var altura = UInt (self.frame.size.height - 50 )
        var alturaRandom = UInt (arc4random()) % altura
        
        enemigo = SKSpriteNode(imageNamed: "enemigo")
        enemigo.setScale(0.3)
        enemigo.zPosition = 4
        enemigo.position = CGPointMake(self.frame.size.width - enemigo.size.width + enemigo.size.width * 2, CGFloat(25 + alturaRandom))
        enemigo.name = "enemigo"
        
        let estelaEnemigo = SKEmitterNode(fileNamed: "estelaEnemigo.sks")
        estelaEnemigo.zPosition = 0
        estelaEnemigo.setScale(0.5)
        estelaEnemigo.position = CGPointMake(20, -45)
        enemigo.addChild(estelaEnemigo)
        
        enemigo.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(enemigo.size.width - 30, 5))
        enemigo.physicsBody?.dynamic = true
        enemigo.physicsBody?.categoryBitMask = categoriaEnemigo
        enemigo.physicsBody?.collisionBitMask = categoriaSubmarino
        enemigo.physicsBody?.contactTestBitMask  = categoriaSubmarino
        escena.addChild(enemigo)
        
        
        var alturaEnemigo = UInt (self.frame.size.height - 100 )
        var alturaEnemigoRandom = UInt (arc4random()) % altura
        var desplazarEnemigo = SKAction.moveTo(CGPointMake( -enemigo.size.width * 2 , CGFloat(50 + alturaEnemigoRandom)), duration: velocidadBarcoEnemigo)
       enemigo.runAction(desplazarEnemigo)
        }
    
    
    
    
    func lanzarMisil(){
        misil = SKSpriteNode(imageNamed: "misil")
        misil.setScale(0.5)
        misil.zPosition = 10
        misil.position = CGPointMake(submarino.position.x + 50 , submarino.position.y - 30)
        misil.alpha = 1
        misil.constraints = [constraint]
        misil.name = "misil"
        
        let estelaMisil = SKEmitterNode(fileNamed: "estelaMisil.sks")
        estelaMisil.zPosition = 0
        estelaMisil.setScale(0.3)
        estelaMisil.alpha = 0.5
        estelaMisil.position = CGPointMake(-180, 0)
        misil.addChild(estelaMisil)
        
        misil.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(misil.size.width - 10, misil.size.height))
        misil.physicsBody?.dynamic = true
        misil.physicsBody?.categoryBitMask = categoriaMisil
        misil.physicsBody?.collisionBitMask = categoriaEnemigo
        misil.physicsBody?.contactTestBitMask  = categoriaEnemigo
        escena.addChild(misil)

        var lanzarMisil = SKAction.moveTo(CGPointMake( self.frame.width + misil.size.width * 2, submarino.position.y - 30), duration:2.0)
        misil.runAction(lanzarMisil)
    }

    
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        let tocarMenuLabel: AnyObject = touches.anyObject()!
        let posicionTocarMenuLabel = tocarMenuLabel.locationInNode(self)
        let tocamosMenuLabel = self.nodeAtPoint(posicionTocarMenuLabel)
        
        if tocamosMenuLabel == menuLabel {
            let transicion = SKTransition.revealWithDirection(SKTransitionDirection.Right, duration: 2)
            let  aparecerEscena = Menu(size: self.size)
            aparecerEscena.scaleMode = SKSceneScaleMode.AspectFill
            self.scene?.view?.presentScene(aparecerEscena, transition: transicion)
        }
        
        let tocarPausedButon: AnyObject = touches.anyObject()!
        let posicionTocarPaused = tocarPausedButon.locationInNode(self)
        let tocamosPausedButon = self.nodeAtPoint(posicionTocarPaused)
        
        if tocamosPausedButon == pausedButon  {
        escena.speed = 0
        }
        
        
        let tocarPlayButon: AnyObject = touches.anyObject()!
        let posicionTocarPlay = tocarPlayButon.locationInNode(self)
        let tocamosPlayButon = self.nodeAtPoint(posicionTocarPlay)
        
        if tocamosPlayButon == playButon  {
            escena.speed = 1
        }

        
        
        
        let tocarSubmarino: AnyObject = touches.anyObject()!
        
        let posicionTocar = tocarSubmarino.locationInNode(self)
        
        let loQueTocamos = self.nodeAtPoint(posicionTocar)
        
        if loQueTocamos == submarino {
            
           lanzarMisil()
        }
        
        
        if escena.speed > 0 {
            for toke: AnyObject in touches {
        
        let dondeTocamos = toke.locationInNode(self)
        
        if dondeTocamos.y > submarino.position.y {
            
            if submarino.position.y < 290 {
                //submarino.position.x = (submarino.size.width / 2)+10
                contadorEscala = contadorEscala - 0.05
                if contadorEscala < 0.4 {
                    contadorEscala = 0.4
                }
                submarino.setScale(contadorEscala)
                submarino.runAction(moverArriba)

            }
            
            
        } else {
            
            if submarino.position.y > 65 {
                //submarino.position.x = (submarino.size.width / 2)+10
                contadorEscala = contadorEscala + 0.05
                if contadorEscala > 1 {
                    contadorEscala = 1
                }
                submarino.setScale(contadorEscala)
                submarino.runAction(moverAbajo)
            }
        }
        
    }}

       
      }

    


    func prismaticos() {
        
        prisma = SKSpriteNode(imageNamed: "prismatic")
        prisma.setScale(0.66)
        prisma.zPosition = 4
        prisma.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        
        addChild(prisma)
        
    }
    
    
    
    
    
    
    
    
    func crearCielo() {
        
        for var indice = 0; indice < 2; ++indice {
            
            let fdcielo = SKSpriteNode(imageNamed: "Cielo")
            fdcielo.position = CGPoint(x: (indice * Int(fdcielo.size.width)) + Int(fdcielo.size.width)/2, y: Int(fdcielo.size.height)/2)
            fdcielo.name = "fdcielo"
            fdcielo.zPosition = -1
            
            addChild(fdcielo)
        }
    }
    
    
    
    func scrollCielo() {
        
        self.enumerateChildNodesWithName("fdcielo", usingBlock: { (nodo, stop) -> Void in
            if let fdcielo = nodo as? SKSpriteNode {
                
                fdcielo.position = CGPoint(
                    x: fdcielo.position.x - self.velocidadCielo,
                    y: fdcielo.position.y)
                
                if fdcielo.position.x <= -fdcielo.size.width {
                    
                    fdcielo.position = CGPointMake(
                        fdcielo.position.x + fdcielo.size.width * 2,
                        fdcielo.position.y)
                }
            }
        })
        
    }

    
    
    
    
    func crearOceano() {
        
        for var indice = 0; indice < 2; ++indice {
            
            let fondo = SKSpriteNode(imageNamed: "mar4")
            fondo.position = CGPoint(x: (indice * Int(fondo.size.width)) + Int(fondo.size.width)/2, y: Int(fondo.size.height)/2)
            
            fondo.name = "fondo"
            fondo.zPosition = 0
            
            addChild(fondo)

        }

    }
    
    
    func scrollMar() {
        
        self.enumerateChildNodesWithName("fondo", usingBlock: { (nodo, stop) -> Void in
            if let fondo = nodo as? SKSpriteNode {
                
                fondo.position = CGPoint(
                    x: fondo.position.x - self.velocidadMar,
                    y: fondo.position.y)
                
                if fondo.position.x <= -fondo.size.width {
                    
                    fondo.position = CGPointMake(
                        fondo.position.x + fondo.size.width * 2,
                        fondo.position.y)
                }
            }
        })
        
        }
    
    
    
    override func update(currentTime: NSTimeInterval) {
        scrollCielo()
        scrollMar()
    }
    
        
    
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        if (contact.bodyA.categoryBitMask & categoriaSubmarino) == categoriaSubmarino && enemigo.physicsBody?.dynamic == true {
            
            misil.physicsBody?.dynamic = false
            enemigo.physicsBody?.dynamic = false
            
            var explotarEnemigo = SKAction.runBlock({() in self.destruirBarco()})
            var retardo = SKAction.waitForDuration(0.5)
            var enemigoDesaparece = SKAction.removeFromParent()
            var controlEnemigo = SKAction.sequence([explotarEnemigo, retardo, enemigoDesaparece])
            enemigo.runAction(controlEnemigo)
            
            var explotarSubmarino = SKAction.runBlock({() in self.destruirSubmarinoDamage()})
            
            runAction(explotarSubmarino)
            
            contadorImpactos--
            contadorImpactosLabel.text = "Impactos restantes: " + "\(contadorImpactos)"
            puntuacion++
            contadorPuntuacionLabel.text = "\(puntuacion): " + "Enemigos abatidos"

        }
        
        if (contact.bodyB.categoryBitMask & categoriaMisil) == categoriaMisil && enemigo.physicsBody?.dynamic == true && enemigo.position.x < self.frame.width - enemigo.size.width {
            
            enemigo.physicsBody?.dynamic = false
            
            misil.removeFromParent()
            var explotarEnemigo = SKAction.runBlock({() in self.destruirBarco()})
            var retardo = SKAction.waitForDuration(0.5)
            var enemigoDesaparece = SKAction.removeFromParent()
            var controlEnemigo = SKAction.sequence([explotarEnemigo, retardo, enemigoDesaparece])
            enemigo.runAction(controlEnemigo)
            
            puntuacion++
            contadorPuntuacionLabel.text = "\(puntuacion): " + "Enemigos abatidos"
        }

        
        
        
        if contadorImpactos == 0{
                
            var explotarSubmarino = SKAction.runBlock({() in self.destruirSubmarino()})
            var retardo = SKAction.waitForDuration(3)
            var controlEscena = SKAction.speedBy(0, duration: 1)
            var controlSubmarino = SKAction.sequence([retardo,  controlEscena])
            runAction(controlSubmarino)
            submarino.runAction(explotarSubmarino)
            
            gameOver()
            volverMenu()
        }
        
        
        
    }
    
    func destruirBarco(){
        
        var atlasExplosionEnemigo = SKTextureAtlas(named: "enemigoExplota")
        
        var b1 = atlasExplosionEnemigo.textureNamed("enemigoExplota1")
        var b2 = atlasExplosionEnemigo.textureNamed("enemigoExplota2")
        var b3 = atlasExplosionEnemigo.textureNamed("enemigoExplota3")
        var b4 = atlasExplosionEnemigo.textureNamed("enemigoExplota4")
        
        var arrayEnemigo = [b1,b2,b3,b4,b3,b4]
        
        var enemigoExplota = SKAction.animateWithTextures(arrayEnemigo, timePerFrame: 0.2)
        enemigoExplota = SKAction.repeatAction(enemigoExplota, count: 1)
        enemigo.runAction(enemigoExplota)
        
    }
    

    func destruirSubmarinoDamage(){
        
        
        let explosionSubmarino = SKEmitterNode(fileNamed: "humoExplosion.sks")
        explosionSubmarino.zPosition = 4
        explosionSubmarino.setScale(0.4)
        explosionSubmarino.position = CGPointMake(-40, 0)
        submarino.addChild(explosionSubmarino)
        
    
        // Cambiando el color del Submarino cuando colisiona 
        
        submarino.runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 0.3, duration: 0.4),
                SKAction.waitForDuration(0.4),
                SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 0, duration: 0.4),
                ])
            ))
        
//        var atlasExplosionSubmarino = SKTextureAtlas(named: "submarinoExplota")
//        
//        var s1 = atlasExplosionSubmarino.textureNamed("UBoatDamage1")
//        var s2 = atlasExplosionSubmarino.textureNamed("UBoatDamage2")
//        var s3 = atlasExplosionSubmarino.textureNamed("UBoatDamage3")
//        var s4 = atlasExplosionSubmarino.textureNamed("UBoatDamage4")
//        var s5 = atlasExplosionSubmarino.textureNamed("UBoat")
//        
//        
//        var arraySubmarino = [s1,s2,s3,s4,s3,s4,s5]
//        
//        var submarinoExplota = SKAction.animateWithTextures(arraySubmarino, timePerFrame: 0.2)
//        submarinoExplota = SKAction.repeatAction(submarinoExplota, count: 1)
//        submarino.runAction(submarinoExplota)
        
    }
    
    
    func destruirSubmarino(){
        
        let explosionSubmarino = SKEmitterNode(fileNamed: "humoExplosion.sks")
        explosionSubmarino.zPosition = 4
        explosionSubmarino.setScale(0.9)
        explosionSubmarino.position = CGPointMake(-50, -10)
        submarino.addChild(explosionSubmarino)
        
        
        
        // var atlasExplosionSubmarino = SKTextureAtlas(named: "submarinoExplota")
        
        // var s1 = atlasExplosionSubmarino.textureNamed("UBoatDamage1")
        // var s2 = atlasExplosionSubmarino.textureNamed("UBoatDamage2")
        // var s3 = atlasExplosionSubmarino.textureNamed("UBoatDamage3")
        // var s4 = atlasExplosionSubmarino.textureNamed("UBoatDamage4")
        // var s5 = atlasExplosionSubmarino.textureNamed("UBoatTotalDamage")
        
        // var arraySubmarino = [s1,s2,s3,s4,s5,s3]
        
        // var submarinoExplota = SKAction.animateWithTextures(arraySubmarino, timePerFrame: 0.5)
        // submarinoExplota = SKAction.repeatAction(submarinoExplota, count: 1)
        // submarino.runAction(submarinoExplota)
        
        
        submarino.physicsBody?.dynamic = false
        var desplazarSubmarino = SKAction.moveTo(CGPointMake( self.frame.width / 2, self.frame.height / 2), duration:2.0)
        submarino.runAction(desplazarSubmarino)
        }
    
    }




