//
//  ViewController.swift
//  art2
//
//  Created by Vcvc on 2021/4/8.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var styleButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    var trackingStatus: String = ""
    var focusNode: SCNNode!
    var diceNodes: [SCNNode] = []
    var diceCount: Int = 1
    var diceStyle: Int = 0
    var diceOffset: [SCNVector3] = [SCNVector3(0.0,0.0,0.0),
                                    SCNVector3(-0.05, 0.00, 0.0),
                                    SCNVector3(0.05, 0.00, 0.0),
                                    SCNVector3(-0.05, 0.05, 0.02),
                                    SCNVector3(0.05, 0.05, 0.02)]
    
    @IBAction func startButtonPressed(_ sender: Any) {
    }
    
    @IBAction func resetButtonPressed(_ sender: Any) {
    }
    
    @IBAction func swipeUpGestureHandler(_ sender: Any) {
        // 1
        guard let frame = self.sceneView.session.currentFrame else { return }
        // 2
        for count in 0..<diceCount {
            throwDiceNode(transform: SCNMatrix4(frame.camera.transform),
                          offset: diceOffset[count])
        }
    }
    
    @IBAction func styleButtonPressed(_ sender: Any) {
        diceStyle = diceStyle >= 4 ? 0 : diceStyle + 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initSceneView()
        self.initScene()
        self.initARSession()
        self.loadModels()
        
        
        /*
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        //let scene = SCNScene(named: "art.scnassets/ship.scn")!
        let scene = SCNScene()
        scene.lightingEnvironment.contents = "art.scnassets/Textures/Environment_cube.jpg"
        scene.lightingEnvironment.intensity = 2
        
        
        // Set the scene to the view
        sceneView.scene = scene
 */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
   
    func initSceneView() {
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.debugOptions = [
            ARSCNDebugOptions.showFeaturePoints,
            //ARSCNDebugOptions.showWorldOrigin, //轴
            //SCNDebugOptions.showBoundingBoxes,
            SCNDebugOptions.showWireframe
        ]
    }
    
    func initARSession() {
        guard ARWorldTrackingConfiguration.isSupported else {
            print("*** ARConfig: AR World Tracking Not Supported")
            return
        }
        
        let config = ARWorldTrackingConfiguration()
        config.worldAlignment = .gravity
        config.providesAudioData = false
        sceneView.session.run(config)
    }
    
    func loadModels() {
        // 1
        let diceScene = SCNScene(
            named: "art.scnassets/DiceScene.scn")!
        // 2
        for count in 0..<5 {
            // 3
            diceNodes.append(diceScene.rootNode.childNode(
                withName: "d\(count)",
                recursively: false)!)
        }
        
        
        let focusScene = SCNScene(
            named: "art.scnassets/Models/FocusScene.scn")!
        focusNode = focusScene.rootNode.childNode(
            withName: "focus", recursively: false)!
        
        sceneView.scene.rootNode.addChildNode(focusNode)
        
    }
    
    func initScene() {
        let scene = SCNScene()
        scene.isPaused = false
        sceneView.scene = scene
        scene.lightingEnvironment.contents = "ARResource.scnassets/Textures/Environment_cube.jpg"
        scene.lightingEnvironment.intensity = 2
    }
    
    func throwDiceNode(transform: SCNMatrix4, offset: SCNVector3) {
        // 1
        let position = SCNVector3(transform.m41 + offset.x,
                                  transform.m42 + offset.y,
                                  transform.m43 + offset.z)
        // 2
        let diceNode = diceNodes[diceStyle].clone()
        diceNode.name = "dice"
        diceNode.position = position
        //3
        sceneView.scene.rootNode.addChildNode(diceNode)
        //diceCount -= 1
    }
    
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
