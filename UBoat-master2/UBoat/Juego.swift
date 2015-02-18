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
    
    var contadorDeParticulas = 40
    var contadorDeParticulasLabel = SKLabelNode()
    
    //Movimiento del Joistick
    let moveAnalogStick: AnalogStick = AnalogStick()
    
    //Para evitar la rotación en la colisión de elementos
    let constraint = SKConstraint.zRotation(SKRange(constantValue: 0))
    
    //fondo MAR y CIELO
    var fondo = SKSpriteNode()
    var fdcielo = SKSpriteNode()
    
    //AUDIO
    
    var sonidoSalidaTorpedo  = AVAudioPlayer()
    var sonidoExploxionImpacto = AVAudioPlayer()
    var sonidoOceano = AVAudioPlayer()
    var sonidoSubmarinoAlarm = AVAudioPlayer()
    var sonarSubmarino = AVAudioPlayer()
    var sonidoInterruptor = AVAudioPlayer()
    
    //OBJETOS
    var contadorImpactosEnEnemigo = 0
    var contadorImpactos = NSInteger()
    var contadorImpactosLabel = SKLabelNode()
    var puntuacion = NSInteger()
    var contadorPuntuacionLabel = SKLabelNode()
    var fondoPapel = SKSpriteNode()
    
    var submarino = SKSpriteNode()
    
    var prisma = SKSpriteNode()
    var mando = SKSpriteNode()
    var enemigo = SKSpriteNode()
    var misil = SKSpriteNode()
    var disparo = SKSpriteNode()
    var menuLabel = SKLabelNode()
    var botonDisparoMisil = SKSpriteNode()
    var botonDisparoAmetralladora = SKSpriteNode()
    var mina = SKSpriteNode()
    var iconDamage = SKSpriteNode()
    var botonDive = SKSpriteNode()
    var botonDiveIntUP = SKSpriteNode()
    var botonDiveIntDW = SKSpriteNode()
    var iconoOxigeno = SKSpriteNode()
    
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
        mandos()
        crearCielo()
        crearOceano ()
        mostrarColisiones()
        mostrarPuntuacion()
        motrarBotonDisparoMisil()
        motrarBotonDisparoAmetralladoral()
        reproducirEfectoAudioOceano()
        reproducirEfectoAudioSonarSubmarino()
        mostrarFondoPapel()
        mostrarIconoOxigeno()
        
        // Cronómetro
        
        var aSelector = "tiempo"
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector (aSelector), userInfo: nil, repeats: true)
        
               
        // Mostrar enenmigo indefinidadmente
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([SKAction.runBlock(aparecerEnemigo),
                SKAction.waitForDuration(22)])))

        // Mostrar mina indefinidadmente
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([SKAction.runBlock(aparecerMina),
                SKAction.waitForDuration(35)])))
        
}
  
    var minutos = Int()
    var horas = Int()
    
    func tiempo() {
    
        tiempoDePartida = tiempoDePartida + 1
            if tiempoDePartida == 60 {
                minutos++
                tiempoDePartida = 0
            }
            if minutos == 60 {
                horas++
                minutos = 0
            }
        tiempoDePartidaLabel.text = "\(horas) " + "º " + "\(minutos) " + "´ " + "\(tiempoDePartida) " + "´´"
        tiempoDePartidaLabel.fontName = "Avenir"
        tiempoDePartidaLabel.fontSize  = 15
        tiempoDePartidaLabel.fontColor = UIColor.whiteColor()
        tiempoDePartidaLabel.position = CGPointMake(50, 355)
        tiempoDePartidaLabel.zPosition = 120
        tiempoDePartidaLabel.removeFromParent()
        addChild(tiempoDePartidaLabel)
        }


    


    
    
    func reproducirEfectoAudioOceano(){
        let ubicacionAudioOceano = NSBundle.mainBundle().pathForResource("oceano", ofType: "mp3")
        var efectoOceano = NSURL(fileURLWithPath: ubicacionAudioOceano!)
        sonidoOceano = AVAudioPlayer(contentsOfURL: efectoOceano, error: nil)
        sonidoOceano.prepareToPlay()
        sonidoOceano.numberOfLoops = -1
        sonidoOceano.play()
        sonidoOceano.volume = 0.05
    }
    
    
    func reproducirEfectoAudioSubmarinoAlarm(){
        let ubicacionAudioAudioSubmarinoAlarm = NSBundle.mainBundle().pathForResource("SubmarineAlarm", ofType: "mp3")
        var efectoSubmarinoAlarm = NSURL(fileURLWithPath: ubicacionAudioAudioSubmarinoAlarm!)
        sonidoSubmarinoAlarm = AVAudioPlayer(contentsOfURL: efectoSubmarinoAlarm, error: nil)
        sonidoSubmarinoAlarm.prepareToPlay()
        sonidoSubmarinoAlarm.numberOfLoops = 20
        sonidoSubmarinoAlarm.play()
        sonidoSubmarinoAlarm.volume = 0.02
    }
    
    
    
    
    func reproducirBotonInterruptor(){
        let ubicacionAudioBotonInterruptor = NSBundle.mainBundle().pathForResource("BotonInterruptor", ofType: "mp3")
        var efectoBotonInterruptor = NSURL(fileURLWithPath: ubicacionAudioBotonInterruptor!)
        sonidoInterruptor = AVAudioPlayer(contentsOfURL: efectoBotonInterruptor, error: nil)
        sonidoInterruptor.prepareToPlay()
        sonidoInterruptor.numberOfLoops = 1
        sonidoInterruptor.play()
        sonidoInterruptor.volume = 0.10
    }
    
    func reproducirEfectoAudioSonarSubmarino(){
        let ubicacionAudioSonarSubamarino = NSBundle.mainBundle().pathForResource("SonarSubmarino1", ofType: "wav")
        var efectoSonarSubmarino = NSURL(fileURLWithPath: ubicacionAudioSonarSubamarino!)
        sonarSubmarino = AVAudioPlayer(contentsOfURL: efectoSonarSubmarino, error: nil)
        sonarSubmarino.prepareToPlay()
        sonarSubmarino.numberOfLoops = -1
        sonarSubmarino.play()
        sonarSubmarino.volume = 0.02
    }
        
    func reproducirEfectoAudioExplosionImpacto(){
        let ubicacionAudioExplosionImpacto = NSBundle.mainBundle().pathForResource("explosionImpacto", ofType: "wav")
        var efectoExplosionImpacto = NSURL(fileURLWithPath: ubicacionAudioExplosionImpacto!)
        sonidoExploxionImpacto = AVAudioPlayer(contentsOfURL: efectoExplosionImpacto, error: nil)
        sonidoExploxionImpacto.prepareToPlay()
        sonidoExploxionImpacto.play()
        sonidoExploxionImpacto.volume = 0.08
    }
    
    
    func reproducirEfectoAudioSalidaTorpedo(){
        let ubicacionAudioSalidaTorpedo = NSBundle.mainBundle().pathForResource("salidaTorpedo", ofType: "wav")
        var efectoSalidaTorpedo = NSURL(fileURLWithPath: ubicacionAudioSalidaTorpedo!)
        sonidoSalidaTorpedo = AVAudioPlayer(contentsOfURL: efectoSalidaTorpedo, error: nil)
        sonidoSalidaTorpedo.prepareToPlay()
        sonidoSalidaTorpedo.play()
        sonidoSalidaTorpedo.volume = 1
    }
    
    
    
    func mostrarBotonDive() {
        
        botonDive = SKSpriteNode(imageNamed: "botonDive")
        botonDive.setScale(1)
        botonDive.zPosition = 9
        botonDive.anchorPoint = CGPointMake(0.1,0.5);
        
        
        botonDiveIntUP = SKSpriteNode(imageNamed: "botonDiveIntUP")
        botonDiveIntUP.anchorPoint = CGPointMake(0.0,0.5);
        botonDiveIntUP.position = CGPointMake(11, 1)
        botonDiveIntUP.name = "InterruptorDiveUP"
        
        
        botonDiveIntDW = SKSpriteNode(imageNamed: "botonDiveIntDW")
        botonDiveIntDW.anchorPoint = CGPointMake(0.0,0.5);
        botonDiveIntDW.position = CGPointMake(11, -4)
        botonDiveIntDW.name = "InterruptorDiveDW"
        
        
        botonDive.addChild(botonDiveIntUP)
        
        
        let sequenceAnimaBotonDiveIN = SKAction.sequence([
            SKAction.group([
                SKAction.fadeInWithDuration(0.10),
                SKAction.scaleXTo(1.0, duration: 0.40),
                ]),
            ])
        
        let AnimaBotonDiveIN = SKAction.repeatAction(sequenceAnimaBotonDiveIN, count: 1)

//        botonDive.color = SKColor.redColor()
//        botonDive.colorBlendFactor = 1

        botonDive.xScale = 0.0
        botonDive.position = CGPointMake(93, self.frame.height -  self.frame.height + 24)
        botonDive.name = "botonDiveSubmarine"
        escena.addChild(botonDive)
        
        botonDive.runAction(AnimaBotonDiveIN)

    }

    
    
    func mostrarOxigenoVaciandose() {
        
        iconoOxigeno = SKSpriteNode(imageNamed: "iconOxigeno_01")
        iconoOxigeno.position = CGPointMake(self.frame.size.width - 30 , self.frame.size.height - 30)
        iconoOxigeno.zPosition = 8
        iconoOxigeno.name = "botonOxigenoVacio"
        
        
        //Crear Sprite IconOxigeno animado
        
        var texturaIconoOxigenoLlenandose1 = SKTexture(imageNamed: "iconOxigeno_01")
        texturaIconoOxigenoLlenandose1.filteringMode = SKTextureFilteringMode.Nearest
        
        var texturaIconoOxigenoLlenandose2 = SKTexture(imageNamed: "iconOxigeno_02")
        texturaIconoOxigenoLlenandose2.filteringMode = SKTextureFilteringMode.Nearest
        
        var texturaIconoOxigenoLlenandose3 = SKTexture(imageNamed: "iconOxigeno_03")
        texturaIconoOxigenoLlenandose3.filteringMode = SKTextureFilteringMode.Nearest
        
        var texturaIconoOxigenoLlenandose4 = SKTexture(imageNamed: "iconOxigeno_04")
        texturaIconoOxigenoLlenandose4.filteringMode = SKTextureFilteringMode.Nearest
        
        var texturaIconoOxigenoLlenandose5 = SKTexture(imageNamed: "iconOxigeno_05")
        texturaIconoOxigenoLlenandose5.filteringMode = SKTextureFilteringMode.Nearest
        
        var texturaIconoOxigenoLlenandose6 = SKTexture(imageNamed: "iconOxigeno_06")
        texturaIconoOxigenoLlenandose6.filteringMode = SKTextureFilteringMode.Nearest
        
        var texturaIconoOxigenoLlenandose7 = SKTexture(imageNamed: "iconOxigeno_07")
        texturaIconoOxigenoLlenandose7.filteringMode = SKTextureFilteringMode.Nearest
        
        var texturaIconoOxigenoLlenandose8 = SKTexture(imageNamed: "iconOxigeno_08")
        texturaIconoOxigenoLlenandose8.filteringMode = SKTextureFilteringMode.Nearest
        
        var texturaIconoOxigenoLlenandose9 = SKTexture(imageNamed: "iconOxigeno_09")
        texturaIconoOxigenoLlenandose9.filteringMode = SKTextureFilteringMode.Nearest
        
        var texturaIconoOxigenoLlenandose10 = SKTexture(imageNamed: "iconOxigeno_10")
        texturaIconoOxigenoLlenandose10.filteringMode = SKTextureFilteringMode.Nearest
        
        var texturaIconoOxigenoLlenandose11 = SKTexture(imageNamed: "iconOxigeno_11")
        texturaIconoOxigenoLlenandose11.filteringMode = SKTextureFilteringMode.Nearest
        
        var texturaIconoOxigenoLlenandose12 = SKTexture(imageNamed: "iconOxigeno_12")
        texturaIconoOxigenoLlenandose12.filteringMode = SKTextureFilteringMode.Nearest
        
        var texturaIconoOxigenoLlenandose13 = SKTexture(imageNamed: "iconOxigeno_13")
        texturaIconoOxigenoLlenandose13.filteringMode = SKTextureFilteringMode.Nearest
        
        var texturaIconoOxigenoLlenandose14 = SKTexture(imageNamed: "iconOxigeno_14")
        texturaIconoOxigenoLlenandose14.filteringMode = SKTextureFilteringMode.Nearest
        
        var texturaIconoOxigenoLlenandose15 = SKTexture(imageNamed: "iconOxigeno_15")
        texturaIconoOxigenoLlenandose15.filteringMode = SKTextureFilteringMode.Nearest
        
        var texturaIconoOxigenoLlenandose16 = SKTexture(imageNamed: "iconOxigeno_16")
        texturaIconoOxigenoLlenandose16.filteringMode = SKTextureFilteringMode.Nearest
        
        var texturaIconoOxigenoLlenandose17 = SKTexture(imageNamed: "iconOxigeno_17")
        texturaIconoOxigenoLlenandose17.filteringMode = SKTextureFilteringMode.Nearest
        
        var texturaIconoOxigenoLlenandose18 = SKTexture(imageNamed: "iconOxigeno_18")
        texturaIconoOxigenoLlenandose18.filteringMode = SKTextureFilteringMode.Nearest
        
        var texturaIconoOxigenoLlenandose19 = SKTexture(imageNamed: "iconOxigeno_19")
        texturaIconoOxigenoLlenandose19.filteringMode = SKTextureFilteringMode.Nearest
        
        var texturaIconoOxigenoLlenandose20 = SKTexture(imageNamed: "iconOxigeno_20")
        texturaIconoOxigenoLlenandose20.filteringMode = SKTextureFilteringMode.Nearest
        
        var texturaIconoOxigenoLlenandose21 = SKTexture(imageNamed: "iconOxigeno_21")
        texturaIconoOxigenoLlenandose21.filteringMode = SKTextureFilteringMode.Nearest
        
        var texturaIconoOxigenoLlenandose22 = SKTexture(imageNamed: "iconOxigeno_22")
        texturaIconoOxigenoLlenandose22.filteringMode = SKTextureFilteringMode.Nearest
        
        var texturaIconoOxigenoLlenandose23 = SKTexture(imageNamed: "iconOxigeno_23")
        texturaIconoOxigenoLlenandose21.filteringMode = SKTextureFilteringMode.Nearest
        
        var texturaIconoOxigenoLlenandose24 = SKTexture(imageNamed: "iconOxigeno_24")
        texturaIconoOxigenoLlenandose24.filteringMode = SKTextureFilteringMode.Nearest
        
        var texturaIconoOxigenoLlenandose25 = SKTexture(imageNamed: "iconOxigeno_25")
        texturaIconoOxigenoLlenandose25.filteringMode = SKTextureFilteringMode.Nearest
        
        var texturaIconoOxigenoLlenandose26 = SKTexture(imageNamed: "iconOxigeno_26")
        texturaIconoOxigenoLlenandose26.filteringMode = SKTextureFilteringMode.Nearest
        
        var texturaIconoOxigenoLlenandose27 = SKTexture(imageNamed: "iconOxigeno_27")
        texturaIconoOxigenoLlenandose27.filteringMode = SKTextureFilteringMode.Nearest
        
        
        var animacionIconoOxigenoAcabandose = SKAction.animateWithTextures([texturaIconoOxigenoLlenandose1, texturaIconoOxigenoLlenandose2, texturaIconoOxigenoLlenandose3, texturaIconoOxigenoLlenandose4, texturaIconoOxigenoLlenandose5, texturaIconoOxigenoLlenandose6, texturaIconoOxigenoLlenandose7, texturaIconoOxigenoLlenandose8, texturaIconoOxigenoLlenandose9, texturaIconoOxigenoLlenandose10, texturaIconoOxigenoLlenandose11, texturaIconoOxigenoLlenandose12, texturaIconoOxigenoLlenandose13, texturaIconoOxigenoLlenandose14, texturaIconoOxigenoLlenandose15, texturaIconoOxigenoLlenandose16, texturaIconoOxigenoLlenandose17, texturaIconoOxigenoLlenandose18, texturaIconoOxigenoLlenandose19, texturaIconoOxigenoLlenandose20, texturaIconoOxigenoLlenandose21, texturaIconoOxigenoLlenandose22, texturaIconoOxigenoLlenandose23, texturaIconoOxigenoLlenandose24, texturaIconoOxigenoLlenandose25, texturaIconoOxigenoLlenandose26, texturaIconoOxigenoLlenandose27], timePerFrame: 1.0)
        
        var accionIconoOxigenoAcabandose = SKAction.repeatAction(animacionIconoOxigenoAcabandose, count: 1)
        
        let desapareceIconoOxigeno = SKAction.fadeOutWithDuration(0.30)
        //var retardoBotonInmersion = SKAction.waitForDuration(60)
//        var apareceBotonInmersion = SKAction.runBlock({() in self.mostrarBotonDive()})
        var controlOxigenoConBotonInmersion = SKAction.sequence([accionIconoOxigenoAcabandose, desapareceIconoOxigeno])
        
        iconoOxigeno.runAction(controlOxigenoConBotonInmersion)
        
        escena.addChild(iconoOxigeno)
        
        
        
    }
    
    
    
    func mostrarIconoOxigeno() {
        
        
        iconoOxigeno = SKSpriteNode(imageNamed: "Oxigeno 100")
        iconoOxigeno.setScale(0.5)
        iconoOxigeno.zPosition = 9
        iconoOxigeno.position = CGPointMake(self.frame.width / 1.02, self.frame.height / 1.1)
        iconoOxigeno.name = "botonOxigenoLleno"
        
        
        var texturaIconoOxigenoLlenandose1 = SKTexture(imageNamed: "Oxigeno 000")
        texturaIconoOxigenoLlenandose1.filteringMode = SKTextureFilteringMode.Nearest
        var texturaIconoOxigenoLlenandose2 = SKTexture(imageNamed: "Oxigeno 005")
        texturaIconoOxigenoLlenandose2.filteringMode = SKTextureFilteringMode.Nearest
        var texturaIconoOxigenoLlenandose3 = SKTexture(imageNamed: "Oxigeno 010")
        texturaIconoOxigenoLlenandose3.filteringMode = SKTextureFilteringMode.Nearest
        var texturaIconoOxigenoLlenandose4 = SKTexture(imageNamed: "Oxigeno 015")
        texturaIconoOxigenoLlenandose4.filteringMode = SKTextureFilteringMode.Nearest
        var texturaIconoOxigenoLlenandose5 = SKTexture(imageNamed: "Oxigeno 020")
        texturaIconoOxigenoLlenandose5.filteringMode = SKTextureFilteringMode.Nearest
        var texturaIconoOxigenoLlenandose6 = SKTexture(imageNamed: "Oxigeno 025")
        texturaIconoOxigenoLlenandose6.filteringMode = SKTextureFilteringMode.Nearest
        var texturaIconoOxigenoLlenandose7 = SKTexture(imageNamed: "Oxigeno 030")
        texturaIconoOxigenoLlenandose7.filteringMode = SKTextureFilteringMode.Nearest
        var texturaIconoOxigenoLlenandose8 = SKTexture(imageNamed: "Oxigeno 035")
        texturaIconoOxigenoLlenandose8.filteringMode = SKTextureFilteringMode.Nearest
        var texturaIconoOxigenoLlenandose9 = SKTexture(imageNamed: "Oxigeno 040")
        texturaIconoOxigenoLlenandose9.filteringMode = SKTextureFilteringMode.Nearest
        var texturaIconoOxigenoLlenandose10 = SKTexture(imageNamed: "Oxigeno 045")
        texturaIconoOxigenoLlenandose10.filteringMode = SKTextureFilteringMode.Nearest
        var texturaIconoOxigenoLlenandose11 = SKTexture(imageNamed: "Oxigeno 050")
        texturaIconoOxigenoLlenandose11.filteringMode = SKTextureFilteringMode.Nearest
        var texturaIconoOxigenoLlenandose12 = SKTexture(imageNamed: "Oxigeno 055")
        texturaIconoOxigenoLlenandose12.filteringMode = SKTextureFilteringMode.Nearest
        var texturaIconoOxigenoLlenandose13 = SKTexture(imageNamed: "Oxigeno 060")
        texturaIconoOxigenoLlenandose13.filteringMode = SKTextureFilteringMode.Nearest
        var texturaIconoOxigenoLlenandose14 = SKTexture(imageNamed: "Oxigeno 065")
        texturaIconoOxigenoLlenandose14.filteringMode = SKTextureFilteringMode.Nearest
        var texturaIconoOxigenoLlenandose15 = SKTexture(imageNamed: "Oxigeno 070")
        texturaIconoOxigenoLlenandose15.filteringMode = SKTextureFilteringMode.Nearest
        var texturaIconoOxigenoLlenandose16 = SKTexture(imageNamed: "Oxigeno 075")
        texturaIconoOxigenoLlenandose16.filteringMode = SKTextureFilteringMode.Nearest
        var texturaIconoOxigenoLlenandose17 = SKTexture(imageNamed: "Oxigeno 080")
        texturaIconoOxigenoLlenandose17.filteringMode = SKTextureFilteringMode.Nearest
        var texturaIconoOxigenoLlenandose18 = SKTexture(imageNamed: "Oxigeno 085")
        texturaIconoOxigenoLlenandose18.filteringMode = SKTextureFilteringMode.Nearest
        var texturaIconoOxigenoLlenandose19 = SKTexture(imageNamed: "Oxigeno 090")
        texturaIconoOxigenoLlenandose19.filteringMode = SKTextureFilteringMode.Nearest
        var texturaIconoOxigenoLlenandose20 = SKTexture(imageNamed: "Oxigeno 095")
        texturaIconoOxigenoLlenandose20.filteringMode = SKTextureFilteringMode.Nearest
        var texturaIconoOxigenoLlenandose21 = SKTexture(imageNamed: "Oxigeno 100")
        texturaIconoOxigenoLlenandose21.filteringMode = SKTextureFilteringMode.Nearest
//
//        
        var animacionIconoOxigenoLlenandose = SKAction.animateWithTextures([texturaIconoOxigenoLlenandose21, texturaIconoOxigenoLlenandose20, texturaIconoOxigenoLlenandose19, texturaIconoOxigenoLlenandose18, texturaIconoOxigenoLlenandose17, texturaIconoOxigenoLlenandose16, texturaIconoOxigenoLlenandose15, texturaIconoOxigenoLlenandose14, texturaIconoOxigenoLlenandose13, texturaIconoOxigenoLlenandose12, texturaIconoOxigenoLlenandose11, texturaIconoOxigenoLlenandose10, texturaIconoOxigenoLlenandose9, texturaIconoOxigenoLlenandose8, texturaIconoOxigenoLlenandose7, texturaIconoOxigenoLlenandose6, texturaIconoOxigenoLlenandose5, texturaIconoOxigenoLlenandose4, texturaIconoOxigenoLlenandose3, texturaIconoOxigenoLlenandose2, texturaIconoOxigenoLlenandose1], timePerFrame: 0.5)
    
    
//        var accionIconoOxigenoAcabandose = SKAction.repeatAction(animacionIconoOxigenoAcabandose, count: 1)
    
    
    //        let desapareceIconoOxigeno = SKAction.fadeOutWithDuration(0.30)
    //        var controlOxigenoVaciandose = SKAction.sequence([animacionIconoOxigenoAcabandose, desapareceIconoOxigeno])
    //
    //        iconoOxigeno.runAction(controlOxigenoVaciandose)
    //
    //
    //        escena.addChild(iconoOxigeno)
    
    
    
    
    var accionIconoOxigenoLlenandose = SKAction.repeatAction(animacionIconoOxigenoLlenandose, count: 1)
    
    let desapareceIconoOxigeno = SKAction.fadeOutWithDuration(0.30)
    //var retardoBotonInmersion = SKAction.waitForDuration(60)
    var apareceBotonInmersion = SKAction.runBlock({() in self.mostrarBotonDive()})
    var controlOxigenoConBotonInmersion = SKAction.sequence([animacionIconoOxigenoLlenandose, desapareceIconoOxigeno, apareceBotonInmersion])
    
    iconoOxigeno.runAction(controlOxigenoConBotonInmersion)
    
    escena.addChild(iconoOxigeno)
    
    
    
    
//        let desapareceIconoOxigeno = SKAction.fadeOutWithDuration(0.30)
//        var controlOxigenoVaciandose = SKAction.sequence([animacionIconoOxigenoAcabandose, desapareceIconoOxigeno])
//        
//        iconoOxigeno.runAction(controlOxigenoVaciandose)
//        
//    
//        escena.addChild(iconoOxigeno)
//        
//        
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
        menuLabel.fontName = "HelveticaNeue-CondensedBlack"
        menuLabel.fontSize  = 50
        menuLabel.fontColor = UIColor.whiteColor()
        menuLabel.alpha = 1
        menuLabel.zPosition = 120
        menuLabel.position = CGPointMake(self.frame.width / 2, self.frame.height / 2 - 100)
        menuLabel.text = "Game Over"
        escena.addChild(menuLabel)
        runAction(SKAction.sequence([
            SKAction.waitForDuration(3.0),
            SKAction.runBlock() {
                
                let aparecer = SKTransition.flipHorizontalWithDuration(1)
                let pantalla = marca(size: self.size)
                self.view?.presentScene(pantalla, transition: aparecer)
            }
            
            ]))
        
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
        
//        submarino.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(submarino.size.width - 30, 30))
        
        submarino.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(submarino.size.width - 18, 16), center: CGPointMake(0.0, -3.0))

        
        submarino.physicsBody?.dynamic = false
        submarino.physicsBody?.categoryBitMask = categoriaSubmarino
        submarino.physicsBody?.collisionBitMask = categoriaEnemigo
        submarino.physicsBody?.contactTestBitMask  = categoriaEnemigo
