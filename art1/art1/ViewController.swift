//
//  ViewController.swift
//  art1
//
//  Created by Vcvc on 2021/4/3.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    var trackingStatus: String = ""

    // MARK: - Outlets
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var styleButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!

   // MARK: - Actions
   @IBAction func startButtonPressed(_ sender: Any) {
   }

   @IBAction func styleButtonPressed(_ sender: Any) {
   }

   @IBAction func resetButtonPressed(_ sender: Any) {
   }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initSceneView()
        self.initScene()
        self.initARSession()
        //self.loadModels()
    }

    func initScene(){
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "vcvc.scnassets/SimpleScene.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
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
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        switch camera.trackingState {
            // 1
            case .notAvailable:
                trackingStatus = "Tacking:  Not available!"
            // 2
            case .normal:
                trackingStatus = "Tracking: All Good!"
            // 3
            case .limited(let reason):
                switch reason {
                case .excessiveMotion:
                    trackingStatus = "Tracking: Limited due to excessive motion!"
                // 3.1
                case .insufficientFeatures:
                    trackingStatus = "Tracking: Limited due to insufficient features!"
                // 3.2
                case .initializing:
                    trackingStatus = "Tracking: Initializing..."
                // 3.3
                case .relocalizing:
                    trackingStatus = "Tracking: Relocalizing..."
                }
            }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        trackingStatus = "AR Session Failure: \(error)"
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        trackingStatus = "AR Session Was Interrupted!"
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        trackingStatus = "AR Session Interruption Ended"

    }

    func initARSession(){
        guard ARWorldTrackingConfiguration.isSupported else {
            print("*** ARConfig: AR World Tracking Not Supported")
            return
        }
        
        let config = ARWorldTrackingConfiguration()
        config.worldAlignment = .gravity
        config.providesAudioData = false
        
        sceneView.session.run(config)
    }
    
    func renderer(_ renderer: SCNSceneRenderer,
                  updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            //self.statusLabel.text = self.trackingStatus
            print(self.trackingStatus)
         }
    }
    
    func initSceneView() {
            sceneView.delegate = self
            sceneView.showsStatistics = true
            sceneView.debugOptions = [
                ARSCNDebugOptions.showFeaturePoints,
                ARSCNDebugOptions.showWorldOrigin,
                SCNDebugOptions.showBoundingBoxes,
                SCNDebugOptions.showWireframe
            ]
    }
}
