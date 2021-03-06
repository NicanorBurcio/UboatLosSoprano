//
//  prologo.swift
//  UBoat
//
//  Created by jorge on 27/01/15.
//  Copyright (c) 2015 Nicanor Burcio Vecino. All rights reserved.
//

import SpriteKit
import AVFoundation




class Prologo: SKScene, SKPhysicsContactDelegate {
    var sonidoSubmarinoAlarm = AVAudioPlayer()
    var fondo = SKSpriteNode()
    var credito = SKSpriteNode()
    let prologo = "Alerta Alerta nos quedamos sin oxigeno.\n Emergemos en zona hostil,preparados para el enfrentamiento."
    let velocidadcre: CGFloat = 2
    
    override func update(currentTime: NSTimeInterval) {
        
        scrollcredito()
    }
    
    override func didMoveToView(view: SKView) {
        
        cargarfondoPrologo()
        reproducirEfectoAudioSubmarinoAlarm()
        
        /*    if   enemigo=1
        {
        }
        */
        llamada()
        
        
    }
    
    func reproducirEfectoAudioSubmarinoAlarm(){
        let ubicacionAudioAudioSubmarinoAlarm = NSBundle.mainBundle().pathForResource("SubmarineAlarm", ofType: "mp3")
        var efectoSubmarinoAlarm = NSURL(fileURLWithPath: ubicacionAudioAudioSubmarinoAlarm!)
        sonidoSubmarinoAlarm = AVAudioPlayer(contentsOfURL: efectoSubmarinoAlarm, error: nil)
        sonidoSubmarinoAlarm.prepareToPlay()
        sonidoSubmarinoAlarm.numberOfLoops = 1
        sonidoSubmarinoAlarm.play()
        sonidoSubmarinoAlarm.volume = 0.02
    }

    func cargarfondoPrologo() {
        
        fondo = SKSpriteNode(imageNamed: "FondoPrologo")
        fondo.position = CGPoint(x: size.width / 2 , y: size.height / 2)
        fondo.size = self.size
        addChild(fondo)
        
        let controlDamageSequence2 = SKAction.sequence([
            SKAction.colorizeWithColor(SKColor.redColor(), colorBlendFactor: 1, duration: 0.5),
            SKAction.waitForDuration(0.5),
            SKAction.colorizeWithColor(SKColor.redColor(), colorBlendFactor: 0, duration: 0.5),
            ])
        let controlDamage2 = SKAction.repeatActionForever(controlDamageSequence2)
     
        fondo.runAction(controlDamage2, withKey: "tocado")
        
        
        credito = SKSpriteNode(imageNamed: "presentacionPrologo")
        credito.setScale(0.9)
        credito.anchorPoint = CGPointMake(0, 0)
        credito.position = CGPointMake(70, 40)
        
        credito.runAction(controlDamage2, withKey: "tocado")
        
        //   credito.setScale(0.9)
        credito.zPosition = 1
        //    credito.position = CGPointMake(self.position.x + 190, self.position.y + 190)
        // credito.alpha = 0.5
        //credito.constraints = [Juego.constraint]
        credito.name = "creditos"
        addChild(credito)
        
        
    }
    
    func llamada() {
        
        /*       let UITextView = SKLabelNode(fontNamed: "Avenir")
        
        UITextView.text = prologo
        UITextView.fontColor = UIColor.blackColor()
        UITextView.frame.size.height / 20
        //self.frame.height / 2
        //self.frame.width ; 10
        UITextView.fontSize = 25
        
        //UITextView.position = CGPoint(x: size.width  - 50, y: size.height / 3)
        UITextView.name = "caja_prologo"
        addChild(UITextView)
        */
        /*     let label = SKLabelNode(fontNamed: "Avenir")
        label.text = prologo
        label.fontColor = UIColor.blackColor()
        label.fontSize = 30
        label.position = CGPoint(x: size.width / 2 - 50, y: size.height / 2)
        label.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame) )
        label.name = "prologo"
        addChild(label)
        */ //  Juego.escena volverMenu()
        
        
        //llamamos ejecutamos la secuencia para que cambie solo a la pantalla de juego
        runAction(SKAction.sequence([
            SKAction.waitForDuration(5.0),
            SKAction.runBlock() {
                
                let aparecer = SKTransition.crossFadeWithDuration(1.5)
        
                let pantalla = Juego(size: self.size)
                self.view?.presentScene(pantalla, transition: aparecer)
            }
            
            ]))
        
        //  var moveLabel = SKAction.self; moveByX;: 0 y: 30 duration: 2
        //SKAction * moveLabel = SKAction (moveByX:0.0, y: 30.0, duration: 1,2))
        
        //label runAction : moveLabel
        
        
        
    }
    
    func scrollcredito() {
        
        self.enumerateChildNodesWithName("prologo", usingBlock: { (nodo, stop) -> Void in
            if let credito = nodo as? SKSpriteNode {
                println("la crecido posicion x + credito.posicion.y")
                credito.position = CGPoint(
                    x: credito.position.x - self.velocidadcre,
                    y: credito.position.y)
                
                if credito.position.x <= -credito.size.width {
                    
                    credito.position = CGPointMake(
                        credito.position.x + credito.size.width * 2,
                        credito.position.y)
                }
            }
        })
        
    }
    
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        let tocarLabel: AnyObject = touches.anyObject()!
        
        let posicionTocar = tocarLabel.locationInNode(self)
        
        let loQueTocamos = self.nodeAtPoint(posicionTocar)
        
        if loQueTocamos.name == "Cambiar"  {
            
            let transicion = SKTransition.revealWithDirection(SKTransitionDirection.Left, duration: 0.5)
            
            let  aparecerEscena = Prologo (size: self.size)
            
            aparecerEscena.scaleMode = SKSceneScaleMode.AspectFill
            
            self.scene?.view?.presentScene(aparecerEscena, transition: transicion)
        }
        
    }
    
    
    
    
}