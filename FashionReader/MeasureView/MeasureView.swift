//
//  Mesure.swift
//  FRSample
//
//  Created by cmStudent on 2023/02/16.
//

import SwiftUI
import ARKit
import SceneKit
import UIKit

struct MeasureView: View {
    @State var a: Double = 0.0
    @Binding var arrayResult: [Double]
    @State var result: Double = 0.0
    @State var selectNum = 0
    @State var isAlert = false
    @Binding var sizeCount: Int
    @Binding var isButton: Bool
    @Environment(\.presentationMode) var presentation
    var sizeCat: [String]
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                }
                ZStack {
                    MeasureViewRep(result: $result)
                    
                    Text("\(result)")
                        .position(x: 10002, y: -30000)
                        .onChange(of: result) { newValue in
                            arrayResult[selectNum] = newValue
                        }
                        .onChange(of: sizeCount) { newValue in
                            arrayResult = Array (repeating: 0.0, count: newValue)
                        }
                }
                
                ScrollView(.horizontal) {
                    HStack{
                        ForEach(1..<arrayResult.count) { num in
                            Button {
                                selectNum = num - 1
                                isButton = false
                            } label: {
                                ZStack{
                                    Rectangle()
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(10)
                                        .foregroundColor(selectNum == num - 1 ? Color("MainColor") : .gray.opacity(0.7))
                                    Text("\(sizeCat[num - 1])")
                                        .foregroundColor(selectNum == num - 1 ? .white : Color("MainColor"))
                                        .offset(y: -30)
                                        .fontWeight(.bold)
                                    
                                    Text("\(String(format: "%.2f", arrayResult[num - 1]))cm")
                                        .foregroundColor(selectNum == num - 1 ? .white : .black)
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}


struct MeasureViewRep: UIViewControllerRepresentable {
    @Binding var result: Double
    func makeUIViewController(context: Context) -> ViewController {
        var viewController = ViewController(result: $result)
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        
    }
}

class ViewController: UIViewController {
    @Binding var result: Double
    init(result: Binding<Double>) {
        self._result = result
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let sceneView: ARSCNView = {
        let view = ARSCNView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    let meterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let resetImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let resetButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let img = UIImage(systemName: "xmark")
        button.tintColor = .white
        button.setImage(img, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 100) // 大きさを指定する
        button.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let oneBackButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let img = UIImage(systemName: "arrow.counterclockwise")
        button.setImage(img, for: .normal)
        button.tintColor = .white
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 100) // 大きさを指定する
        button.addTarget(self, action: #selector(oneBackButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let targetImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "targetWhite")
        return imageView
    }()
    
    lazy var data: [Double] = []
    lazy var nowCount = 0
    fileprivate lazy var session = ARSession()
    fileprivate lazy var sessionConfiguration = ARWorldTrackingConfiguration()
    fileprivate lazy var isMeasuring = false;
    fileprivate lazy var vectorZero = SCNVector3()
    fileprivate lazy var startValue = SCNVector3()
    fileprivate lazy var endValue = SCNVector3()
    fileprivate lazy var lines: [Line] = []
    fileprivate var currentLine: Line?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(sceneView)
        view.addSubview(loadingView)
        view.addSubview(messageLabel)
        view.addSubview(meterImageView)
        view.addSubview(resetButton)
        view.addSubview(oneBackButton)
        view.addSubview(targetImageView)
        resetButton.isHidden = true // 初期状態では見えないようにする
        oneBackButton.isHidden = true // 初期状態では見えないようにする
        NSLayoutConstraint.activate([
            sceneView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            sceneView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            messageLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            meterImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            meterImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            resetButton.widthAnchor.constraint(equalToConstant: 30),
            resetButton.heightAnchor.constraint(equalToConstant: 30),
            resetButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 36),
            resetButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            oneBackButton.widthAnchor.constraint(equalToConstant: 30),
            oneBackButton.heightAnchor.constraint(equalToConstant: 30),
            oneBackButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 36),
            oneBackButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            targetImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            targetImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
        ])
        
        let leading = NSLayoutConstraint(
            item: sceneView,
            attribute: .leading,
            relatedBy: .equal,
            toItem: view,
            attribute: .leading,
            multiplier: 1,
            constant: 0
        )
        
        let trailing = NSLayoutConstraint(
            item: sceneView,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: view,
            attribute: .trailing,
            multiplier: 1,
            constant: 0
        )
        
        let top = NSLayoutConstraint(
            item: sceneView,
            attribute: .top,
            relatedBy: .equal,
            toItem: view,
            attribute: .top,
            multiplier: 1,
            constant: 0
        )
        
        let bottom = NSLayoutConstraint(
            item: sceneView,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: view,
            attribute: .bottom,
            multiplier: 1,
            constant: 0
        )
        
        // 制約を有効化します
        NSLayoutConstraint.activate([leading, trailing, top, bottom])
        setupScene()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        resetValues()
        isMeasuring = true
        targetImageView.image = UIImage(named: "targetGreen")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isMeasuring = false
        targetImageView.image = UIImage(named: "targetWhite")
        if let line = currentLine {
            lines.append(line)
            currentLine = nil
            resetButton.isHidden = false
            resetImageView.isHidden = false
            oneBackButton.isHidden = false
            oneBackButton.isHidden = false
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

// MARK: - ARSCNViewDelegate

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async { [weak self] in
            self?.detectObjects()
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        messageLabel.text = "Error occurred"
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        messageLabel.text = "Interrupted"
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        messageLabel.text = "Interruption ended"
    }
}

// MARK: - Users Interactions

extension ViewController {
    @objc func oneBackButtonTapped(button: UIButton) {
        nowCount += 1
        lines[lines.count - nowCount].removeFromParentNode()
        lines.last!.removeFromParentNode()
        if (nowCount == lines.count) {
            oneBackButton.isHidden = true
            resetButton.isHidden = true
            resetImageView.isHidden = true
        }
    }
    @objc func resetButtonTapped(button: UIButton) {
        oneBackButton.isHidden = true
        resetButton.isHidden = true
        resetImageView.isHidden = true
        nowCount = 0
        for line in lines {
            line.removeFromParentNode()
        }
        lines.removeAll()
    }
}

// MARK: - Privates

extension ViewController {
    fileprivate func setData(){
        if !data.isEmpty {
            data.removeLast()
        }
    }
    fileprivate func setupScene() {
        targetImageView.isHidden = true
        sceneView.delegate = self
        sceneView.session = session
        loadingView.startAnimating()
        meterImageView.isHidden = true
        messageLabel.text = "検出中です"
        resetButton.isHidden = true
        resetImageView.isHidden = true
        session.run(sessionConfiguration, options: [.resetTracking, .removeExistingAnchors])
        resetValues()
    }
    
    fileprivate func resetValues() {
        isMeasuring = false
        startValue = SCNVector3()
        endValue =  SCNVector3()
    }
    
    fileprivate func detectObjects() {
        guard let worldPosition = sceneView.realWorldVector(screenPosition: view.center) else { return }
        targetImageView.isHidden = false
        meterImageView.isHidden = false
        if lines.isEmpty {
            messageLabel.text = "画面をタップしたまま、携帯電話を移動させてください"
        }
        loadingView.stopAnimating()
        if isMeasuring {
            if startValue == vectorZero {
                startValue = worldPosition
                currentLine = Line(sceneView: sceneView, startVector: startValue, result: $result)
            }
            endValue = worldPosition
            currentLine?.update(to: endValue)
            messageLabel.text = currentLine?.distance(to: endValue) ?? "計算中です…"
        }
    }
}

// MARK: - Line
final class Line {
    @Binding var result: Double
    fileprivate var color: UIColor = .white
    
    fileprivate var startNode: SCNNode!
    fileprivate var endNode: SCNNode!
    fileprivate var text: SCNText!
    fileprivate var textNode: SCNNode!
    fileprivate var lineNode: SCNNode!
    
    fileprivate let sceneView: ARSCNView!
    fileprivate let startVector: SCNVector3!
    init(sceneView: ARSCNView, startVector: SCNVector3, result: Binding<Double>) {
        self.sceneView = sceneView
        self.startVector = startVector
        self._result = result
        
        let dot = SCNSphere(radius: 0.5)
        dot.firstMaterial?.diffuse.contents = color
        dot.firstMaterial?.lightingModel = .constant
        dot.firstMaterial?.isDoubleSided = true
        startNode = SCNNode(geometry: dot)
        startNode.scale = SCNVector3(1/500.0, 1/500.0, 1/500.0)
        startNode.position = startVector
        sceneView.scene.rootNode.addChildNode(startNode)
        
        endNode = SCNNode(geometry: dot)
        endNode.scale = SCNVector3(1/500.0, 1/500.0, 1/500.0)
        
        text = SCNText(string: "", extrusionDepth: 0.1)
        text.font = .systemFont(ofSize: 5)
        text.firstMaterial?.diffuse.contents = color
        //text.alignmentMode  = kCAAlignmentCenter
        //text.truncationMode = kCATruncationMiddle
        text.firstMaterial?.isDoubleSided = true
        
        let textWrapperNode = SCNNode(geometry: text)
        textWrapperNode.eulerAngles = SCNVector3Make(0, .pi, 0)
        textWrapperNode.scale = SCNVector3(1/500.0, 1/500.0, 1/500.0)
        
        textNode = SCNNode()
        textNode.addChildNode(textWrapperNode)
        let constraint = SCNLookAtConstraint(target: sceneView.pointOfView)
        constraint.isGimbalLockEnabled = true
        textNode.constraints = [constraint]
        sceneView.scene.rootNode.addChildNode(textNode)
        
        
    }
    
    
    func update(to vector: SCNVector3) {
        lineNode?.removeFromParentNode()
        lineNode = startVector.line(to: vector, color: color)
        sceneView.scene.rootNode.addChildNode(lineNode!)
        
        text.string = distance(to: vector)
        textNode.position = SCNVector3((startVector.x+vector.x)/2.0, (startVector.y+vector.y)/2.0, (startVector.z+vector.z)/2.0)
        
        endNode.position = vector
        if endNode.parent == nil {
            sceneView?.scene.rootNode.addChildNode(endNode)
        }
    }
    
    func distance(to vector: SCNVector3) -> String {
        result = Double(startVector.distance(from: vector) *  100.0)
        return String(format: "%.2f%@", startVector.distance(from: vector) *  100.0, "cm")
    }
    
    func removeFromParentNode() {
        startNode.removeFromParentNode()
        lineNode?.removeFromParentNode()
        endNode.removeFromParentNode()
        textNode.removeFromParentNode()
    }
}

// MARK: - ARSNView

extension ARSCNView {
    func realWorldVector(screenPosition: CGPoint) -> SCNVector3? {
        let results = self.hitTest(screenPosition, types: [.featurePoint])
        guard let result = results.first else { return nil }
        return SCNVector3.positionFromTransform(result.worldTransform)
    }
}

// MARK: - SCNVector3

extension SCNVector3 {
    static func positionFromTransform(_ transform: matrix_float4x4) -> SCNVector3 {
        return SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
    }
    
    func distance(from vector: SCNVector3) -> Float {
        let distanceX = self.x - vector.x
        let distanceY = self.y - vector.y
        let distanceZ = self.z - vector.z
        
        return sqrtf((distanceX * distanceX) + (distanceY * distanceY) + (distanceZ * distanceZ))
    }
    
    func line(to vector: SCNVector3, color: UIColor = .white) -> SCNNode {
        let indices: [Int32] = [0, 1]
        let source = SCNGeometrySource(vertices: [self, vector])
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)
        let geometry = SCNGeometry(sources: [source], elements: [element])
        geometry.firstMaterial?.diffuse.contents = color
        let node = SCNNode(geometry: geometry)
        return node
    }
}

extension SCNVector3: Equatable {
    public static func ==(lhs: SCNVector3, rhs: SCNVector3) -> Bool {
        return (lhs.x == rhs.x) && (lhs.y == rhs.y) && (lhs.z == rhs.z)
    }
}

struct Result {
    var result = 0.0
}



//            ScrollView(.horizontal) {
//                LazyHGrid(rows: [GridItem(.fixed(100))]) {
//                    ForEach(1...6, id: \.self) { index in
//                        Button {
//
//                        } label: {
//                            Rectangle()
//                                .fill(Color.gray.opacity(0.2))
//                                .frame(width: 100, height: 100)
//                                .cornerRadius(10)
//                        }
//                    }
//                }
//            }.frame(height: 140)
