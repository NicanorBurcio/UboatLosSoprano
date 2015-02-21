//
//  submarino.swift
//  UBoat
//
//  Created by David Rodriguez Marin on 28/1/15.
//  Copyright (c) 2015 Nicanor Burcio Vecino. All rights reserved.
//

import Foundation
import SpriteKit


class Submarino : SKNode {
    
    // Definiciones
    var submarino               = SKSpriteNode()
    let medidasSubmarino        = CGSize(width:30, height:16)
    let nombreSubmarino         = "heroe"
    let tiempoentreframes       = 0.08
    let constraint              = SKConstraint.zRotation(SKRange(constantValue: 0))
//    var submarinoAtlas          = SKTextureAtlas(named: "SubNavegando.atlas")
//    var submarinoEmergeAtlas    = SKTextureAtlas(named: "SubEmerge.atlas")
    var moverArriba             = SKAction.moveByX(0, y: 10, duration: 0.1)
    var moverABajo              = SKAction.moveByX(0, y: -10, duration: 0.1)
    
    enum tiposestela {
        case izq
        case der
        
        static var count: Int { return tiposestela.der.hashValue + 1}
    }
    
    func crearSubmarino()->SKSpriteNode{
        var submarino = SKSpriteNode(imageNamed: "Emerge-0002")
        submarino.setScale(0.60)
        submarino.zPosition        = 4
        submarino.position 		= CGPointMake(submarino.size.width - 55, 200)
        submarino.constraints      = [constraint]
        submarino.name 			= nombreSubmarino
        
        
        
        // Configurar estela
        //        for(var estelanum = 1; estelanum < tiposestela.count; estelanum++){
        //            estela = crearEstela(estelanum)
        //            submarino.addChild(estela)
        //        }
//        submarino.addChild(crearEstela(tiposestela.izq))
//        submarino.addChild(crearEstela(tiposestela.der))
        //crearAtlas()
        return submarino
    }
    
    func crearEstela(estela: tiposestela) -> SKEmitterNode{
        var estelaSubmarino = SKEmitterNode()
        switch(estela) {
        case .izq:
            estelaSubmarino = SKEmitterNode(fileNamed: "estelaSubIzq.sks")
            estelaSubmarino.zPosition 	= 0
            estelaSubmarino.alpha 		= 1
            estelaSubmarino.setScale(0.24)
            estelaSubmarino.position 	= CGPointMake(23, -16)
        case .der:
            estelaSubmarino = SKEmitterNode(fileNamed: "estelaSubDer.sks")
            estelaSubmarino.zPosition = -1
            estelaSubmarino.alpha = 1
            estelaSubmarino.setScale(0.22)
            estelaSubmarino.position = CGPointMake(23, -7)
        }
        return estelaSubmarino;
    }
    
