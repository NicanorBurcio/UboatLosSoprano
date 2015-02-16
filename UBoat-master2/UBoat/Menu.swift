//
//  Menu.swift
//  UBoat LEX
//
//  Created by Berganza on 16/12/2014.
//  Copyright (c) 2014 Berganza. All rights reserved.
//

import SpriteKit



    class Menu: SKScene {

        var fondo = SKSpriteNode()
    

    
    
    override func didMoveToView(view: SKView) {
        
        imagenPeriscopio()
        llamada()
       
        
    }
    
    
    func imagenPeriscopio() {
        
        fondo = SKSpriteNode(imageNamed: "periscopio")
        fondo.position = CGPoint(x: size.width / 2 , y: size.height / 2)
        fondo.size = self.size
        addChild(fondo)
        
    }
    
    
    
    func llamada() {
     
        let label = SKLabelNode(fontNamed: "HelveticaNeue-CondensedBlack")
            label.text = "Jugar"
            label.fontColor = UIColor.blackColor()
            label.fontSize = 30
            label.position = CGPoint(x: size.width / 2 - 50, y: size.height / 2)
            label.name = "Cambiar"
        let label1 =  SKLabelNode(fontNamed: "HelveticaNeue-CondensedBlack")
            label1.text = "Ajustes del Juego"
            label1.fontColor = UIColor.blackColor()
            label1.fontSize = 30
            label1.position = CGPoint(x: size.width / 2 - 50, y:  self.size.height / 3)
            label1.name = "ajustesjuego"
        let label2 =  SKLabelNode(fontNamed: "HelveticaNeue-CondensedBlack")
            label2.text = "Puntuaciones"
            label2.fontColor = UIColor.blackColor()
            label2.fontSize = 30
            label2.position = CGPoint(x: size.width / 2 - 50, y: size.height / 4)
            label2.name = "puntuaciones"
        let label3 =  SKLabelNode(fontNamed: "HelveticaNeue-CondensedBlack")
            label3.text = "instruciones de juego"
            label3.fontColor = UIColor.blackColor()
            label3.fontSize = 30
            label3.position = CGPoint(x: size.width / 2 - 50, y: size.height / 5)
            label3.name = "instrucionesjuego"
        
        
            addChild(label)
            addChild(label1)
            addChild(label2)
            addChild(label3)
        
        
    }
    
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        let tocarLabel: AnyObject = touches.anyObject()!
        
        let posicionTocar = tocarLabel.locationInNode(self)
        
        let loQueTocamos = self.nodeAtPoint(posicionTocar)
        
            if loQueTocamos.name == "Cambiar"  {
            
            let transicion = SKTransition.revealWithDirection(SKTransitionDirection.Left, duration: 0.5)
            
            let  aparecerEscena = Prologo(size: self.size)
            
            aparecerEscena.scaleMode = SKSceneScaleMode.AspectFill
            
            self.scene?.view?.presentScene(aparecerEscena, transition: transicion)
        }
            else if loQueTocamos.name == "puntuaciones"  {
                
                let transicion = SKTransition.revealWithDirection(SKTransitionDirection.Left, duration: 0.5)
                
                let  aparecerEscena = marca(size: self.size)
                
                aparecerEscena.scaleMode = SKSceneScaleMode.AspectFill
                
                self.scene?.view?.presentScene(aparecerEscena, transition: transicion)
        }
            else if loQueTocamos.name == "instrucionesjuego"  {
                
                let transicion = SKTransition.revealWithDirection(SKTransitionDirection.Left, duration: 0.5)
                
                let  aparecerEscena = instruciones(size: self.size)
                
                aparecerEscena.scaleMode = SKSceneScaleMode.AspectFill
                
                self.scene?.view?.presentScene(aparecerEscena, transition: transicion)
            }
            else if loQueTocamos.name == "ajustesjuego"  {
                
                let transicion = SKTransition.revealWithDirection(SKTransitionDirection.Left, duration: 0.5)
                
                let  aparecerEscena = ajustes(size: self.size)
                
                aparecerEscena.scaleMode = SKSceneScaleMode.AspectFill
                
                self.scene?.view?.presentScene(aparecerEscena, transition: transicion)
        }



    }
    

}

