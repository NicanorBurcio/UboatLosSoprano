//
//  Juego.swift
//  UBoat LEX
//
//  Created by Berganza on 16/12/2014.
//  Copyright (c) 2014 Berganza. All rights reserved.
//

import SpriteKit
import UIKit
import AVFoundation

class Juego: SKScene, SKPhysicsContactDelegate, AnalogStickProtocol {
    
    //Movimiento del Joistick
    let moveAnalogStick: AnalogStick = AnalogStick()
    
    //Para evitar la rotación en la colisión de elementos
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
    
    //CATEGORIAS
    
    let categoriaSubmarino : UInt32 = 1<<0
    let categoriaEnemigo : UInt32 = 1<<1
    let categoriaMisil : UInt32 = 1<<2
    let categoriaDisparo : UInt32 = 1<<3
    let categoriaMina : UInt32 = 1<<4
    
    
    
    var escena = SKNode()
    
    
    override func didMoveToView(view: SKView) {
        
        self.addChild(escena)
        
        // propiedades físicas
        
        self.physicsWorld.gravity = CGVectorMake(0.0, 0.0)
        self.physicsWorld.contactDelegate  = self
        backgroundColor = UIColor.cyanColor()
       
        //Joistick
        let bgDiametr: CGFloat = 150
        let thumbDiametr: CGFloat = 75
        let joysticksRadius = bgDiametr / 2
        moveAnalogStick.bgNodeDiametr = bgDiametr
        moveAnalogStick.thumbNodeDiametr = thumbDiametr
        moveAnalogStick.position = CGPointMake(joysticksRadius - 34, joysticksRadius - 20)
        moveAnalogStick.zPosition = 100
        moveAnalogStick.alpha = 1
        moveAnalogStick.delagate = self
        self.addChild(moveAnalogStick)
        
        //OBJETOS
        
        heroe()
        prismaticos()
        crearCielo()
        crearOceano ()
        mostrarColisiones()
        mostrarPuntuacion()
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
        sonidoOceano.volume = 0.2
    }
    
