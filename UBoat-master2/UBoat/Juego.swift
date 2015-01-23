//
//  Juego.swift
//  UBoat LEX
//
//  Created by Berganza on 16/12/2014.
//  Copyright (c) 2014 Berganza. All rights reserved.
//


import UIKit
import SpriteKit
import AVFoundation




class Juego: SKScene, SKPhysicsContactDelegate {
    
    let constraint = SKConstraint.zRotation(SKRange(constantValue: 0))
    var fondo = SKSpriteNode()
    var fdcielo = SKSpriteNode()
    
    
    //AUDIO
    
    var sonidoSalidaTorpedo  = AVAudioPlayer()
    var sonidoExploxionImpacto = AVAudioPlayer()
    var sonidoOceano = AVAudioPlayer()
    
    //OBJETOS
    var contadorImpactos = NSInteger()
    var contadorImpactosLabel = SKLabelNode()
    var puntuacion = NSInteger()
    var contadorPuntuacionLabel = SKLabelNode()
    
    var submarino = SKSpriteNode()
    let submarinoAtlas = SKTextureAtlas(named: "SubNavegando.atlas")
    
    var prisma = SKSpriteNode()
    var enemigo = SKSpriteNode()
    var misil = SKSpriteNode()
    var disparo = SKSpriteNode()
    var menuLabel = SKLabelNode()
    var botonMoverArriba = SKSpriteNode()
    var botonMoverAbajo = SKSpriteNode()
    var botonDisparoMisil = SKSpriteNode()
    var botonDisparoAmetralladora = SKSpriteNode()
    var mina = SKSpriteNode()
    
    //MOVIMIENTOS
    
    var moverArriba = SKAction()
    var moverAbajo = SKAction()
    var contadorEscala: CGFloat = 0.5
    
    
    
    let velocidadMar: CGFloat = 2
    let velocidadCielo: CGFloat = 1
    
    
    
    var velocidadJuego = 9.0
    
    
    //CATEGORIAS
    
