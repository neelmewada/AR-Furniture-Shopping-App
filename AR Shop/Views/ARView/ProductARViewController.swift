//
//  ProductARViewController.swift
//  AR Shop
//
//  Created by Neel Mewada on 15/04/21.
//

import UIKit
import SceneKit
import ARKit

class ProductARViewController: UIViewController, ARSCNViewDelegate {
    // MARK: - Lifecycle
    
    init(_ productId: String?) {
        self.viewModel = ProductARViewModel(productId)
        super.init(nibName: nil, bundle: nil)
        viewModel.setUpdateCallback(self.viewModelDidChange)
        configureViewController()
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = ProductARViewModel("")
        super.init(coder: coder)
        viewModel.setUpdateCallback(self.viewModelDidChange)
        configureViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        view.addSubview(sceneView)
        sceneView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
        
        sceneView.delegate = self
        
        sceneView.debugOptions = []//[.showFeaturePoints]
        sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.environmentTexturing = .automatic
        
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func viewModelDidChange() {
        print("ProductARViewModel changed!")
        print("Download Finished = \(viewModel.isModelLoaded)")
        loadingView.isHidden = viewModel.isModelLoaded
    }
    
    // MARK: - Properties
    
    private let viewModel: ProductARViewModel
    
    private let sceneView = ARSCNView()
    private let coachingView = ARCoachingOverlayView()
    
    private var planeNode: SCNNode?
    
    private var modelNode: SCNNode?
    
    private var spinner: UIActivityIndicatorView? = nil
    
    private lazy var loadingView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.effect = UIBlurEffect(style: .light)
        view.layer.cornerRadius = 10.0
        view.clipsToBounds = true
        self.spinner = UIActivityIndicatorView(style: .large)
        spinner!.color = .darkGray
        view.contentView.addSubview(spinner!)
        spinner!.center(inView: view.contentView)
        spinner!.setDimensions(height: 40, width: 40)
        return view
    }()
    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchor = anchor as? ARPlaneAnchor {
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            
            if planeNode != nil { // if another planeNode already exists
                planeNode?.removeFromParentNode()
            }
            
            planeNode = SCNNode()
            planeNode?.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
            planeNode?.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
            
            let gridMaterial = SCNMaterial()
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            plane.materials = [gridMaterial]
            
            planeNode?.geometry = plane
            node.addChildNode(planeNode!)
            planeNode?.isHidden = true
        }
    }
    
    // MARK: - Actions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !viewModel.isModelLoaded {
            return
        }
        
        guard let sceneFileUrl = viewModel.sceneFileUrl else { return }
        guard let touch = touches.first else { return }
        
        let touchLocation = touch.location(in: sceneView)
        
        guard let query = sceneView.raycastQuery(from: touchLocation, allowing: .existingPlaneGeometry, alignment: .horizontal) else {
            print("[ARView] Query Invalid")
            return
        }
        
        let results = sceneView.session.raycast(query)
        guard let hitTestResult = results.first else {
            print("No surfaces found")
            return
        }
        
        var modelScene: SCNScene
        
        do {
            modelScene = try SCNScene(url: sceneFileUrl)
        } catch let error {
            print("Error loading modelScene from sceneFileUrl: \(sceneFileUrl.path)")
            print(error)
            return
        }
        
        //let modelScene = SCNScene(named: "art.scnassets/chair_swan.scn")!
        
        if let modelNode = modelScene.rootNode.childNode(withName: "Parent", recursively: true) {
            
            modelNode.position = SCNVector3(hitTestResult.worldTransform.columns.3.x,
                                            hitTestResult.worldTransform.columns.3.y,// + diceNode.boundingBox.max.y / 2 * diceNode.scale.y,
                                            hitTestResult.worldTransform.columns.3.z)
            var i = 0
            for textureUrl in viewModel.textureUrls {
                do {
                    let data = try Data(contentsOf: textureUrl)
                    let texture = UIImage(data: data)
                    modelNode.childNodes.filter({ $0.name == "Mat\(i)" }).forEach { node in
                        let firstMat = node.geometry?.materials.first
                        firstMat?.diffuse.contents = texture
                    }
                } catch let error {
                    print("Error loading texture at \(i). \(error)")
                    i += 1
                    continue
                }
                i += 1
            }
            
            sceneView.scene.rootNode.addChildNode(modelNode)
            self.modelNode = modelNode
        }
    }
    
    // MARK: - Helpers
    
    private func configureViewController() {
        view.addSubview(loadingView)
        loadingView.center(inView: view)
        loadingView.setDimensions(height: 120, width: 120)
        loadingView.isHidden = viewModel.isModelLoaded
        if !loadingView.isHidden {
            spinner?.startAnimating()
        }
    }
}