    func reproducirEfectoAudioExplosionImpacto(){
        let ubicacionAudioExplosionImpacto = NSBundle.mainBundle().pathForResource("explosionImpacto", ofType: "wav")
        var efectoExplosionImpacto = NSURL(fileURLWithPath: ubicacionAudioExplosionImpacto!)
        sonidoExploxionImpacto = AVAudioPlayer(contentsOfURL: efectoExplosionImpacto, error: nil)
        sonidoExploxionImpacto.prepareToPlay()
        sonidoExploxionImpacto.play()
        sonidoExploxionImpacto.volume = 0.7
    }
    
    
    func reproducirEfectoAudioSalidaTorpedo(){
        let ubicacionAudioSalidaTorpedo = NSBundle.mainBundle().pathForResource("salidaTorpedo", ofType: "wav")
        var efectoSalidaTorpedo = NSURL(fileURLWithPath: ubicacionAudioSalidaTorpedo!)
        sonidoSalidaTorpedo = AVAudioPlayer(contentsOfURL: efectoSalidaTorpedo, error: nil)
        sonidoSalidaTorpedo.prepareToPlay()
        sonidoSalidaTorpedo.play()
        sonidoSalidaTorpedo.volume = 1
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
        
        //SubmarinoEmergiendo
        
        var texturaSubmarinoEmergeA = SKTexture(imageNamed: "Emerge-0002")
        texturaSubmarinoEmergeA.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoEmerge0 = SKTexture(imageNamed: "Emerge-0001")
        texturaSubmarinoEmerge0.filteringMode = SKTextureFilteringMode.Nearest
        
        var texturaSubmarinoEmerge1 = SKTexture(imageNamed: "Emerge0000")
        texturaSubmarinoEmerge1.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoEmerge2 = SKTexture(imageNamed: "Emerge0001")
        texturaSubmarinoEmerge2.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoEmerge3 = SKTexture(imageNamed: "Emerge0002")
        texturaSubmarinoEmerge3.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoEmerge4 = SKTexture(imageNamed: "Emerge0003")
        texturaSubmarinoEmerge4.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoEmerge5 = SKTexture(imageNamed: "Emerge0004")
        texturaSubmarinoEmerge5.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoEmerge6 = SKTexture(imageNamed: "Emerge0005")
        texturaSubmarinoEmerge6.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoEmerge7 = SKTexture(imageNamed: "Emerge0006")
        texturaSubmarinoEmerge7.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoEmerge8 = SKTexture(imageNamed: "Emerge0007")
        texturaSubmarinoEmerge8.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoEmerge9 = SKTexture(imageNamed: "Emerge0008")
        texturaSubmarinoEmerge9.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoEmerge10 = SKTexture(imageNamed: "Emerge0009")
        texturaSubmarinoEmerge10.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoEmerge11 = SKTexture(imageNamed: "Emerge0010")
        texturaSubmarinoEmerge11.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoEmerge12 = SKTexture(imageNamed: "Emerge0011")
        texturaSubmarinoEmerge12.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoEmerge13 = SKTexture(imageNamed: "Emerge0012")
        texturaSubmarinoEmerge13.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoEmerge14 = SKTexture(imageNamed: "Emerge0013")
        texturaSubmarinoEmerge14.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoEmerge15 = SKTexture(imageNamed: "Emerge0014")
        texturaSubmarinoEmerge15.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoEmerge16 = SKTexture(imageNamed: "Emerge0015")
        texturaSubmarinoEmerge16.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoEmerge17 = SKTexture(imageNamed: "Emerge0016")
        texturaSubmarinoEmerge17.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoEmerge18 = SKTexture(imageNamed: "Emerge0017")
        texturaSubmarinoEmerge18.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoEmerge19 = SKTexture(imageNamed: "Emerge0018")
        texturaSubmarinoEmerge19.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoEmerge20 = SKTexture(imageNamed: "Emerge0019")
        texturaSubmarinoEmerge20.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoEmerge21 = SKTexture(imageNamed: "Emerge0020")
        texturaSubmarinoEmerge21.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoEmerge22 = SKTexture(imageNamed: "Emerge0021")
        texturaSubmarinoEmerge22.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoEmerge23 = SKTexture(imageNamed: "Emerge0022")
        texturaSubmarinoEmerge23.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoEmerge24 = SKTexture(imageNamed: "Emerge0023")
        texturaSubmarinoEmerge24.filteringMode = SKTextureFilteringMode.Nearest
        
        var animacionSubmarinoEmerge = SKAction.animateWithTextures([texturaSubmarinoEmergeA, texturaSubmarinoEmergeA, texturaSubmarinoEmerge0, texturaSubmarinoEmerge0, texturaSubmarinoEmerge0, texturaSubmarinoEmerge1, texturaSubmarinoEmerge2, texturaSubmarinoEmerge3, texturaSubmarinoEmerge4, texturaSubmarinoEmerge5, texturaSubmarinoEmerge6, texturaSubmarinoEmerge7, texturaSubmarinoEmerge8, texturaSubmarinoEmerge9, texturaSubmarinoEmerge10, texturaSubmarinoEmerge11, texturaSubmarinoEmerge12, texturaSubmarinoEmerge13, texturaSubmarinoEmerge14, texturaSubmarinoEmerge15, texturaSubmarinoEmerge16, texturaSubmarinoEmerge17, texturaSubmarinoEmerge18, texturaSubmarinoEmerge19, texturaSubmarinoEmerge20, texturaSubmarinoEmerge21, texturaSubmarinoEmerge22, texturaSubmarinoEmerge23, texturaSubmarinoEmerge24], timePerFrame: 0.14)
        var accionSubmarinoEmerge = SKAction.repeatAction(animacionSubmarinoEmerge, count: 1)
        
        //SubmarinoNavegando
        
        var texturaSubmarinoNavegando1 = SKTexture(imageNamed: "Navegando0024")
        texturaSubmarinoEmerge1.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoNavegando2 = SKTexture(imageNamed: "Navegando0025")
        texturaSubmarinoEmerge2.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoNavegando3 = SKTexture(imageNamed: "Navegando0026")
        texturaSubmarinoEmerge3.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoNavegando4 = SKTexture(imageNamed: "Navegando0027")
        texturaSubmarinoEmerge4.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoNavegando5 = SKTexture(imageNamed: "Navegando0028")
        texturaSubmarinoEmerge5.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoNavegando6 = SKTexture(imageNamed: "Navegando0029")
        texturaSubmarinoEmerge6.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoNavegando7 = SKTexture(imageNamed: "Navegando0030")
        texturaSubmarinoEmerge7.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoNavegando8 = SKTexture(imageNamed: "Navegando0031")
        texturaSubmarinoEmerge8.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoNavegando9 = SKTexture(imageNamed: "Navegando0032")
        texturaSubmarinoEmerge9.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoNavegando10 = SKTexture(imageNamed: "Navegando0033")
        texturaSubmarinoEmerge10.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoNavegando11 = SKTexture(imageNamed: "Navegando0034")
        texturaSubmarinoEmerge11.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoNavegando12 = SKTexture(imageNamed: "Navegando0035")
        texturaSubmarinoEmerge12.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoNavegando13 = SKTexture(imageNamed: "Navegando0036")
        texturaSubmarinoEmerge13.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoNavegando14 = SKTexture(imageNamed: "Navegando0037")
        texturaSubmarinoEmerge14.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoNavegando15 = SKTexture(imageNamed: "Navegando0038")
        texturaSubmarinoEmerge15.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoNavegando16 = SKTexture(imageNamed: "Navegando0039")
        texturaSubmarinoEmerge16.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoNavegando17 = SKTexture(imageNamed: "Navegando0040")
        texturaSubmarinoEmerge17.filteringMode = SKTextureFilteringMode.Nearest
        
        var animacionSubmarinoNavega = SKAction.animateWithTextures([texturaSubmarinoNavegando1, texturaSubmarinoNavegando2, texturaSubmarinoNavegando3, texturaSubmarinoNavegando4, texturaSubmarinoNavegando5, texturaSubmarinoNavegando6, texturaSubmarinoNavegando7, texturaSubmarinoNavegando8, texturaSubmarinoNavegando9, texturaSubmarinoNavegando10, texturaSubmarinoNavegando11, texturaSubmarinoNavegando12, texturaSubmarinoNavegando13, texturaSubmarinoNavegando14, texturaSubmarinoNavegando15, texturaSubmarinoNavegando16, texturaSubmarinoNavegando17], timePerFrame: 0.09)
        var accionSubmarinoNavega = SKAction.repeatActionForever(animacionSubmarinoNavega)
        
        
        submarino = SKSpriteNode(texture: texturaSubmarinoEmerge1)
        submarino.setScale(0.7)
        submarino.zPosition = 4
        submarino.position = CGPointMake((submarino.size.width - 80), self.frame.height / 2)
        submarino.constraints = [constraint]
        submarino.name = "heroe"
        
        //Emitters estela Submarino
        
//        let estelaSubmarino1 = SKEmitterNode(fileNamed: "estelaSubDer.sks")
//        estelaSubmarino1.zPosition = 0
//        estelaSubmarino1.alpha = 1
//        estelaSubmarino1.setScale(0.24)
//        estelaSubmarino1.position = CGPointMake(23, -21)
//        submarino.addChild(estelaSubmarino1)
//        
//        let estelaSubmarino2 = SKEmitterNode(fileNamed: "estelaSubIzq.sks")
//        estelaSubmarino2.zPosition = -1
//        estelaSubmarino2.alpha = 1
//        estelaSubmarino2.setScale(0.22)
//        estelaSubmarino2.position = CGPointMake(23, -7)
//        submarino.addChild(estelaSubmarino2)
        
        
        //Agrupación de acciones submarino emergiendo y navegando
        
        var controlSubmarinoEmergiendoNavegando = SKAction.sequence([accionSubmarinoEmerge, accionSubmarinoNavega])
        submarino.runAction(controlSubmarinoEmergiendoNavegando)
        
        
        //submarino.runAction(submarinoNavega)
        
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
        disparo.setScale(0.4)
        disparo.zPosition = 3
        disparo.position = CGPointMake(submarino.position.x + 54, submarino.position.y + 16)
        disparo.alpha = 1
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
        reproducirEfectoAudioExplosionImpacto()
    }
    
    
    func prismaticos() {
        
        prisma = SKSpriteNode(imageNamed: "prismatic")
        prisma.setScale(1)
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

    
    override func update(currentTime: CFTimeInterval) {
        scrollCielo()
        scrollMar()    }
    
    
    
    // MARK: AnalogStickProtocol
    func moveAnalogStick(analogStick: AnalogStick, velocity: CGPoint, angularVelocity: Float) {
        if contadorImpactos > 0 {
            
            if analogStick.isEqual(moveAnalogStick) {
                submarino.position = CGPointMake(submarino.position.x, submarino.position.y + (velocity.y * 0.12))
            }
            
            if submarino.position.y >= self.frame.height - 75 {
                submarino.position.y = self.frame.height - 75
            }
            
            if submarino.position.y <= 0 + 40 {
                submarino.position.y = 0 + 40
            }
            
        }
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
        reproducirEfectoAudioExplosionImpacto()
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
        reproducirEfectoAudioExplosionImpacto()
        
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
    explosionSubmarino.zPosition = 0
    explosionSubmarino.setScale(0.4)
    explosionSubmarino.position = CGPointMake(-40, 10)
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
    //submarino.addChild(explosionSubmarino)
    
    submarino.physicsBody?.dynamic = false
    var desplazarSubmarino = SKAction.moveTo(CGPointMake( self.frame.width / 2, self.frame.height / 2), duration:2.0)
    submarino.runAction(desplazarSubmarino)
}

}





