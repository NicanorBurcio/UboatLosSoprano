//
//  puntuaciones.swift
//  UBoat
//
//  Created by jorge on 27/01/15.
//  Copyright (c) 2015 Nicanor Burcio Vecino. All rights reserved.
//

import SpriteKit
import UIKit
import AVFoundation

class marca : Juego   {
    //puntuacionesmarcadores
    
    var letra  = SKSpriteNode()
    
    override func didMoveToView(view: SKView) {
        
        imagenPeriscopio()
        pintado()
        mostrarFondoPapel()
        
    }
    
 override   func mostrarFondoPapel() {
        
        letra = SKSpriteNode(imageNamed: "papel")
        letra.setScale(1)
        letra.zPosition = 6
        letra.position = CGPointMake(self.size.width / 2, self.frame.height / 14)
    
        addChild(letra)
        
    }
    
    
    func imagenPeriscopio() {
        
        fondo = SKSpriteNode(imageNamed: "periscopio")
        fondo.position = CGPoint(x: size.width / 2 , y: size.height / 2)
        fondo.size = self.size
        addChild(fondo)
        
    }
    func pintado (){
        
        var score : Juego!
        let label = SKLabelNode( fontNamed: "HelveticaNeue-CondensedBlack")
        label.fontColor = UIColor.blackColor()
        // label.text = "\(score.contadorImpactosLabel)"
        label.text = "Puntuanciones del Juego"
        label.fontSize = 20
        label.position = CGPoint(x: size.width / 2 - 100, y: size.height - 50)
        label.name = "Cambiar"
        label.zPosition = 1
        addChild(label)
        var boton =  SKLabelNode(fontNamed: "Avenir")
        boton.fontColor = UIColor.blackColor()
        boton.text="Probar de Nuevo"
        boton.fontSize = 12
        boton.name = "reiniciar"
        boton.position = CGPoint(x: label.position.x / 2, y: label.position.y / 2)
        //boton.position = CGPoint(x: size.width / 2  , y: size.height )
        addChild(boton)
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        let tocarLabel: AnyObject = touches.anyObject()!
        
        let posicionTocar = tocarLabel.locationInNode(self)
        
        let loQueTocamos = self.nodeAtPoint(posicionTocar)
        
        if loQueTocamos.name == "reiniciar"  {
            
            let transicion = SKTransition.revealWithDirection(SKTransitionDirection.Left, duration: 0.5)
            
            let  aparecerEscena = Juego(size: self.size)
            
            aparecerEscena.scaleMode = SKSceneScaleMode.AspectFill
            
            self.scene?.view?.presentScene(aparecerEscena, transition: transicion)
        }
        
    }

    
    
}