//        submarino.physicsBody?.categoryBitMask = categoriaSubmarino
        submarino.physicsBody?.collisionBitMask = categoriaMina
        submarino.physicsBody?.contactTestBitMask  = categoriaMina
        
  
        
        escena.addChild(submarino)
        
    }
    
    
    
    func aparecerEnemigo(){
        var altura = UInt (self.frame.size.height - 100 )
        var alturaRandom = UInt (arc4random()) % altura
        
        enemigo = SKSpriteNode(imageNamed: "enemigo")
//        enemigo.setScale(0.4)
        enemigo.position = CGPointMake(self.frame.size.width + enemigo.size.width / 2, CGFloat(25 + alturaRandom))
        
        //Ajuste de escala dependiendo de la posición Y del enemigo
        var posicionEnemigoy:Int = Int(enemigo.position.y)
        
        switch (posicionEnemigoy)
        {
        case 277...305:
            println("<----- tiene entre 304 y 277")
            println ("\n")
            var action = SKAction.scaleTo(0.25, duration: 0.10)
            enemigo.runAction(action)
            
        case 249...276:
            println("<----- tiene entre 276 y 249")
            println ("\n")
            var action = SKAction.scaleTo(0.30, duration: 0.10)
            enemigo.runAction(action)
            
        case 221...248:
            println("<----- tiene entre 248 y 221")
            println ("\n")
            var action = SKAction.scaleTo(0.35, duration: 0.10)
            enemigo.runAction(action)
            
        case 193...220:
            println("<----- tiene entre 220 y 193")
            println ("\n")
            var action = SKAction.scaleTo(0.40, duration: 0.10)
            enemigo.runAction(action)
            
        case 165...192:
            println("<----- tiene entre 192 y 165")
            println ("\n")
            var action = SKAction.scaleTo(0.45, duration: 0.10)
            enemigo.runAction(action)
            
        case 137...164:
            println("<----- tiene entre 164 y 137")
            println ("\n")
            var action = SKAction.scaleTo(0.50, duration: 0.10)
            enemigo.runAction(action)
            
        case 110...136:
            println("<----- tiene entre 136 y 110")
            println ("\n")
            var action = SKAction.scaleTo(0.55, duration: 0.10)
            enemigo.runAction(action)
            
        case 81...109:
            println("<----- tiene entre 109 y 81")
            println ("\n")
            var action = SKAction.scaleTo(0.60, duration: 0.10)
            enemigo.runAction(action)
            
        default:
            println("<----- tiene entre 80 y 35")
            println ("\n")
            var action = SKAction.scaleTo(0.65, duration: 0.10)
            enemigo.runAction(action)
        }
        
        //enemigo.zPosition = CGFloat()
        if submarino.position.y > enemigo.position.y {
            enemigo.zPosition = submarino.zPosition + 1
        }
        else if submarino.position.y < enemigo.position.y {
            enemigo.zPosition = submarino.zPosition - 1
        }
        enemigo.constraints = [constraint]
        enemigo.name = "enemigo"
        
//        let estelaEnemigo = SKEmitterNode(fileNamed: "estelaEnemigo.sks")
//        estelaEnemigo.zPosition = 0
//        estelaEnemigo.setScale(0.5)
//        estelaEnemigo.position = CGPointMake(20, -45)
        
//        enemigo.addChild(estelaEnemigo)
        
//        enemigo.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(enemigo.size.width - 30, 30))
        
        enemigo.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(enemigo.size.width - 8, 38), center: CGPointMake(0.0, -30.0))
        
        enemigo.physicsBody?.dynamic = true
        enemigo.physicsBody?.categoryBitMask = categoriaEnemigo
        enemigo.physicsBody?.collisionBitMask = categoriaSubmarino
        enemigo.physicsBody?.contactTestBitMask  = categoriaSubmarino
        
        escena.addChild(enemigo)
        
        
        var alturaEnemigo = UInt (self.frame.size.height - 100 )
        var alturaEnemigoRandom = UInt (arc4random()) % altura
        var desplazarEnemigo = SKAction.moveTo(CGPointMake( -enemigo.size.width * 2 , CGFloat(enemigo.position.y)), duration: 25)
        enemigo.runAction(desplazarEnemigo)
    }
    
    
    func aparecerMina(){
        
        
        var altura = UInt (self.frame.size.height - 100 )
        var alturaRandom = UInt (arc4random()) % altura
        
        mina = SKSpriteNode(imageNamed: "Anima_Mina0024")
//        mina.setScale(0.8)
        mina.position = CGPointMake(self.frame.size.width - mina.size.width + mina.size.width * 2, CGFloat(25 + alturaRandom))
        
        
        //Ajuste de escala dependiendo de la posición Y de la mina
        var posicionMinay:Int = Int(mina.position.y)
        
        switch (posicionMinay)
        {
        case 277...305:
            println("<----- tiene entre 304 y 277")
            println ("\n")
            var action = SKAction.scaleTo(0.35, duration: 0.10)
            mina.runAction(action)
            
        case 249...276:
            println("<----- tiene entre 276 y 249")
            println ("\n")
            var action = SKAction.scaleTo(0.40, duration: 0.10)
            mina.runAction(action)
            
        case 221...248:
            println("<----- tiene entre 248 y 221")
            println ("\n")
            var action = SKAction.scaleTo(0.45, duration: 0.10)
            mina.runAction(action)
            
        case 193...220:
            println("<----- tiene entre 220 y 193")
            println ("\n")
            var action = SKAction.scaleTo(0.50, duration: 0.10)
            mina.runAction(action)
            
        case 165...192:
            println("<----- tiene entre 192 y 165")
            println ("\n")
            var action = SKAction.scaleTo(0.55, duration: 0.10)
            mina.runAction(action)
            
        case 137...164:
            println("<----- tiene entre 164 y 137")
            println ("\n")
            var action = SKAction.scaleTo(0.60, duration: 0.10)
            mina.runAction(action)
            
        case 110...136:
            println("<----- tiene entre 136 y 110")
            println ("\n")
            var action = SKAction.scaleTo(0.65, duration: 0.10)
            mina.runAction(action)
            
        case 81...109:
            println("<----- tiene entre 109 y 81")
            println ("\n")
            var action = SKAction.scaleTo(0.70, duration: 0.10)
            mina.runAction(action)
            
        default:
            println("<----- tiene entre 80 y 35")
            println ("\n")
            var action = SKAction.scaleTo(0.75, duration: 0.10)
            mina.runAction(action)
        }
        
    

    
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
        
//      mina.physicsBody = SKPhysicsBody(circleOfRadius: mina.size.width / 4)
        mina.physicsBody = SKPhysicsBody(circleOfRadius: mina.size.width / 3.4, center: CGPointMake(0.0, -7.0))


        mina.physicsBody?.dynamic = true
        mina.physicsBody?.categoryBitMask = categoriaMina
        mina.physicsBody?.collisionBitMask = categoriaSubmarino
        mina.physicsBody?.contactTestBitMask  = categoriaSubmarino
        
   
        escena.addChild(mina)
    }
    
    
    
    
    
    
    
    
    func mostrarIconDamage(){
        
        iconDamage = SKSpriteNode(imageNamed: "iconDamage_01")
        iconDamage.position = CGPointMake(self.frame.size.width - 30 , self.frame.size.height - 30)
        iconDamage.zPosition = 8
        iconDamage.setScale(0.0)
        
        //Crear Sprite IconDamage animado
        
        var texturaIconDamage1 = SKTexture(imageNamed: "iconDamage_01")
        texturaIconDamage1.filteringMode = SKTextureFilteringMode.Nearest
        var texturaIconDamage2 = SKTexture(imageNamed: "iconDamage_02")
        texturaIconDamage2.filteringMode = SKTextureFilteringMode.Nearest
        var texturaIconDamage3 = SKTexture(imageNamed: "iconDamage_03")
        texturaIconDamage3.filteringMode = SKTextureFilteringMode.Nearest
        var texturaIconDamage4 = SKTexture(imageNamed: "iconDamage_04")
        texturaIconDamage4.filteringMode = SKTextureFilteringMode.Nearest
        var texturaIconDamage5 = SKTexture(imageNamed: "iconDamage_05")
        texturaIconDamage5.filteringMode = SKTextureFilteringMode.Nearest
        var texturaIconDamage6 = SKTexture(imageNamed: "iconDamage_06")
        texturaIconDamage6.filteringMode = SKTextureFilteringMode.Nearest
        var texturaIconDamage7 = SKTexture(imageNamed: "iconDamage_07")
        texturaIconDamage7.filteringMode = SKTextureFilteringMode.Nearest
        var texturaIconDamage8 = SKTexture(imageNamed: "iconDamage_08")
        texturaIconDamage8.filteringMode = SKTextureFilteringMode.Nearest
        var texturaIconDamage9 = SKTexture(imageNamed: "iconDamage_09")
        texturaIconDamage9.filteringMode = SKTextureFilteringMode.Nearest
        var texturaIconDamage10 = SKTexture(imageNamed: "iconDamage_10")
        texturaIconDamage10.filteringMode = SKTextureFilteringMode.Nearest
        var texturaIconDamage11 = SKTexture(imageNamed: "iconDamage_11")
        texturaIconDamage11.filteringMode = SKTextureFilteringMode.Nearest
        var texturaIconDamage12 = SKTexture(imageNamed: "iconDamage_12")
        texturaIconDamage12.filteringMode = SKTextureFilteringMode.Nearest
        var texturaIconDamage13 = SKTexture(imageNamed: "iconDamage_13")
        texturaIconDamage13.filteringMode = SKTextureFilteringMode.Nearest
        var texturaIconDamage14 = SKTexture(imageNamed: "iconDamage_14")
        texturaIconDamage14.filteringMode = SKTextureFilteringMode.Nearest
        var texturaIconDamage15 = SKTexture(imageNamed: "iconDamage_15")
        texturaIconDamage15.filteringMode = SKTextureFilteringMode.Nearest
        var texturaIconDamage16 = SKTexture(imageNamed: "iconDamage_16")
        texturaIconDamage16.filteringMode = SKTextureFilteringMode.Nearest
        var texturaIconDamage17 = SKTexture(imageNamed: "iconDamage_17")
        texturaIconDamage17.filteringMode = SKTextureFilteringMode.Nearest
        var texturaIconDamage18 = SKTexture(imageNamed: "iconDamage_18")
        texturaIconDamage18.filteringMode = SKTextureFilteringMode.Nearest
        var texturaIconDamage19 = SKTexture(imageNamed: "iconDamage_19")
        texturaIconDamage19.filteringMode = SKTextureFilteringMode.Nearest
        var texturaIconDamage20 = SKTexture(imageNamed: "iconDamage_20")
        texturaIconDamage20.filteringMode = SKTextureFilteringMode.Nearest
        var texturaIconDamage21 = SKTexture(imageNamed: "iconDamage_21")
        texturaIconDamage21.filteringMode = SKTextureFilteringMode.Nearest
        var texturaIconDamage22 = SKTexture(imageNamed: "iconDamage_22")
        texturaIconDamage22.filteringMode = SKTextureFilteringMode.Nearest
        var texturaIconDamage23 = SKTexture(imageNamed: "iconDamage_23")
        texturaIconDamage23.filteringMode = SKTextureFilteringMode.Nearest
        var texturaIconDamage24 = SKTexture(imageNamed: "iconDamage_24")
        texturaIconDamage24.filteringMode = SKTextureFilteringMode.Nearest
        var texturaIconDamage25 = SKTexture(imageNamed: "iconDamage_25")
        texturaIconDamage25.filteringMode = SKTextureFilteringMode.Nearest
        var texturaIconDamage26 = SKTexture(imageNamed: "iconDamage_26")
        texturaIconDamage26.filteringMode = SKTextureFilteringMode.Nearest
        var texturaIconDamage27 = SKTexture(imageNamed: "iconDamage_27")
        texturaIconDamage27.filteringMode = SKTextureFilteringMode.Nearest
        var texturaIconDamage28 = SKTexture(imageNamed: "iconDamage_28")
        texturaIconDamage28.filteringMode = SKTextureFilteringMode.Nearest
        var texturaIconDamage29 = SKTexture(imageNamed: "iconDamage_29")
        texturaIconDamage29.filteringMode = SKTextureFilteringMode.Nearest
        var texturaIconDamage30 = SKTexture(imageNamed: "iconDamage_30")
        texturaIconDamage30.filteringMode = SKTextureFilteringMode.Nearest
        
        var animacionIconDamage = SKAction.animateWithTextures([texturaIconDamage1, texturaIconDamage2, texturaIconDamage3, texturaIconDamage4, texturaIconDamage5, texturaIconDamage6, texturaIconDamage7, texturaIconDamage8, texturaIconDamage9, texturaIconDamage10, texturaIconDamage11, texturaIconDamage12, texturaIconDamage13, texturaIconDamage14, texturaIconDamage15, texturaIconDamage16, texturaIconDamage17, texturaIconDamage18, texturaIconDamage19, texturaIconDamage20, texturaIconDamage21, texturaIconDamage22, texturaIconDamage23, texturaIconDamage24, texturaIconDamage25, texturaIconDamage26, texturaIconDamage27, texturaIconDamage28, texturaIconDamage29, texturaIconDamage30], timePerFrame: 1.20)
        
        let desapareceIconDamage = SKAction.fadeOutWithDuration(0.30)
        
        let secuenciaIconDamage = SKAction.sequence([
            SKAction.group([
                SKAction.fadeInWithDuration(0.30),
                SKAction.scaleTo(1.4, duration: 0.30)
                ]),
            SKAction.scaleTo(0.8, duration: 0.20),
            SKAction.scaleTo(1.0, duration: 0.10),
            animacionIconDamage,
            desapareceIconDamage,])
        
        
        let accionIconDamage = SKAction.repeatAction(secuenciaIconDamage, count: 1)
       
        iconDamage.runAction(accionIconDamage, withKey: "iconDamage")

        escena.addChild(iconDamage)
        
        
    }
    
    
    
    
    
    
    func lanzarMisil(){
        misil = SKSpriteNode(imageNamed: "misil")
//        misil.setScale(0.05)
        
        misil.position = CGPointMake(submarino.position.x + 20 , submarino.position.y - 5)
        
        //Ajuste de escala dependiendo de la posición Y del torpedo
        var posicionTorpedoy:Int = Int(misil.position.y)
        
        switch (posicionTorpedoy)
        {
        case 277...305:
            println("<----- tiene entre 304 y 277")
            println ("\n")
            var action = SKAction.scaleTo(0.25, duration: 0.0)
            misil.runAction(action)
            
        case 249...276:
            println("<----- tiene entre 276 y 249")
            println ("\n")
            var action = SKAction.scaleTo(0.30, duration: 0.0)
           misil.runAction(action)
            
        case 221...248:
            println("<----- tiene entre 248 y 221")
            println ("\n")
            var action = SKAction.scaleTo(0.35, duration: 0.0)
            misil.runAction(action)
            
        case 193...220:
            println("<----- tiene entre 220 y 193")
            println ("\n")
            var action = SKAction.scaleTo(0.40, duration: 0.0)
            misil.runAction(action)
            
        case 165...192:
            println("<----- tiene entre 192 y 165")
            println ("\n")
            var action = SKAction.scaleTo(0.45, duration: 0.0)
            misil.runAction(action)
            
        case 137...164:
            println("<----- tiene entre 164 y 137")
            println ("\n")
            var action = SKAction.scaleTo(0.50, duration: 0.0)
            misil.runAction(action)
            
        case 110...136:
            println("<----- tiene entre 136 y 110")
            println ("\n")
            var action = SKAction.scaleTo(0.55, duration: 0.0)
            misil.runAction(action)
            
        case 81...109:
            println("<----- tiene entre 109 y 81")
            println ("\n")
            var action = SKAction.scaleTo(0.60, duration: 0.0)
            misil.runAction(action)
            
        default:
            println("<----- tiene entre 80 y 35")
            println ("\n")
            var action = SKAction.scaleTo(0.65, duration: 0.0)
           misil.runAction(action)
        }
        
        misil.zPosition = 3
        
        
        
        
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
    
    func mandos() {
        
        mando = SKSpriteNode(imageNamed: "Mandos")
        mando.size = self.size
        mando.setScale(1)
        mando.zPosition = 8
        mando.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        mando.constraints      = [constraint]
        
        escena.addChild(mando)
        
    }

    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        
        
        let tocarBotonSumergir: AnyObject = touches.anyObject()!
        let posicionTocarBotonSumergir = tocarBotonSumergir.locationInNode(self)
        let tocamosBotonSumergir = self.nodeAtPoint(posicionTocarBotonSumergir)
        
        if tocamosBotonSumergir == botonDiveIntUP && uci == false {
            
            botonDive.removeAllChildren()
            botonDive.addChild(botonDiveIntDW)
            reproducirBotonInterruptor()
            var objsubmarino = Submarino()
            submarino.runAction(objsubmarino.submarinoInmersion())
            
            let sequenceAnimaBotonDive = SKAction.sequence([
                SKAction.waitForDuration(2.0),
                SKAction.group([
                    SKAction.fadeOutWithDuration(0.70),
                    SKAction.scaleXTo(0.0, duration: 0.40),
                    ]),
                ])
            
            let AnimaBotonDive = SKAction.repeatAction(sequenceAnimaBotonDive, count: 1)
            botonDive.runAction(AnimaBotonDive)
            
            
            var apareceBotonOxigenoVaciandose = SKAction.runBlock({() in self.mostrarOxigenoVaciandose()})
            var retardoBotonOxigeno = SKAction.waitForDuration(8)
            
            var apareceBotonOxigenoLlenandose = SKAction.runBlock({() in self.mostrarIconoOxigeno()})
            var controlOxigeno = SKAction.sequence([apareceBotonOxigenoVaciandose, retardoBotonOxigeno, apareceBotonOxigenoLlenandose])
            
            iconoOxigeno.runAction(controlOxigeno)
        }

        
        
        
        
        let tocarMenuLabel: AnyObject = touches.anyObject()!
        let posicionTocarMenuLabel = tocarMenuLabel.locationInNode(self)
        let tocamosMenuLabel = self.nodeAtPoint(posicionTocarMenuLabel)
        
        if tocamosMenuLabel == menuLabel {
            let transicion = SKTransition.revealWithDirection(SKTransitionDirection.Right, duration: 2)
            let  aparecerEscena = Menu(size: self.size)
            aparecerEscena.scaleMode = SKSceneScaleMode.AspectFill
            self.scene?.view?.presentScene(aparecerEscena, transition: transicion)
        }
        
        
        
//        if tocamosMenuLabel == botonDiveIntUP {
//            botonDive.removeAllChildren()
//            botonDive.addChild(botonDiveIntDW)
//            reproducirBotonInterruptor()
//        }
//        
//        if tocamosMenuLabel == botonDiveIntDW {
//            botonDive.removeAllChildren()
//            botonDive.addChild(botonDiveIntUP)
//            reproducirBotonInterruptor()
//        }
        
        
        
        let tocarBotonLanzarMisil: AnyObject = touches.anyObject()!
        
        let posicionTocarBotonLanzarMisil = tocarBotonLanzarMisil.locationInNode(self)
        
        let loQueTocamosBotonLanzarMisil = self.nodeAtPoint(posicionTocarBotonLanzarMisil)
        
        if loQueTocamosBotonLanzarMisil == botonDisparoMisil && uci == false {
            
            lanzarMisil()
            
        }
        
        let tocarBotonDisparar: AnyObject = touches.anyObject()!
        
        let posicionTocarBotonDisparar = tocarBotonDisparar.locationInNode(self)
        
        let loQueTocamosBotonDisparar = self.nodeAtPoint(posicionTocarBotonDisparar)
        
        if loQueTocamosBotonDisparar == botonDisparoAmetralladora && uci == false {
            
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
    
    
//    var altofondo: CGFloat = CGFloat ()
    
    
    func crearOceano() {
        
        for var indice = 0; indice < 2; ++indice {
            
            fondo = SKSpriteNode(imageNamed: "mar4")
            fondo.position = CGPoint(x: (indice * Int(fondo.size.width)) + Int(fondo.size.width)/2, y: Int(fondo.size.height)/2)
            
            fondo.name = "fondo"
            fondo.zPosition = 2
            
//            altofondo = fondo.size.height
//            
//            println("\(altofondo)")
            
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
              
                //Ajuste de escala dependiendo de la posición Y del submarino
                var posicionSuby:Int = Int(submarino.position.y)
                var escala:CGFloat = 0.0
                
                switch (posicionSuby)
                {
                case 277...305:
                    println("<----- tiene entre 304 y 277")
                    println ("\n")
                    escala = 0.45
                    
//                    var action = SKAction.scaleTo(0.45, duration: 0.10)
//                    submarino.runAction(action)
                    
                case 249...276:
                    println("<----- tiene entre 276 y 249")
                    println ("\n")
                    escala = 0.50
//                    var action = SKAction.scaleTo(0.50, duration: 0.10)
//                    submarino.runAction(action)
                    
                case 221...248:
                    println("<----- tiene entre 248 y 221")
                    println ("\n")
                    escala = 0.55
//                    var action = SKAction.scaleTo(0.55, duration: 0.10)
//                    submarino.runAction(action)
                    
                case 193...220:
                    println("<----- tiene entre 220 y 193")
                    println ("\n")
                    escala = 0.60
//                    var action = SKAction.scaleTo(0.60, duration: 0.10)
//                    submarino.runAction(action)
                    
                case 165...192:
                    println("<----- tiene entre 192 y 165")
                    println ("\n")
                    escala = 0.65
//                    var action = SKAction.scaleTo(0.65, duration: 0.10)
//                    submarino.runAction(action)
                    
                case 137...164:
                    println("<----- tiene entre 164 y 137")
                    println ("\n")
                    escala = 0.70
//                    var action = SKAction.scaleTo(0.70, duration: 0.10)
//                    submarino.runAction(action)
                    
                case 110...136:
                    println("<----- tiene entre 136 y 110")
                    println ("\n")
                    escala = 0.75
//                    var action = SKAction.scaleTo(0.75, duration: 0.10)
//                    submarino.runAction(action)
                    
                case 81...109:
                    println("<----- tiene entre 109 y 81")
                    println ("\n")
                    escala = 0.80
//                    var action = SKAction.scaleTo(0.80, duration: 0.10)
//                    submarino.runAction(action)
                    
                default:
                    println("<----- tiene entre 80 y 35")
                    println ("\n")
                    escala = 0.85
//                    var action = SKAction.scaleTo(0.85, duration: 0.10)
//                    submarino.runAction(action)
                }

                var action = SKAction.scaleTo(escala, duration: 0.10)
                submarino.runAction(action)
                
            }
            
            
            if submarino.position.y >= self.frame.height - 75 {
                submarino.position.y = self.frame.height - 75
            }
            
            if submarino.position.y <= 0 + 40 {
                submarino.position.y = 0 + 40
            }
            
        }
    }
    


var contacto = true
    
var uci = false
    
var contadorchoque = 0

var timer:NSTimer = NSTimer()


    

func didBeginContact(contact: SKPhysicsContact) {

    
    
    if (contact.bodyA.categoryBitMask & categoriaSubmarino) == categoriaSubmarino {

        reproducirEfectoAudioExplosionImpacto()
        
        
        contadorchoque++

        
        // Solo se dispara el evento al primer contacto
            
            if contacto == true && uci == false {
                
                contadorImpactos--
                contadorImpactosLabel.text = "0" + "\(contadorImpactos)"
                puntuacion++
                contadorPuntuacionLabel.text = "0" + "\(puntuacion)"
                
                // Cambiando el color del Submarino a rojo cuando colisiona
                
                let controlDamageSequence = SKAction.sequence([
                    SKAction.colorizeWithColor(SKColor.redColor(), colorBlendFactor: 1, duration: 0.3),
                    SKAction.waitForDuration(0.3),
                    SKAction.colorizeWithColor(SKColor.redColor(), colorBlendFactor: 0, duration: 0.3),
                    ])
                
                var controlDamage = SKAction.repeatAction(controlDamageSequence, count: contadorDeParticulas - 2)
                submarino.runAction(controlDamage, withKey: "tocado")
                
                reproducirEfectoAudioSubmarinoAlarm()
                sonarSubmarino.stop()
                
                
                mostrarIconDamage()
//                mostrarBotonDive()

                
                
                
                
                
                // Iniciando el contador de tiempo
                var aParticles = "cuentaAtras"
                timer = NSTimer.scheduledTimerWithTimeInterval(0.9, target: self, selector: Selector (aParticles), userInfo: nil, repeats: true)
                contacto = false
                uci = true
                
            }
        
        }
    
    if uci == true && contadorchoque > 1 {
        
        timer.invalidate()
        
        let controlDamageSequence2 = SKAction.sequence([
            SKAction.colorizeWithColor(SKColor.greenColor(), colorBlendFactor: 1, duration: 0.1),
            SKAction.waitForDuration(0.3),
            SKAction.colorizeWithColor(SKColor.greenColor(), colorBlendFactor: 0, duration: 0.1),
            ])
        let controlDamage2 = SKAction.repeatAction(controlDamageSequence2, count: 1)
        submarino.runAction(controlDamage2, withKey: "tocado")
        

//        submarino.removeActionForKey("tocado")
        destruirSubmarino()
        
        
    }
    




    if (contact.bodyB.categoryBitMask & categoriaMisil) == categoriaMisil && enemigo.physicsBody?.dynamic == true && enemigo.position.x < self.frame.width  {
        
        enemigo.physicsBody?.dynamic = false
        
        misil.removeFromParent()
        var explotarEnemigo = SKAction.runBlock({() in self.destruirBarco()})
        var retardo = SKAction.waitForDuration(0.5)
        var enemigoDesaparece = SKAction.removeFromParent()
        var enemigoAparece = SKAction.runBlock({() in self.aparecerEnemigo()})
        var controlEnemigo = SKAction.sequence([explotarEnemigo, retardo, enemigoDesaparece, retardo, enemigoAparece])
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



    func cuentaAtras() {

        contadorDeParticulas = contadorDeParticulas - 1
        
//        contadorDeParticulasLabel.text = "\(contadorDeParticulas)"
//        contadorDeParticulasLabel.fontName = "Avenir"
//        contadorDeParticulasLabel.fontSize  = 25
//        contadorDeParticulasLabel.fontColor = UIColor.whiteColor()
//        contadorDeParticulasLabel.position = CGPointMake(650, 340)
//        contadorDeParticulasLabel.zPosition = 120
//        contadorDeParticulasLabel.removeFromParent()
//        
//        addChild(contadorDeParticulasLabel)
        
        
        let explosionSubmarino = SKEmitterNode(fileNamed: "humoExplosion.sks")
        explosionSubmarino.particleBirthRate = 20
        explosionSubmarino.numParticlesToEmit = contadorDeParticulas + 1
        explosionSubmarino.zPosition = 0
        explosionSubmarino.setScale(0.4)
        explosionSubmarino.position = CGPointMake(-40, 10)
        submarino.addChild(explosionSubmarino)
        
 
        
        
        if contadorDeParticulas <= 0{

            
            // Agregando dos destelllos al final para indicar que se termino el daño
            
            
            let controlDamageSequence2 = SKAction.sequence([
                SKAction.colorizeWithColor(SKColor.greenColor(), colorBlendFactor: 1, duration: 0.2),
                SKAction.waitForDuration(0.2),
                SKAction.colorizeWithColor(SKColor.greenColor(), colorBlendFactor: 0, duration: 0.1),
                ])
            let controlDamage2 = SKAction.repeatAction(controlDamageSequence2, count: 2)
            submarino.runAction(controlDamage2, withKey: "tocado")
            
            
//            submarino.removeActionForKey("tocado")
            
            
            
            // Removiendo el Interruptor de sumerge submarino
//            let sequenceAnimaBotonDiveOUT = SKAction.sequence([
//                SKAction.group([
//                    SKAction.fadeOutWithDuration(0.70),
//                    SKAction.scaleXTo(0.0, duration: 0.40),
//                    ]),
//                ])
//            let AnimaBotonDiveOUT = SKAction.repeatAction(sequenceAnimaBotonDiveOUT, count: 1)
//            botonDive.runAction(AnimaBotonDiveOUT)
            
            
            
            
            
            // Parando el sonido de alarma
            
            sonidoSubmarinoAlarm.stop()
            sonarSubmarino.prepareToPlay()
            sonarSubmarino.numberOfLoops = -1
            sonarSubmarino.play()
            sonarSubmarino.volume = 0.02
            
            
            
//            submarino.removeActionForKey("tocado")
            
//            let controlDamage2 = SKAction.colorizeWithColor(SKColor.greenColor(), colorBlendFactor: 1, duration: 0)
//            submarino.runAction(controlDamage2, withKey: "damage")
//            submarino.removeActionForKey("damage")
           
            // Parando el contador de tiempo y reiniciando contadores
            contadorDeParticulas = 40
            
            contadorchoque = 0
            uci = false
            
            contacto = true
            timer.invalidate()
        }
        
        

    }







//
//    func submarinoTocado() {
//        
//        let explosionSubmarino = SKEmitterNode(fileNamed: "humoExplosion.sks")
//        explosionSubmarino.particleBirthRate = CGFloat(contadorDeParticulas)
//        explosionSubmarino.zPosition = 0
//        explosionSubmarino.setScale(0.4)
//        explosionSubmarino.position = CGPointMake(-40, 10)
//        
//        // Cambiando el color del Submarino cuando colisiona
//        submarino.runAction(SKAction.repeatActionForever(
//            SKAction.sequence([
//                SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 0.3, duration: 0),
//                SKAction.waitForDuration(0.4),
//               SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 0, duration: 0.4),
//                ])
//            ))
//
//        
//        submarino.addChild(explosionSubmarino)
//
//    }




    

    func destruirSubmarino(){
        
        let desapareceIconDamage = SKAction.fadeOutWithDuration(0.30)
        iconDamage.runAction(desapareceIconDamage)
        iconDamage.removeActionForKey("desapareceIconDamage")
        
        var retardo = SKAction.waitForDuration(3)
        var controlEscena = SKAction.speedBy(0, duration: 1)
        var controlSubmarino = SKAction.sequence([retardo,  controlEscena])
        runAction(controlSubmarino)
        
        let explosionSubmarino = SKEmitterNode(fileNamed: "humoExplosion.sks")
        explosionSubmarino.particleBirthRate = 20
        explosionSubmarino.numParticlesToEmit = 20
        explosionSubmarino.zPosition = 0
        explosionSubmarino.setScale(0.4)
        explosionSubmarino.position = CGPointMake(-40, 10)
        submarino.addChild(explosionSubmarino)
        sonidoSubmarinoAlarm.stop()
        volverMenu()
        
        
        submarino.physicsBody?.dynamic = false
        var desplazarSubmarino = SKAction.moveTo(CGPointMake( self.frame.width / 2, self.frame.height / 2), duration:2.0)
        submarino.runAction(desplazarSubmarino)
        sonarSubmarino.stop()
        sonidoOceano.stop()
        enemigo.removeFromParent()
        mina.removeFromParent()
    
    }

    
}





