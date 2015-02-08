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
    
    //Contador de tiempo
    var tiempoDePartida : Int! = 0
    var tiempoDePartidaLabel = SKLabelNode()
    
    var contadorDeParticulas: Int! = 17
    var contadorDeParticulasLabel = SKLabelNode()
    
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
    var contadorImpactosEnEnemigo = 0
    var contadorImpactos = NSInteger()
    var contadorImpactosLabel = SKLabelNode()
    var puntuacion = NSInteger()
    var contadorPuntuacionLabel = SKLabelNode()
    var fondoPapel = SKSpriteNode()
    
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
    
    
    let velocidadMar: CGFloat = 1.0
    
    let velocidadCielo: CGFloat = 0.5
    
    //CATEGORIAS
    
    let categoriaSubmarino : UInt32 = 1<<0
    let categoriaEnemigo : UInt32 = 1<<1
    let categoriaMisil : UInt32 = 1<<2
    let categoriaDisparo : UInt32 = 1<<3
    let categoriaMina : UInt32 = 1<<4
    
    
    
    var escena = SKNode()
    
    
    override func didMoveToView(view: SKView) {
        
        self.addChild(escena)
     
        // Cronómetro

        var aSelector = "tiempo"
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector (aSelector), userInfo: nil, repeats: true)
        
        // propiedades físicas
        
        self.physicsWorld.gravity = CGVectorMake(0.0, 0.0)
        self.physicsWorld.contactDelegate  = self
        backgroundColor = UIColor.cyanColor()
       
        //Joystick
        let bgDiametr: CGFloat = 80
        let thumbDiametr: CGFloat = 40
        let joysticksRadius = bgDiametr
        moveAnalogStick.bgNodeDiametr = bgDiametr
        moveAnalogStick.thumbNodeDiametr = thumbDiametr
        moveAnalogStick.position = CGPointMake(joysticksRadius - 28, joysticksRadius - 22)
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
        mostrarFondoPapel()
        tiempo()
        
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([SKAction.runBlock(aparecerEnemigo),
                SKAction.waitForDuration(12)])))
        
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([SKAction.runBlock(aparecerMina),
                SKAction.waitForDuration(35)])))
        
}
  
    
    func tiempo() {
    
        tiempoDePartida = tiempoDePartida + 1
        tiempoDePartidaLabel.text = "\(tiempoDePartida)"
        tiempoDePartidaLabel.fontName = "Avenir"
        tiempoDePartidaLabel.fontSize  = 25
        tiempoDePartidaLabel.fontColor = UIColor.whiteColor()
        tiempoDePartidaLabel.position = CGPointMake(25, 340)
        tiempoDePartidaLabel.zPosition = 120
        tiempoDePartidaLabel.removeFromParent()
        addChild(tiempoDePartidaLabel)
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
        
        botonDisparoMisil = SKSpriteNode(imageNamed: "botonTorpedo")
        botonDisparoMisil.setScale(1)
        botonDisparoMisil.zPosition = 9
        botonDisparoMisil.position = CGPointMake(self.frame.width / 1.104, self.frame.height / 20)
        botonDisparoMisil.name = "botonDisparoMisil"
        escena.addChild(botonDisparoMisil)
        
        
    }
    
    func motrarBotonDisparoAmetralladoral() {
        
        botonDisparoAmetralladora = SKSpriteNode(imageNamed: "botonAmetralladora")
        botonDisparoAmetralladora.setScale(1)
        botonDisparoAmetralladora.zPosition = 8
        botonDisparoAmetralladora.position = CGPointMake(self.frame.width / 1.046, self.frame.height / 6.49)
        botonDisparoAmetralladora.name = "botonDisparoMisil"
        escena.addChild(botonDisparoAmetralladora)
        
        
    }
    
    func mostrarFondoPapel() {
        
        fondoPapel = SKSpriteNode(imageNamed: "papel")
        fondoPapel.setScale(1)
        fondoPapel.zPosition = 6
        fondoPapel.position = CGPointMake(self.frame.width / 2, self.frame.height / 14)
        
        escena.addChild(fondoPapel)
        
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
        contadorPuntuacionLabel.fontName = "HelveticaNeue-CondensedBlack"
        contadorPuntuacionLabel.fontSize  = 27
        contadorPuntuacionLabel.fontColor = UIColor.redColor()
        contadorPuntuacionLabel.alpha = 0.75
        contadorPuntuacionLabel.zPosition = 7
        contadorPuntuacionLabel.position = CGPointMake(self.frame.width / 2 + 18.5, self.frame.height / 24)
        contadorPuntuacionLabel.text = "0" + "\(puntuacion)"
        escena.addChild(contadorPuntuacionLabel)
    }
    
    
    func mostrarColisiones(){
        contadorImpactos = 5
        contadorImpactosLabel.fontName = "HelveticaNeue-CondensedBlack"
        contadorImpactosLabel.fontSize  = 27
        contadorImpactosLabel.fontColor = UIColor.blackColor()
        contadorImpactosLabel.alpha = 0.75
        contadorImpactosLabel.zPosition = 7
        contadorImpactosLabel.position = CGPointMake(self.frame.width / 2 - 18.5, self.frame.height / 24)

        contadorImpactosLabel.text = "0" + "\(contadorImpactos)"
        escena.addChild(contadorImpactosLabel)
    }
    
    func heroe(){
        
        var objsubmarino = Submarino()
        
        // Creamos el submarino
        submarino = objsubmarino.crearSubmarino()
        
        //Agrupación de acciones submarino emergiendo y navegando
        
        submarino.runAction(objsubmarino.getAtlas())
        
        submarino.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(submarino.size.width - 30, 15))
        submarino.physicsBody?.dynamic = true
        submarino.physicsBody?.categoryBitMask = categoriaSubmarino
        submarino.physicsBody?.collisionBitMask = categoriaEnemigo
        submarino.physicsBody?.contactTestBitMask  = categoriaEnemigo
        submarino.physicsBody?.categoryBitMask = categoriaSubmarino
        submarino.physicsBody?.collisionBitMask = categoriaMina
        submarino.physicsBody?.contactTestBitMask  = categoriaMina
        
        escena.addChild(submarino)
        
    }
    
    
    
    func aparecerEnemigo(){
        var altura = UInt (self.frame.size.height - 100 )
        var alturaRandom = UInt (arc4random()) % altura
        
        enemigo = SKSpriteNode(imageNamed: "enemigo")
        enemigo.setScale(0.4)
        enemigo.position = CGPointMake(self.frame.size.width + enemigo.size.width / 2, CGFloat(25 + alturaRandom))
        //enemigo.zPosition = CGFloat()
        if submarino.position.y > enemigo.position.y {
            enemigo.zPosition = submarino.zPosition + 1
        }
        else if submarino.position.y < enemigo.position.y {
            enemigo.zPosition = submarino.zPosition - 1
        }
        enemigo.constraints = [constraint]
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
        
        mina = SKSpriteNode(imageNamed: "Anima_Mina0024")
        mina.setScale(0.8)
        mina.position = CGPointMake(self.frame.size.width - mina.size.width + mina.size.width * 2, CGFloat(25 + alturaRandom))
        if mina.position.y > submarino.position.y {
            mina.zPosition = submarino.zPosition - 1
        }
        else if mina.position.y < submarino.position.y {
            mina.zPosition = submarino.zPosition + 1
        }
        mina.constraints = [constraint]
        mina.name = "mina"

        
        //Mina Flotando
        
        var texturaMinaFlotando1 = SKTexture(imageNamed: "Anima_Mina0024")
        texturaMinaFlotando1.filteringMode = SKTextureFilteringMode.Nearest
        var texturaMinaFlotando2 = SKTexture(imageNamed: "Anima_Mina0025")
        texturaMinaFlotando2.filteringMode = SKTextureFilteringMode.Nearest
        var texturaMinaFlotando3 = SKTexture(imageNamed: "Anima_Mina0026")
        texturaMinaFlotando3.filteringMode = SKTextureFilteringMode.Nearest
        var texturaMinaFlotando4 = SKTexture(imageNamed: "Anima_Mina0027")
        texturaMinaFlotando4.filteringMode = SKTextureFilteringMode.Nearest
        var texturaMinaFlotando5 = SKTexture(imageNamed: "Anima_Mina0028")
        texturaMinaFlotando5.filteringMode = SKTextureFilteringMode.Nearest
        var texturaMinaFlotando6 = SKTexture(imageNamed: "Anima_Mina0029")
        texturaMinaFlotando6.filteringMode = SKTextureFilteringMode.Nearest
        var texturaMinaFlotando7 = SKTexture(imageNamed: "Anima_Mina0030")
        texturaMinaFlotando7.filteringMode = SKTextureFilteringMode.Nearest
        var texturaMinaFlotando8 = SKTexture(imageNamed: "Anima_Mina0031")
        texturaMinaFlotando8.filteringMode = SKTextureFilteringMode.Nearest
        var texturaMinaFlotando9 = SKTexture(imageNamed: "Anima_Mina0032")
        texturaMinaFlotando9.filteringMode = SKTextureFilteringMode.Nearest
        var texturaMinaFlotando10 = SKTexture(imageNamed: "Anima_Mina0033")
        texturaMinaFlotando10.filteringMode = SKTextureFilteringMode.Nearest
        var texturaMinaFlotando11 = SKTexture(imageNamed: "Anima_Mina0034")
        texturaMinaFlotando11.filteringMode = SKTextureFilteringMode.Nearest
        var texturaMinaFlotando12 = SKTexture(imageNamed: "Anima_Mina0035")
        texturaMinaFlotando12.filteringMode = SKTextureFilteringMode.Nearest
        var texturaMinaFlotando13 = SKTexture(imageNamed: "Anima_Mina0036")
        texturaMinaFlotando13.filteringMode = SKTextureFilteringMode.Nearest
      
        
        var animacionMinaFlotando = SKAction.animateWithTextures([texturaMinaFlotando1, texturaMinaFlotando2, texturaMinaFlotando3, texturaMinaFlotando4, texturaMinaFlotando5, texturaMinaFlotando6, texturaMinaFlotando7, texturaMinaFlotando8, texturaMinaFlotando9, texturaMinaFlotando10, texturaMinaFlotando11, texturaMinaFlotando12, texturaMinaFlotando13], timePerFrame: 0.2)
        var accionMinaFlotando = SKAction.repeatActionForever(animacionMinaFlotando)
        
        mina.runAction(accionMinaFlotando)
        
        //Mina Desplazándose
        
        var alturaMina = UInt (self.frame.size.height - 100 )
        var alturaMinaRandom = UInt (arc4random()) % altura
        var desplazarMina = SKAction.moveTo(CGPointMake( -mina.size.width * 2 , CGFloat(mina.position.y)), duration: 40)
        mina.runAction(desplazarMina)
        
        
        //Propiedades físicas de la mina
        
        
        mina.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(mina.size.width, mina.size.height))
        mina.physicsBody?.dynamic = true
        mina.physicsBody?.categoryBitMask = categoriaMina
        mina.physicsBody?.collisionBitMask = categoriaSubmarino
        mina.physicsBody?.contactTestBitMask  = categoriaSubmarino
        
   
        escena.addChild(mina)
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
        reproducirEfectoAudioSalidaTorpedo()
    }
    
    func disparar(){
        disparo = SKSpriteNode(imageNamed: "Disparo")
        disparo.setScale(0.4)
        disparo.zPosition = 3
        disparo.position = CGPointMake(submarino.position.x + 60, submarino.position.y + 18)
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
        
        prisma = SKSpriteNode(imageNamed: "binocular")
        prisma.size = self.size
        prisma.setScale(1)
        prisma.zPosition = 8
        prisma.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        prisma.constraints      = [constraint]

        escena.addChild(prisma)
        
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
            fdcielo.position = CGPoint(x: (indice * Int(fdcielo.size.width)) + Int(fdcielo.size.width)/2, y: Int(fdcielo.size.height)/2 + 1)
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
    
    if (contact.bodyA.categoryBitMask & categoriaSubmarino) == categoriaSubmarino {

        var aParticles = "particlesCounter"
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector (aParticles), userInfo: nil, repeats: true)
        particlesCounter()
        submarino.physicsBody?.dynamic = false
        
        
//        var explotarEnemigo = SKAction.runBlock({() in self.destruirBarco()})
//        var retardo = SKAction.waitForDuration(0.5)
//        var enemigoDesaparece = SKAction.removeFromParent()
//        var controlEnemigo = SKAction.sequence([explotarEnemigo, retardo, enemigoDesaparece])
//        enemigo.runAction(controlEnemigo)
        
        //var explotarSubmarino = SKAction.runBlock({() in self.destruirSubmarinoDamage()})
        
        //runAction(explotarSubmarino)
        reproducirEfectoAudioExplosionImpacto()
        contadorImpactos--
        contadorImpactosLabel.text = "0" + "\(contadorImpactos)"
        puntuacion++
        contadorPuntuacionLabel.text = "0" + "\(puntuacion)"
        
       
        
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
        contadorPuntuacionLabel.text = "0" + "\(puntuacion)"
    }
    
    if (contact.bodyB.categoryBitMask & categoriaDisparo) == categoriaDisparo && enemigo.physicsBody?.dynamic == true && enemigo.position.x < self.frame.width - enemigo.size.width {
        
        disparo.removeFromParent()
        contadorImpactosEnEnemigo = contadorImpactosEnEnemigo + 1
        if contadorImpactosEnEnemigo == 3 {
        
        enemigo.physicsBody?.dynamic = false
        
        
        var explotarEnemigo = SKAction.runBlock({() in self.destruirBarco()})
        var retardo = SKAction.waitForDuration(0.5)
        var enemigoDesaparece = SKAction.removeFromParent()
        var controlEnemigo = SKAction.sequence([explotarEnemigo, retardo, enemigoDesaparece])
        enemigo.runAction(controlEnemigo)
        reproducirEfectoAudioExplosionImpacto()
        
        contadorImpactosEnEnemigo = 0
        puntuacion++
        contadorPuntuacionLabel.text = "0" + "\(puntuacion)"
        }
        
        
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


//func destruirSubmarinoDamage(){
//    
//    
//    let explosionSubmarino = SKEmitterNode(fileNamed: "humoExplosion.sks")
//    explosionSubmarino.particleBirthRate = 17
//    explosionSubmarino.zPosition = 0
//    explosionSubmarino.setScale(0.4)
//    explosionSubmarino.position = CGPointMake(-40, 10)
//    submarino.addChild(explosionSubmarino)
//    
//    
//    // Cambiando el color del Submarino cuando colisiona
//    
//    submarino.runAction(SKAction.repeatActionForever(
//        SKAction.sequence([
//            SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 0.3, duration: 0.4),
//            SKAction.waitForDuration(0.4),
//            SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 0, duration: 0.4),
//            ])
//        ))
//}


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

    func particlesCounter() {
        contadorDeParticulas = contadorDeParticulas - 1
        contadorDeParticulasLabel.text = "\(contadorDeParticulas)"
        contadorDeParticulasLabel.fontName = "Avenir"
        contadorDeParticulasLabel.fontSize  = 25
        contadorDeParticulasLabel.fontColor = UIColor.whiteColor()
        contadorDeParticulasLabel.position = CGPointMake(650, 340)
        contadorDeParticulasLabel.zPosition = 120
        contadorDeParticulasLabel.removeFromParent()
            if contadorDeParticulas < 0{
        contadorDeParticulas = 0
            }
        let explosionSubmarino = SKEmitterNode(fileNamed: "humoExplosion.sks")
        explosionSubmarino.particleBirthRate = 16
        explosionSubmarino.zPosition = 0
        explosionSubmarino.setScale(0.4)
        explosionSubmarino.position = CGPointMake(-40, 10)
        submarino.addChild(explosionSubmarino)

        addChild(contadorDeParticulasLabel)
    }

    
    
}





