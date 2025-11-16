//
//  CMYCube.swift
//  KenatsumuPlayground
//
//  Created by Horik on 16.11.2025.
//

import SwiftUI
import SceneKit

struct CMYCubeView: UIViewRepresentable {
    
    
    // MARK: - UIViewRepresentable Protocol
    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        sceneView.scene = createScene()
        sceneView.allowsCameraControl = true
        sceneView.backgroundColor = UIColor.systemBackground
        return sceneView
    }
    
    func updateUIView(_ scnView: SCNView, context: Context) {}
    
    
    // MARK: - Scene Creation
    private func createScene() -> SCNScene {
        let scene = SCNScene()
        
        // Adding ambient light
        let ambientLight = SCNLight()
        ambientLight.type = .ambient
        ambientLight.color = UIColor.white
        let ambientLightNode = SCNNode()
        ambientLightNode.position = SCNVector3(0, 5, 5) // Positioning the ambient light
        scene.rootNode.addChildNode(ambientLightNode)
        
        // Define materials for each set of cube faces
        let materials = [
            createGlassMaterial(color: .cyan),    // Cyan material
            createGlassMaterial(color: .magenta), // Magenta material
            createGlassMaterial(color: .yellow)   // Yellow material
        ]
        
        // Create a node to hold the cube geometry
        let cubeNode = SCNNode()
        
        // Add the faces to the cube node
        // Front and Back faces (Cyan)
        cubeNode.addChildNode(createFace(material: materials[0], position: SCNVector3(0, 0, -1), rotation: SCNVector4(0, 1, 0, CGFloat.pi)))
        cubeNode.addChildNode(createFace(material: materials[0], position: SCNVector3(0, 0, 1), rotation: SCNVector4(0, 1, 0, 0)))
        
        // Top and Bottom faces (Magenta)
        cubeNode.addChildNode(createFace(material: materials[1], position: SCNVector3(0, 1, 0), rotation: SCNVector4(1, 0, 0, CGFloat.pi / 2)))
        cubeNode.addChildNode(createFace(material: materials[1], position: SCNVector3(0, -1, 0), rotation: SCNVector4(1, 0, 0, -CGFloat.pi / 2)))
        
        // Left and Right faces (Yellow)
        cubeNode.addChildNode(createFace(material: materials[2], position: SCNVector3(-1, 0, 0), rotation: SCNVector4(0, 1, 0, CGFloat.pi / 2)))
        cubeNode.addChildNode(createFace(material: materials[2], position: SCNVector3(1, 0, 0), rotation: SCNVector4(0, 1, 0, -CGFloat.pi / 2)))
        
        // Add the cube node to the scene
        scene.rootNode.addChildNode(cubeNode)
        
        // Set the camera position
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(0, 0, 0)
        scene.rootNode.addChildNode(cameraNode)
        
        let moveAction = SCNAction.move(to: SCNVector3(0, 0, 8), duration: 1.4)
        cameraNode.runAction(moveAction)
        
        // Start the rotation animation
        let rotateAction = SCNAction.rotateBy(x: CGFloat.pi * 0.2, y: CGFloat.pi * 0.2, z: 0, duration: 2.0) // Slow rotation
        let repeatAction = SCNAction.repeatForever(rotateAction)
        cubeNode.runAction(repeatAction) // Apply the rotation action to the cube node
        
        return scene
    }
    
    
    // MARK: - Material Creation
    private func createGlassMaterial(color: UIColor) -> SCNMaterial {
        let material = SCNMaterial()
        material.diffuse.contents = color       // Vivid color with transparency
        material.specular.contents = color      // Strong specular for glass shine
        material.reflective.contents = color    // Reflective surface
        material.fresnelExponent = 1.5          // Fresnel effect for realistic reflections
        material.transparency = 0.6             // Semi-transparent for glass
        material.shininess = 100                // High shininess for glass reflection
        material.isDoubleSided = true           // Render both sides
        material.blendMode = .alpha             // Use alpha blend mode for transparency
        return material
    }
    
    
    // MARK: - Face Creation
    private func createFace(material: SCNMaterial, position: SCNVector3, rotation: SCNVector4) -> SCNNode {
        let faceGeometry = SCNPlane(width: 2, height: 2)  // Fixed size for cube faces
        faceGeometry.materials = [material]               // Apply the material
        
        let faceNode = SCNNode(geometry: faceGeometry)    // Create the node
        faceNode.position = position                      // Set the position
        faceNode.rotation = rotation                      // Set the rotation
        return faceNode
    }
}
