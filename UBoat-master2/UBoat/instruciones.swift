//
//  instruciones.swift
//  UBoat
//
//  Created by jorge on 16/02/15.
//  Copyright (c) 2015 Nicanor Burcio Vecino. All rights reserved.
//

import SpriteKit
import UIKit
import AVFoundation

class instruciones : Juego   {
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
        label.text = "Instruciones del Juego"
        label.fontSize = 20
        label.position = CGPoint(x: size.width / 2 - 100, y: size.height - 50)
        label.name = "Cambiar"
        label.zPosition = 1
        addChild(label)
        
        var btnmenu =  SKLabelNode(fontNamed: "HelveticaNeue-CondensedBlack")
        btnmenu.fontColor = UIColor.blackColor()
        btnmenu.text="Menu Principal"
        btnmenu.fontSize = 12
        btnmenu.name = "menu"
        btnmenu.position = CGPoint(x: (label.position.x / 2 + 100), y: label.position.y / 2)
        
        
        addChild(btnmenu)
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        let tocarLabel: AnyObject = touches.anyObject()!
        
        let posicionTocar = tocarLabel.locationInNode(self)
        
        let loQueTocamos = self.nodeAtPoint(posicionTocar)
        
        if loQueTocamos.name == "menu"  {
            
            let transicion = SKTransition.revealWithDirection(SKTransitionDirection.Left, duration: 0.5)
            
            let  aparecerEscena = Menu(size: self.size)
            
            aparecerEscena.scaleMode = SKSceneScaleMode.AspectFill
            
            self.scene?.view?.presentScene(aparecerEscena, transition: transicion)
        }
        
        
    }
    
    
    
}
