import Flutter
import UIKit
import TuIdentidadSDK

public class SwiftTuIdentidadPlugin: NSObject, FlutterPlugin, IDValidationDelegate, IDAddressDocumentDelegate{
    var _controller : UIViewController
    var _result: FlutterResult?

    
    init(uiViewController: UIViewController) {
        _controller = uiViewController
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "tu_identidad", binaryMessenger: registrar.messenger())
        
        let viewController: UIViewController =
            (UIApplication.shared.delegate?.window??.rootViewController)!;
        
        let instance = SwiftTuIdentidadPlugin(uiViewController: viewController)
        
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
                if (_result != nil) {
                    _result?(FlutterError(code:"multiple_request",
                    message:"Cancelled by a second request",
                    details:nil))
                    _result = nil;
                }
        switch call.method {
        case "ine":
            handleIne(call: call, result: result)
        case "address":
            handleAddress(call: call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func handleIne(call: FlutterMethodCall, result: @escaping FlutterResult) {
        _result = result
        let arguments: Dictionary<String, Any> = call.arguments as! Dictionary
        

        let showTutorial: Bool = arguments["showTutorial"] as! Bool
        let showResults: Bool = arguments["showResults"] as! Bool
        let apiKey: String = arguments["apiKey"] as! String


        var INEMethod: Methods {
            switch arguments["method"] as! String {
        case "INE": return Methods.INE
        case "IDVAL": return Methods.IDVAL
        case "ONLYOCR": return Methods.ONLYOCR
        default: return Methods.INE
            }
        }
        let INEValidationInfo: Bool = arguments["INEValidationInfo"] as! Bool
        let INEValidationQuality: Bool = arguments["INEValidationQuality"] as! Bool
        let INEValidationPatterns: Bool = arguments["INEValidationPatterns"] as! Bool
        let INEValidationCurp: Bool = arguments["INEValidationCurp"] as! Bool
        let INEValidationFace: Bool = arguments["INEValidationFace"] as! Bool
        
        TUID.instantiateIDAuth(delegate: self, context: _controller, apikey: apiKey, method: INEMethod,
        showResults: showResults, validateOptions: IDValidateOptions(checkInfo: INEValidationInfo, checkQuality: INEValidationQuality,
        checkPatterns: INEValidationPatterns, checkCurp: INEValidationCurp, checkFace: INEValidationFace))
    }
    private func handleAddress(call: FlutterMethodCall, result: @escaping FlutterResult) {
        _result = result
        let arguments: Dictionary<String, Any> = call.arguments as! Dictionary
        
        let apiKey: String = arguments["apiKey"] as! String

        let idAddressViewController = IDAddressViewController()
        idAddressViewController.delegate = self
        idAddressViewController.apiKey = apiKey
        _controller.present(idAddressViewController, animated: true, completion: nil)
    }
    
    public func getData(data: IDValidation) {
        _result!(data)
    }
    
    public func getINEData(data: IDValidationINE) {
        let imageBase64Encode = data.ineFront.base64EncodedString(options: .lineLength64Characters)
        let response = ["inefPathBase":imageBase64Encode, "name":data.validation.data.name, "firstLastName": data.validation.data.firstLastName,"secondLastName":data.validation.data.secondLastName, "addressLine1": data.validation.data.addressLine1,"addressLine2": data.validation.data.addressLine2,"addressLine3": data.validation.data.addressLine3, "electoralId":data.validation.data.electoralId, "curp": data.validation.data.curp, "dateOfBirth": data.validation.data.dateOfBirth, "sex": data.validation.data.sex, "folio": data.validation.data.folio, "idNumber": data.validation.data.idNumber, "idMex": data.validation.data.idMex, "mz1": data.validation.data.mz1, "mz2":data.validation.data.mz2, "mz3":data.validation.data.mz3, "expirationDate" :data.validation.data.expirationDate];
        _result!(response)
    }
    
    public func error(response: String) {
        _result!(response)
    }
    
    public func addressDocumentController(controller: IDAddressViewController, didFinishWithResponse response:
    IDAddressDocumentResponse, andImage image: UIImage) {
        controller.dismiss(animated: true, completion: nil)
        _result!(["valid": response.valid, "data": response.data])
    }
    public func addressDocumentController(controller: IDAddressViewController, didFinishWithError error:
    IDErrorResponse, andImage image: UIImage) {
        controller.dismiss(animated: true, completion: nil)
        _result!(["message": error.message, "code": error.code])
    }
    
}