    func getAtlas()->SKAction{
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
        
        var animacionSubmarinoEmerge = SKAction.animateWithTextures([texturaSubmarinoEmergeA, texturaSubmarinoEmergeA, texturaSubmarinoEmerge0, texturaSubmarinoEmerge0, texturaSubmarinoEmerge1, texturaSubmarinoEmerge2, texturaSubmarinoEmerge3, texturaSubmarinoEmerge4, texturaSubmarinoEmerge5, texturaSubmarinoEmerge6, texturaSubmarinoEmerge7, texturaSubmarinoEmerge8, texturaSubmarinoEmerge9, texturaSubmarinoEmerge10, texturaSubmarinoEmerge11, texturaSubmarinoEmerge12, texturaSubmarinoEmerge13, texturaSubmarinoEmerge14, texturaSubmarinoEmerge15, texturaSubmarinoEmerge16, texturaSubmarinoEmerge17, texturaSubmarinoEmerge18, texturaSubmarinoEmerge19, texturaSubmarinoEmerge20, texturaSubmarinoEmerge21, texturaSubmarinoEmerge22, texturaSubmarinoEmerge23, texturaSubmarinoEmerge24], timePerFrame: 0.14)
        var accionSubmarinoEmerge = SKAction.repeatAction(animacionSubmarinoEmerge, count: 1)
        
        //SubmarinoNavegando
        
        var texturaSubmarinoNavegando1 = SKTexture(imageNamed: "Navegando0024")
        texturaSubmarinoNavegando1.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoNavegando2 = SKTexture(imageNamed: "Navegando0025")
        texturaSubmarinoNavegando2.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoNavegando3 = SKTexture(imageNamed: "Navegando0026")
        texturaSubmarinoNavegando3.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoNavegando4 = SKTexture(imageNamed: "Navegando0027")
        texturaSubmarinoNavegando4.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoNavegando5 = SKTexture(imageNamed: "Navegando0028")
        texturaSubmarinoNavegando5.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoNavegando6 = SKTexture(imageNamed: "Navegando0029")
        texturaSubmarinoNavegando6.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoNavegando7 = SKTexture(imageNamed: "Navegando0030")
        texturaSubmarinoNavegando7.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoNavegando8 = SKTexture(imageNamed: "Navegando0031")
        texturaSubmarinoNavegando8.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoNavegando9 = SKTexture(imageNamed: "Navegando0032")
        texturaSubmarinoNavegando9.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoNavegando10 = SKTexture(imageNamed: "Navegando0033")
        texturaSubmarinoNavegando10.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoNavegando11 = SKTexture(imageNamed: "Navegando0034")
        texturaSubmarinoNavegando11.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoNavegando12 = SKTexture(imageNamed: "Navegando0035")
        texturaSubmarinoNavegando12.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoNavegando13 = SKTexture(imageNamed: "Navegando0036")
        texturaSubmarinoNavegando13.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoNavegando14 = SKTexture(imageNamed: "Navegando0037")
        texturaSubmarinoNavegando14.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoNavegando15 = SKTexture(imageNamed: "Navegando0038")
        texturaSubmarinoNavegando15.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoNavegando16 = SKTexture(imageNamed: "Navegando0039")
        texturaSubmarinoNavegando16.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoNavegando17 = SKTexture(imageNamed: "Navegando0040")
        texturaSubmarinoNavegando17.filteringMode = SKTextureFilteringMode.Nearest
        
        var animacionSubmarinoNavega = SKAction.animateWithTextures([texturaSubmarinoNavegando1, texturaSubmarinoNavegando2, texturaSubmarinoNavegando3, texturaSubmarinoNavegando4, texturaSubmarinoNavegando5, texturaSubmarinoNavegando6, texturaSubmarinoNavegando7, texturaSubmarinoNavegando8, texturaSubmarinoNavegando9, texturaSubmarinoNavegando10, texturaSubmarinoNavegando11, texturaSubmarinoNavegando12, texturaSubmarinoNavegando13, texturaSubmarinoNavegando14, texturaSubmarinoNavegando15, texturaSubmarinoNavegando16, texturaSubmarinoNavegando17], timePerFrame: 0.09)
        var accionSubmarinoNavega = SKAction.repeatActionForever(animacionSubmarinoNavega)
        var controlSubmarinoEmergiendoNavegando = SKAction.sequence([accionSubmarinoEmerge, accionSubmarinoNavega])
        return controlSubmarinoEmergiendoNavegando
    }
    
    
    func submarinoInmersion()->SKAction{
        
//        var texturaSubmarinoEmergeA = SKTexture(imageNamed: "Emerge-0002")
//        texturaSubmarinoEmergeA.filteringMode = SKTextureFilteringMode.Nearest
//        var texturaSubmarinoEmerge0 = SKTexture(imageNamed: "Emerge-0001")
//        texturaSubmarinoEmerge0.filteringMode = SKTextureFilteringMode.Nearest
        
        
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
        
        
        var animacionSubmarinoInmersion = SKAction.animateWithTextures([texturaSubmarinoEmerge6,texturaSubmarinoEmerge5, texturaSubmarinoEmerge4, texturaSubmarinoEmerge3, texturaSubmarinoEmerge2, texturaSubmarinoEmerge1, texturaSubmarinoEmerge1,texturaSubmarinoEmerge1,texturaSubmarinoEmerge1, texturaSubmarinoEmerge1, texturaSubmarinoEmerge1, texturaSubmarinoEmerge1, texturaSubmarinoEmerge1, texturaSubmarinoEmerge1, texturaSubmarinoEmerge1, texturaSubmarinoEmerge1, texturaSubmarinoEmerge2, texturaSubmarinoEmerge3, texturaSubmarinoEmerge4, texturaSubmarinoEmerge5, texturaSubmarinoEmerge6, texturaSubmarinoEmerge7, texturaSubmarinoEmerge8, texturaSubmarinoEmerge9], timePerFrame: 0.5)
        var accionSubmarinoInmersion = SKAction.repeatAction(animacionSubmarinoInmersion, count: 1)
        
        //SubmarinoNavegando
        
        var texturaSubmarinoNavegando1 = SKTexture(imageNamed: "Navegando0024")
        texturaSubmarinoNavegando1.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoNavegando2 = SKTexture(imageNamed: "Navegando0025")
        texturaSubmarinoNavegando2.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoNavegando3 = SKTexture(imageNamed: "Navegando0026")
        texturaSubmarinoNavegando3.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoNavegando4 = SKTexture(imageNamed: "Navegando0027")
        texturaSubmarinoNavegando4.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoNavegando5 = SKTexture(imageNamed: "Navegando0028")
        texturaSubmarinoNavegando5.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoNavegando6 = SKTexture(imageNamed: "Navegando0029")
        texturaSubmarinoNavegando6.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoNavegando7 = SKTexture(imageNamed: "Navegando0030")
        texturaSubmarinoNavegando7.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoNavegando8 = SKTexture(imageNamed: "Navegando0031")
        texturaSubmarinoNavegando8.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoNavegando9 = SKTexture(imageNamed: "Navegando0032")
        texturaSubmarinoNavegando9.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoNavegando10 = SKTexture(imageNamed: "Navegando0033")
        texturaSubmarinoNavegando10.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoNavegando11 = SKTexture(imageNamed: "Navegando0034")
        texturaSubmarinoNavegando11.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoNavegando12 = SKTexture(imageNamed: "Navegando0035")
        texturaSubmarinoNavegando12.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoNavegando13 = SKTexture(imageNamed: "Navegando0036")
        texturaSubmarinoNavegando13.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoNavegando14 = SKTexture(imageNamed: "Navegando0037")
        texturaSubmarinoNavegando14.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoNavegando15 = SKTexture(imageNamed: "Navegando0038")
        texturaSubmarinoNavegando15.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoNavegando16 = SKTexture(imageNamed: "Navegando0039")
        texturaSubmarinoNavegando16.filteringMode = SKTextureFilteringMode.Nearest
        var texturaSubmarinoNavegando17 = SKTexture(imageNamed: "Navegando0040")
        texturaSubmarinoNavegando17.filteringMode = SKTextureFilteringMode.Nearest
        
        var animacionSubmarinoNavega = SKAction.animateWithTextures([texturaSubmarinoNavegando1, texturaSubmarinoNavegando2, texturaSubmarinoNavegando3, texturaSubmarinoNavegando4, texturaSubmarinoNavegando5, texturaSubmarinoNavegando6, texturaSubmarinoNavegando7, texturaSubmarinoNavegando8, texturaSubmarinoNavegando9, texturaSubmarinoNavegando10, texturaSubmarinoNavegando11, texturaSubmarinoNavegando12, texturaSubmarinoNavegando13, texturaSubmarinoNavegando14, texturaSubmarinoNavegando15, texturaSubmarinoNavegando16, texturaSubmarinoNavegando17], timePerFrame: 0.09)
        var accionSubmarinoNavega = SKAction.repeatActionForever(animacionSubmarinoNavega)
        var controlSubmarinoInmersionNavegando = SKAction.sequence([accionSubmarinoInmersion, accionSubmarinoNavega])
        return controlSubmarinoInmersionNavegando    }

    
    
    func fisicas(){
    }
    
    //    func addToScene(escena: SKScene) {
    //        self.crearSubmarino()
    //        self.crearAtlas()
    //        escena.addChild(submarino)
    //    }
    
    func getSize() -> CGSize{
        return submarino.size
    }
    
    
}
