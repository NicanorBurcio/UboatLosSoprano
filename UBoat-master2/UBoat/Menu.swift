//
//  Menu.swift
//  UBoat LEX
//
//  Created by Berganza on 16/12/2014.
//  Copyright (c) 2014 Berganza. All rights reserved.
//

import SpriteKit



class Menu: SKScene {

        
    var vidas: Int = 5
    let vidasRestantes = SKLabelNode()
    var fondo = SKSpriteNode()
    var submarine = SKSpriteNode()
    
    

    override func didMoveToView(view: SKView) {
        
        imagenPeriscopio()
        llamada()
        continuar()
        vidasTotales()
        submarineDamage()
    }
    
    
    func imagenPeriscopio() {
        
        fondo = SKSpriteNode(imageNamed: "periscopio")
        fondo.position = CGPoint(x: size.width / 2 , y: size.height / 2)
        fondo.size = self.size
        addChild(fondo)
        
        
        
    }
    
    
    
    func llamada() {
     
        let label = SKLabelNode(fontNamed: "Avenir")
        
        if vidas == 5  {
            
            label.text = "Jugar"
            label.fontColor = UIColor.blackColor()
            label.fontSize = 30
            label.position = CGPoint(x: size.width / 2 - 50, y: size.height / 2)
            label.name = "Cambiar"
            addChild(label)
        }
        
        else if  vidas == 0 {
            label.text = "Volver a Jugar"
            label.fontColor = UIColor.blackColor()
            label.fontSize = 30
            label.position = CGPoint(x: size.width / 2 - 100, y: size.height / 2)
            label.name = "Cambiar"
            addChild(label)
        }
    }
    
    func continuar() {
        
        let continuarLabel = SKLabelNode(fontNamed: "Avenir")
        
         if vidas == 1 || vidas == 2 || vidas == 3 || vidas == 4 {
        
            continuarLabel.text = "Continuar"
            continuarLabel.fontColor = UIColor.blackColor()
            continuarLabel.fontSize = 30
            continuarLabel.position = CGPoint(x: size.width / 2 + 220, y: size.height / 2)
            continuarLabel.name = "Continuar"
            addChild(continuarLabel)
        }
        
}
    
    func vidasTotales() {
        
        
        let vidasRestantes = SKLabelNode(fontNamed: "Avenir")
        vidasRestantes.fontColor = UIColor.blackColor()
        vidasRestantes.fontSize = 20
        vidasRestantes.position = CGPoint(x: 390 , y: 29)
        vidasRestantes.name = "VidasRestantes"
        
        if vidas != 0 {
            vidasRestantes.text = "Impactos restantes: " + "\(vidas)"
        }
                else {
            vidasRestantes.text = "Submarino hundido "
            }
            addChild(vidasRestantes)

   }
    
    func submarineDamage() {
        if vidas == 5 {
            submarine = SKSpriteNode(imageNamed: "UBoatNoDamage")
            submarine.position = CGPoint(x: 150 , y: 50)
            submarine.zPosition = 1
            submarine.setScale(0.50)
            addChild(submarine)
            
            
        }
            
            else if vidas == 4 {
                submarine = SKSpriteNode(imageNamed: "UBoatDamage1")
                submarine.position = CGPoint(x: 150 , y: 50)
                submarine.zPosition = 1
                submarine.setScale(0.50)
                addChild(submarine)
            
        
        }
        
            else if vidas == 3 {
                submarine = SKSpriteNode(imageNamed: "UBoatDamage2")
                submarine.position = CGPoint(x: 150 , y: 50)
                submarine.zPosition = 1
                submarine.setScale(0.50)
                addChild(submarine)
            
            
        }

            else if vidas == 2 {
                submarine = SKSpriteNode(imageNamed: "UBoatDamage3")
                submarine.position = CGPoint(x: 150 , y: 50)
                submarine.zPosition = 1
                submarine.setScale(0.50)
                addChild(submarine)
            
            
        }

            else if vidas == 1 {
                submarine = SKSpriteNode(imageNamed: "UBoatTotalDamage")
                submarine.position = CGPoint(x: 150 , y: 50)
                submarine.zPosition = 1
                submarine.setScale(0.50)
                addChild(submarine)
            
            
        }
        
            else if vidas == 0 {
                submarine = SKSpriteNode(imageNamed: "UBoatSunk")
                submarine.position = CGPoint(x: 150 , y: 50)
                submarine.zPosition = 1
                submarine.setScale(0.50)
                addChild(submarine)
            
    
        }
    }
        override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        let tocarLabel: AnyObject = touches.anyObject()!
        
        let posicionTocar = tocarLabel.locationInNode(self)
        
        let loQueTocamos = self.nodeAtPoint(posicionTocar)
        
        if loQueTocamos.name == "Cambiar" && (vidas == 0) || (vidas == 5) {
            
            let transicion = SKTransition.revealWithDirection(SKTransitionDirection.Left, duration: 2)
            
            let  aparecerEscena = Juego(size: self.size)
            
            aparecerEscena.scaleMode = SKSceneScaleMode.AspectFill
            
            self.scene?.view?.presentScene(aparecerEscena, transition: transicion)
        }

    
    
               
            else if loQueTocamos.name == "Continuar" && (vidas != 0) || (vidas != 5) {
                let transicion = SKTransition.revealWithDirection(SKTransitionDirection.Left, duration: 2)
                
                let  aparecerEscena = Juego(size: self.size)
                
                aparecerEscena.scaleMode = SKSceneScaleMode.AspectFill
                
                self.scene?.view?.presentScene(aparecerEscena, transition: transicion)
            
        }
        
        
        
        
        
    }
    
    
    
    
    
    
    
    


}