    let categoriaSubmarino : UInt32 = 1<<0
    let categoriaEnemigo : UInt32 = 1<<1
    let categoriaMisil : UInt32 = 1<<2
    let categoriaDisparo : UInt32 = 1<<3
    let categoriaMina : UInt32 = 1<<4
    
    
    
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
        motrarBotonMoverArriba()
        motrarBotonMoverAbajo()
        motrarBotonDisparoMisil()
        motrarBotonDisparoAmetralladoral()
        reproducirEfectoAudioOceano()
        
        
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([SKAction.runBlock(aparecerEnemigo),
                SKAction.waitForDuration(12)])))
        
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([SKAction.runBlock(aparecerMina),
                SKAction.waitForDuration(35)])))
        
        
    }
    func reproducirEfectoAudioOceano(){
        let ubicacionAudioOceano = NSBundle.mainBundle().pathForResource("oceano", ofType: "mp3")
        var efectoOceano = NSURL(fileURLWithPath: ubicacionAudioOceano!)
        sonidoOceano = AVAudioPlayer(contentsOfURL: efectoOceano, error: nil)
        sonidoOceano.prepareToPlay()
        sonidoOceano.play()
        sonidoOceano.volume = 0.1
    }
   
    func reproducirEfectoAudioExplosionImpacto(){
        let ubicacionAudioExplosionImpacto = NSBundle.mainBundle().pathForResource("explosionImpacto", ofType: "wav")
        var efectoExplosionImpacto = NSURL(fileURLWithPath: ubicacionAudioExplosionImpacto!)
        sonidoExploxionImpacto = AVAudioPlayer(contentsOfURL: efectoExplosionImpacto, error: nil)
        sonidoExploxionImpacto.prepareToPlay()
        sonidoExploxionImpacto.play()
        sonidoExploxionImpacto.volume = 3
    }

    
    func reproducirEfectoAudioSalidaTorpedo(){
        let ubicacionAudioSalidaTorpedo = NSBundle.mainBundle().pathForResource("salidaTorpedo", ofType: "wav")
        var efectoSalidaTorpedo = NSURL(fileURLWithPath: ubicacionAudioSalidaTorpedo!)
        sonidoSalidaTorpedo = AVAudioPlayer(contentsOfURL: efectoSalidaTorpedo, error: nil)
        sonidoSalidaTorpedo.prepareToPlay()
        sonidoSalidaTorpedo.play()
        sonidoSalidaTorpedo.volume = 0.1
    }
    
    func motrarBotonMoverArriba() {
    
        botonMoverArriba = SKSpriteNode(imageNamed: "arriba")
        botonMoverArriba.setScale(0.1)
        botonMoverArriba.zPosition = 7
        botonMoverArriba.position = CGPointMake(self.frame.width / 28, self.frame.height / 7)
        botonMoverArriba.name = "arriba"
        escena.addChild(botonMoverArriba)

    
    }
    
    func motrarBotonMoverAbajo() {
        
        botonMoverAbajo = SKSpriteNode(imageNamed: "abajo")
        botonMoverAbajo.setScale(0.1)
        botonMoverAbajo.zPosition = 7
        botonMoverAbajo.position = CGPointMake(self.frame.width / 28, self.frame.height / 15)
        botonMoverAbajo.name = "abajo"
        escena.addChild(botonMoverAbajo)
        
        
    }

    func motrarBotonDisparoMisil() {
        
        botonDisparoMisil = SKSpriteNode(imageNamed: "botonMisil")
        botonDisparoMisil.setScale(0.1)
        botonDisparoMisil.zPosition = 6
        botonDisparoMisil.position = CGPointMake(self.frame.width / 1.03, self.frame.height / 6)
        botonDisparoMisil.name = "botonDisparoMisil"
        escena.addChild(botonDisparoMisil)
        
        
    }
    
    func motrarBotonDisparoAmetralladoral() {
        
        botonDisparoAmetralladora = SKSpriteNode(imageNamed: "botonAmetralladora")
        botonDisparoAmetralladora.setScale(0.1)
        botonDisparoAmetralladora.zPosition = 6
        botonDisparoAmetralladora.position = CGPointMake(self.frame.width / 1.03, self.frame.height / 15)
        botonDisparoAmetralladora.name = "botonDisparoMisil"
        escena.addChild(botonDisparoAmetralladora)
        
        
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
    
    
    func mostrarPuntuacion(){
        puntuacion = 0
        contadorPuntuacionLabel.fontName = "Avenir"
        contadorPuntuacionLabel.fontSize  = 20
        contadorPuntuacionLabel.fontColor = UIColor.greenColor()
        contadorPuntuacionLabel.alpha = 1
        contadorPuntuacionLabel.zPosition = 6
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
        contadorImpactosLabel.zPosition = 6
        contadorImpactosLabel.position = CGPointMake(self.frame.width - 120, self.frame.height - 25)
        contadorImpactosLabel.text = "Impactos restantes: " + "\(contadorImpactos)"
        escena.addChild(contadorImpactosLabel)
    }
    
    func heroe(){
        
        submarino = SKSpriteNode(texture: submarinoAtlas.textureNamed("Navegando0024"))
        submarino.setScale(1)
        submarino.zPosition = 4
        submarino.position = CGPointMake((submarino.size.width - 100), self.frame.height / 2)
        submarino.constraints = [constraint]
        submarino.name = "heroe"
        
        
        
        let estelaSubmarino1 = SKEmitterNode(fileNamed: "estelaSubDer.sks")
        estelaSubmarino1.zPosition = 0
        estelaSubmarino1.alpha = 1
        estelaSubmarino1.setScale(0.24)
        estelaSubmarino1.position = CGPointMake(23, -16)
        submarino.addChild(estelaSubmarino1)
        
        let estelaSubmarino2 = SKEmitterNode(fileNamed: "estelaSubIzq.sks")
        estelaSubmarino2.zPosition = -1
        estelaSubmarino2.alpha = 1
        estelaSubmarino2.setScale(0.22)
        estelaSubmarino2.position = CGPointMake(23, -7)
        submarino.addChild(estelaSubmarino2)
        
        /* he pensado que en lugar de una función a parte, es mejor incluir el efecto de navegar en el mismo submarino para cuando saquemos este código  al bundle*/
        var u1 = submarinoAtlas.textureNamed("Navegando0024")
        var u2 = submarinoAtlas.textureNamed("Navegando0025")
        var u3 = submarinoAtlas.textureNamed("Navegando0026")
        var u4 = submarinoAtlas.textureNamed("Navegando0027")
        var u5 = submarinoAtlas.textureNamed("Navegando0028")
        var u6 = submarinoAtlas.textureNamed("Navegando0029")
        var u7 = submarinoAtlas.textureNamed("Navegando0030")
        var u8 = submarinoAtlas.textureNamed("Navegando0031")
        var u9 = submarinoAtlas.textureNamed("Navegando0032")
        var u10 = submarinoAtlas.textureNamed("Navegando0033")
        var u11 = submarinoAtlas.textureNamed("Navegando0034")
        var u12 = submarinoAtlas.textureNamed("Navegando0035")
        var u13 = submarinoAtlas.textureNamed("Navegando0036")
        var u14 = submarinoAtlas.textureNamed("Navegando0037")
        var u15 = submarinoAtlas.textureNamed("Navegando0038")
        var u16 = submarinoAtlas.textureNamed("Navegando0039")
        var u17 = submarinoAtlas.textureNamed("Navegando0040")
        
        
        // Combinación de arrays del Atlas por Adrían
        let arraySubmarino = [u1,u2,u3,u4,u5,u6,u7,u8,u9,u10,u11,u12,u13,u14,u15,u16,u17]
        
        // Combinación de arrays del Atlas por Nicanor
//        let arraySubmarino = [u7,u7,u7,u7,u7,u6,u5,u4,u3,u2,u1,u2,u3,u4,u5,u6,u7]
        
        var submarinoNavega = SKAction.animateWithTextures(arraySubmarino, timePerFrame: 0.08)
        
        submarinoNavega = SKAction.repeatActionForever(submarinoNavega)
        
        submarino.runAction(submarinoNavega)

        
        
        submarino.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(submarino.size.width - 30, 15))
        submarino.physicsBody?.dynamic = true
        submarino.physicsBody?.categoryBitMask = categoriaSubmarino
        submarino.physicsBody?.collisionBitMask = categoriaEnemigo
        submarino.physicsBody?.contactTestBitMask  = categoriaEnemigo
        submarino.physicsBody?.categoryBitMask = categoriaSubmarino
        submarino.physicsBody?.collisionBitMask = categoriaMina
        submarino.physicsBody?.contactTestBitMask  = categoriaMina

        escena.addChild(submarino)
        
        //submarinoNavega()
        
        moverArriba = SKAction.moveByX(0, y: 10, duration: 0.1)
        moverAbajo = SKAction.moveByX(0, y: -10, duration: 0.1)

        }
   
   
    
    func aparecerEnemigo(){
        var altura = UInt (self.frame.size.height - 100 )
        var alturaRandom = UInt (arc4random()) % altura
        
        enemigo = SKSpriteNode(imageNamed: "enemigo")
        enemigo.setScale(0.3)
        enemigo.position = CGPointMake(self.frame.size.width - enemigo.size.width + enemigo.size.width * 2, CGFloat(25 + alturaRandom))
        //enemigo.zPosition = CGFloat()
        if submarino.position.y > enemigo.position.y {
            enemigo.zPosition = submarino.zPosition + 1
        }
        else if submarino.position.y < enemigo.position.y {
            enemigo.zPosition = submarino.zPosition - 1
        }

        enemigo.name = "enemigo"
        
        let estelaEnemigo = SKEmitterNode(fileNamed: "estelaEnemigo.sks")
        estelaEnemigo.zPosition = 0
        estelaEnemigo.setScale(0.5)
        estelaEnemigo.position = CGPointMake(20, -45)
        enemigo.addChild(estelaEnemigo)
        
        enemigo.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(enemigo.size.width - 30, 30))
        enemigo.physicsBody?.dynamic = true
        enemigo.physicsBody?.categoryBitMask = categoriaEnemigo
        enemigo.physicsBody?.collisionBitMask = categoriaSubmarino
        enemigo.physicsBody?.contactTestBitMask  = categoriaSubmarino
        escena.addChild(enemigo)
        
        
        var alturaEnemigo = UInt (self.frame.size.height - 100 )
        var alturaEnemigoRandom = UInt (arc4random()) % altura
        var desplazarEnemigo = SKAction.moveTo(CGPointMake( -enemigo.size.width * 2 , CGFloat(enemigo.position.y)), duration: 15)
       enemigo.runAction(desplazarEnemigo)
        }
    
    
    func aparecerMina(){
        var altura = UInt (self.frame.size.height - 100 )
        var alturaRandom = UInt (arc4random()) % altura
        
        mina = SKSpriteNode(imageNamed: "Mina")
        mina.setScale(0.11)
        mina.position = CGPointMake(self.frame.size.width - mina.size.width + mina.size.width * 2, CGFloat(25 + alturaRandom))
            if mina.position.y > submarino.position.y {
                mina.zPosition = submarino.zPosition - 1
            }
            else if mina.position.y < submarino.position.y {
                mina.zPosition = submarino.zPosition + 1
            }
        mina.constraints = [constraint]
        mina.name = "mina"
        
        mina.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(enemigo.size.width - 30, 30))
        mina.physicsBody?.dynamic = true
        mina.physicsBody?.categoryBitMask = categoriaMina
        mina.physicsBody?.collisionBitMask = categoriaSubmarino
        mina.physicsBody?.contactTestBitMask  = categoriaSubmarino
        escena.addChild(mina)
        
        
        var alturaMina = UInt (self.frame.size.height - 100 )
        var alturaMinaRandom = UInt (arc4random()) % altura
        var desplazarMina = SKAction.moveTo(CGPointMake( -mina.size.width * 2 , CGFloat(mina.position.y)), duration: 40)
        mina.runAction(desplazarMina)
    }

    
    
    
    func lanzarMisil(){
        misil = SKSpriteNode(imageNamed: "misil")
        misil.setScale(0.45)
        misil.zPosition = 3
        misil.position = CGPointMake(submarino.position.x + 20 , submarino.position.y - 5)
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

        var lanzarMisil = SKAction.moveTo(CGPointMake( self.frame.size.width + misil.size.width * 2 , submarino.position.y - 30), duration:2.0)
        misil.runAction(lanzarMisil)
            }
    
    func disparar(){
        disparo = SKSpriteNode(imageNamed: "Disparo")
        disparo.setScale(0.3)
        disparo.zPosition = 3
        disparo.position = CGPointMake(submarino.position.x + 150, submarino.position.y + 10)
        disparo.alpha = 0.8
        disparo.constraints = [constraint]
        disparo.name = "disparo"
        
        
        disparo.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(disparo.size.width, disparo.size.height))
        disparo.physicsBody?.dynamic = true
        disparo.physicsBody?.categoryBitMask = categoriaDisparo
        disparo.physicsBody?.collisionBitMask = categoriaEnemigo
        disparo.physicsBody?.contactTestBitMask  = categoriaEnemigo
        escena.addChild(disparo)
        
        var lanzarDisparo = SKAction.moveTo(CGPointMake( self.frame.width + disparo.size.width * 2, submarino.position.y + 7), duration:1.0)
        disparo.runAction(lanzarDisparo)
    }


    func prismaticos() {
        
        prisma = SKSpriteNode(imageNamed: "prismatic")
        prisma.setScale(0.66)
        prisma.zPosition = 5
        prisma.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        
        addChild(prisma)
        
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
        
        
        
        let tocarBotonLanzarMisil: AnyObject = touches.anyObject()!
        
        let posicionTocarBotonLanzarMisil = tocarBotonLanzarMisil.locationInNode(self)
        
        let loQueTocamosBotonLanzarMisil = self.nodeAtPoint(posicionTocarBotonLanzarMisil)
        
        if loQueTocamosBotonLanzarMisil == botonDisparoMisil {
            
           lanzarMisil()
           reproducirEfectoAudioSalidaTorpedo()
                    }
        
        let tocarBotonDisparar: AnyObject = touches.anyObject()!
        
        let posicionTocarBotonDisparar = tocarBotonDisparar.locationInNode(self)
        
        let loQueTocamosBotonDisparar = self.nodeAtPoint(posicionTocarBotonDisparar)
        
        if loQueTocamosBotonDisparar == botonDisparoAmetralladora {
            
                     disparar()

         }
        
        
        let tocarBotonArriba: AnyObject = touches.anyObject()!
        
        let posicionTocarBotonArriba = tocarBotonArriba.locationInNode(self)
        
        let loQueTocamosBotonArriba = self.nodeAtPoint(posicionTocarBotonArriba)
        
        if loQueTocamosBotonArriba == botonMoverArriba && submarino.position.y < 290  {
            
//            contadorEscala = contadorEscala - 0.01
//                if contadorEscala < 0.4 {
//                    contadorEscala = 0.4
//                }
//            
//            submarino.setScale(contadorEscala)
            submarino.runAction(moverArriba)
            
        }
        
        
        let tocarBotonAbajo: AnyObject = touches.anyObject()!
        
        let posicionTocarBotonAbajo = tocarBotonAbajo.locationInNode(self)
        
        let loQueTocamosBotonAbajo = self.nodeAtPoint(posicionTocarBotonAbajo)
        
        if loQueTocamosBotonAbajo == botonMoverAbajo && submarino.position.y > 65  {
            
//            contadorEscala = contadorEscala + 0.03
//                if contadorEscala > 0.9 {
//                contadorEscala = 0.9
//                }
//            
//            submarino.setScale(contadorEscala)
            submarino.runAction(moverAbajo)
                    }


       
        
 // Antiguo mover submarino arriba y abajo por toques en la pantalla
        
//        if escena.speed > 0 {
//            
//        for toke: AnyObject in touches {
//        
//        let dondeTocamos = toke.locationInNode(self)
//        
//        if dondeTocamos.y > submarino.position.y {
//            
//            if submarino.position.y < 290  {
//                //submarino.position.x = (submarino.size.width / 2)+10
//                contadorEscala = contadorEscala - 0.01
//                if contadorEscala < 0.4 {
//                    contadorEscala = 0.4
//                }
//                submarino.setScale(contadorEscala)
//                submarino.runAction(moverArriba)
//
//            }
//            
//            
//        } else {
//            
//            if submarino.position.y > 65 {
//                //submarino.position.x = (submarino.size.width / 2)+10
//                contadorEscala = contadorEscala + 0.03
//                if contadorEscala > 0.9 {
//                    contadorEscala = 0.9
//                }
//                submarino.setScale(contadorEscala)
//                submarino.runAction(moverAbajo)
//            }
//       }
//        
//}
//}

       
      }

    
    
    func crearCielo() {
        
        for var indice = 0; indice < 2; ++indice {
            
            let fdcielo = SKSpriteNode(imageNamed: "Cielo")
            fdcielo.position = CGPoint(x: (indice * Int(fdcielo.size.width)) + Int(fdcielo.size.width)/2, y: Int(fdcielo.size.height)/2)
            fdcielo.name = "fdcielo"
            fdcielo.zPosition = 1
            
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
            fondo.zPosition = 2
            
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
            submarino.physicsBody?.dynamic = false
            
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
        
        if (contact.bodyB.categoryBitMask & categoriaMisil) == categoriaMisil && enemigo.physicsBody?.dynamic == true && enemigo.position.x < self.frame.width  {
            
            enemigo.physicsBody?.dynamic = false
            
            misil.removeFromParent()
            var explotarEnemigo = SKAction.runBlock({() in self.destruirBarco()})
            var retardo = SKAction.waitForDuration(0.5)
            var enemigoDesaparece = SKAction.removeFromParent()
            var controlEnemigo = SKAction.sequence([explotarEnemigo, retardo, enemigoDesaparece])
            enemigo.runAction(controlEnemigo)
            reproducirEfectoAudioExplosionImpacto()
            
            puntuacion++
            contadorPuntuacionLabel.text = "\(puntuacion): " + "Enemigos abatidos"
        }

        if (contact.bodyB.categoryBitMask & categoriaDisparo) == categoriaDisparo && enemigo.physicsBody?.dynamic == true && enemigo.position.x < self.frame.width - enemigo.size.width {
            
            enemigo.physicsBody?.dynamic = false
            
            disparo.removeFromParent()
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
            sonidoOceano.stop()
            
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
    }
    
    
    func destruirSubmarino(){
        
        let explosionSubmarino = SKEmitterNode(fileNamed: "humoExplosion.sks")
        explosionSubmarino.zPosition = 4
        explosionSubmarino.setScale(0.9)
        explosionSubmarino.position = CGPointMake(-50, -10)
        submarino.addChild(explosionSubmarino)
   
        submarino.physicsBody?.dynamic = false
        var desplazarSubmarino = SKAction.moveTo(CGPointMake( self.frame.width / 2, self.frame.height / 2), duration:2.0)
        submarino.runAction(desplazarSubmarino)
        }
    
    }




