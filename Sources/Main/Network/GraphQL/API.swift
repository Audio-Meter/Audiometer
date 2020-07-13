//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// An audio file
public struct AudioInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(category: Swift.Optional<String?> = nil, base64: Swift.Optional<String?> = nil, wordList: Swift.Optional<String?> = nil, fileFileName: Swift.Optional<String?> = nil) {
    graphQLMap = ["category": category, "base64": base64, "word_list": wordList, "file_file_name": fileFileName]
  }

  public var category: Swift.Optional<String?> {
    get {
      return graphQLMap["category"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "category")
    }
  }

  public var base64: Swift.Optional<String?> {
    get {
      return graphQLMap["base64"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "base64")
    }
  }

  public var wordList: Swift.Optional<String?> {
    get {
      return graphQLMap["word_list"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "word_list")
    }
  }

  public var fileFileName: Swift.Optional<String?> {
    get {
      return graphQLMap["file_file_name"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "file_file_name")
    }
  }
}

/// A clinic
public struct ClinicInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(email: Swift.Optional<String?> = nil, telephone: Swift.Optional<String?> = nil, fax: Swift.Optional<String?> = nil, password: Swift.Optional<String?> = nil, website: Swift.Optional<String?> = nil) {
    graphQLMap = ["email": email, "telephone": telephone, "fax": fax, "password": password, "website": website]
  }

  public var email: Swift.Optional<String?> {
    get {
      return graphQLMap["email"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "email")
    }
  }

  public var telephone: Swift.Optional<String?> {
    get {
      return graphQLMap["telephone"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "telephone")
    }
  }

  public var fax: Swift.Optional<String?> {
    get {
      return graphQLMap["fax"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "fax")
    }
  }

  public var password: Swift.Optional<String?> {
    get {
      return graphQLMap["password"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "password")
    }
  }

  public var website: Swift.Optional<String?> {
    get {
      return graphQLMap["website"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "website")
    }
  }
}

/// A clinician
public struct ClinicianInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(name: Swift.Optional<String?> = nil, email: Swift.Optional<String?> = nil, degrees: Swift.Optional<String?> = nil, certification: Swift.Optional<String?> = nil, password: Swift.Optional<String?> = nil, pcp: Swift.Optional<Bool?> = nil, disabled: Swift.Optional<Bool?> = nil) {
    graphQLMap = ["name": name, "email": email, "degrees": degrees, "certification": certification, "password": password, "pcp": pcp, "disabled": disabled]
  }

  public var name: Swift.Optional<String?> {
    get {
      return graphQLMap["name"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  public var email: Swift.Optional<String?> {
    get {
      return graphQLMap["email"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "email")
    }
  }

  public var degrees: Swift.Optional<String?> {
    get {
      return graphQLMap["degrees"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "degrees")
    }
  }

  public var certification: Swift.Optional<String?> {
    get {
      return graphQLMap["certification"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "certification")
    }
  }

  public var password: Swift.Optional<String?> {
    get {
      return graphQLMap["password"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "password")
    }
  }

  public var pcp: Swift.Optional<Bool?> {
    get {
      return graphQLMap["pcp"] as? Swift.Optional<Bool?> ?? Swift.Optional<Bool?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "pcp")
    }
  }

  public var disabled: Swift.Optional<Bool?> {
    get {
      return graphQLMap["disabled"] as? Swift.Optional<Bool?> ?? Swift.Optional<Bool?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "disabled")
    }
  }
}

/// A clinic
public struct LocalClinicInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(name: Swift.Optional<String?> = nil, email: Swift.Optional<String?> = nil, tel: Swift.Optional<String?> = nil, fax: Swift.Optional<String?> = nil, address: Swift.Optional<String?> = nil, website: Swift.Optional<String?> = nil) {
    graphQLMap = ["name": name, "email": email, "tel": tel, "fax": fax, "address": address, "website": website]
  }

  public var name: Swift.Optional<String?> {
    get {
      return graphQLMap["name"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  public var email: Swift.Optional<String?> {
    get {
      return graphQLMap["email"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "email")
    }
  }

  public var tel: Swift.Optional<String?> {
    get {
      return graphQLMap["tel"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "tel")
    }
  }

  public var fax: Swift.Optional<String?> {
    get {
      return graphQLMap["fax"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "fax")
    }
  }

  public var address: Swift.Optional<String?> {
    get {
      return graphQLMap["address"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "address")
    }
  }

  public var website: Swift.Optional<String?> {
    get {
      return graphQLMap["website"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "website")
    }
  }
}

/// A clinician
public struct LocalClinicianInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(name: Swift.Optional<String?> = nil, email: Swift.Optional<String?> = nil, certification: Swift.Optional<String?> = nil, degrees: Swift.Optional<String?> = nil, pcp: Swift.Optional<Bool?> = nil) {
    graphQLMap = ["name": name, "email": email, "certification": certification, "degrees": degrees, "pcp": pcp]
  }

  public var name: Swift.Optional<String?> {
    get {
      return graphQLMap["name"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  public var email: Swift.Optional<String?> {
    get {
      return graphQLMap["email"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "email")
    }
  }

  public var certification: Swift.Optional<String?> {
    get {
      return graphQLMap["certification"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "certification")
    }
  }

  public var degrees: Swift.Optional<String?> {
    get {
      return graphQLMap["degrees"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "degrees")
    }
  }

  public var pcp: Swift.Optional<Bool?> {
    get {
      return graphQLMap["pcp"] as? Swift.Optional<Bool?> ?? Swift.Optional<Bool?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "pcp")
    }
  }
}

/// A patient
public struct PatientInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(dateOfBirth: Swift.Optional<String?> = nil, firstName: Swift.Optional<String?> = nil, lastName: Swift.Optional<String?> = nil, gender: Swift.Optional<Genders?> = nil, mailingAddress_1: Swift.Optional<String?> = nil, mailingAddress_2: Swift.Optional<String?> = nil, city: Swift.Optional<String?> = nil, state: Swift.Optional<String?> = nil, phoneNumber: Swift.Optional<String?> = nil, zip: Swift.Optional<String?> = nil, email: Swift.Optional<String?> = nil, ssn: Swift.Optional<String?> = nil, insurance: Swift.Optional<String?> = nil, patientId: Swift.Optional<String?> = nil, icd_9: Swift.Optional<String?> = nil, icd_10: Swift.Optional<String?> = nil) {
    graphQLMap = ["date_of_birth": dateOfBirth, "first_name": firstName, "last_name": lastName, "gender": gender, "mailing_address_1": mailingAddress_1, "mailing_address_2": mailingAddress_2, "city": city, "state": state, "phone_number": phoneNumber, "zip": zip, "email": email, "ssn": ssn, "insurance": insurance, "patient_id": patientId, "icd_9": icd_9, "icd_10": icd_10]
  }

  public var dateOfBirth: Swift.Optional<String?> {
    get {
      return graphQLMap["date_of_birth"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "date_of_birth")
    }
  }

  public var firstName: Swift.Optional<String?> {
    get {
      return graphQLMap["first_name"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "first_name")
    }
  }

  public var lastName: Swift.Optional<String?> {
    get {
      return graphQLMap["last_name"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "last_name")
    }
  }

  public var gender: Swift.Optional<Genders?> {
    get {
      return graphQLMap["gender"] as? Swift.Optional<Genders?> ?? Swift.Optional<Genders?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gender")
    }
  }

  public var mailingAddress_1: Swift.Optional<String?> {
    get {
      return graphQLMap["mailing_address_1"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "mailing_address_1")
    }
  }

  public var mailingAddress_2: Swift.Optional<String?> {
    get {
      return graphQLMap["mailing_address_2"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "mailing_address_2")
    }
  }

  public var city: Swift.Optional<String?> {
    get {
      return graphQLMap["city"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "city")
    }
  }

  public var state: Swift.Optional<String?> {
    get {
      return graphQLMap["state"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "state")
    }
  }

  public var phoneNumber: Swift.Optional<String?> {
    get {
      return graphQLMap["phone_number"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "phone_number")
    }
  }

  public var zip: Swift.Optional<String?> {
    get {
      return graphQLMap["zip"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "zip")
    }
  }

  public var email: Swift.Optional<String?> {
    get {
      return graphQLMap["email"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "email")
    }
  }

  public var ssn: Swift.Optional<String?> {
    get {
      return graphQLMap["ssn"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ssn")
    }
  }

  public var insurance: Swift.Optional<String?> {
    get {
      return graphQLMap["insurance"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "insurance")
    }
  }

  public var patientId: Swift.Optional<String?> {
    get {
      return graphQLMap["patient_id"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "patient_id")
    }
  }

  public var icd_9: Swift.Optional<String?> {
    get {
      return graphQLMap["icd_9"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "icd_9")
    }
  }

  public var icd_10: Swift.Optional<String?> {
    get {
      return graphQLMap["icd_10"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "icd_10")
    }
  }
}

public enum Genders: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  /// Female
  case f
  /// Male
  case m
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "f": self = .f
      case "m": self = .m
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .f: return "f"
      case .m: return "m"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: Genders, rhs: Genders) -> Bool {
    switch (lhs, rhs) {
      case (.f, .f): return true
      case (.m, .m): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [Genders] {
    return [
      .f,
      .m,
    ]
  }
}

/// A Report
public struct ReportInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(cpt: Swift.Optional<String?> = nil, recommendation: Swift.Optional<[String?]?> = nil, other: Swift.Optional<String?> = nil, file: Swift.Optional<String?> = nil, comments: Swift.Optional<String?> = nil, testIds: Swift.Optional<[GraphQLID?]?> = nil, clinicId: Swift.Optional<GraphQLID?> = nil, physicianId: Swift.Optional<GraphQLID?> = nil, logoBase64: Swift.Optional<String?> = nil, clinicName: Swift.Optional<String?> = nil, clinicAddress: Swift.Optional<String?> = nil, clinicTel: Swift.Optional<String?> = nil, clinicFax: Swift.Optional<String?> = nil, clinicEmail: Swift.Optional<String?> = nil, clinicWebsite: Swift.Optional<String?> = nil) {
    graphQLMap = ["cpt": cpt, "recommendation": recommendation, "other": other, "file": file, "comments": comments, "test_ids": testIds, "clinic_id": clinicId, "physician_id": physicianId, "logo_base64": logoBase64, "clinic_name": clinicName, "clinic_address": clinicAddress, "clinic_tel": clinicTel, "clinic_fax": clinicFax, "clinic_email": clinicEmail, "clinic_website": clinicWebsite]
  }

  public var cpt: Swift.Optional<String?> {
    get {
      return graphQLMap["cpt"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "cpt")
    }
  }

  public var recommendation: Swift.Optional<[String?]?> {
    get {
      return graphQLMap["recommendation"] as? Swift.Optional<[String?]?> ?? Swift.Optional<[String?]?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "recommendation")
    }
  }

  public var other: Swift.Optional<String?> {
    get {
      return graphQLMap["other"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "other")
    }
  }

  public var file: Swift.Optional<String?> {
    get {
      return graphQLMap["file"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "file")
    }
  }

  public var comments: Swift.Optional<String?> {
    get {
      return graphQLMap["comments"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "comments")
    }
  }

  public var testIds: Swift.Optional<[GraphQLID?]?> {
    get {
      return graphQLMap["test_ids"] as? Swift.Optional<[GraphQLID?]?> ?? Swift.Optional<[GraphQLID?]?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "test_ids")
    }
  }

  public var clinicId: Swift.Optional<GraphQLID?> {
    get {
      return graphQLMap["clinic_id"] as? Swift.Optional<GraphQLID?> ?? Swift.Optional<GraphQLID?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "clinic_id")
    }
  }

  public var physicianId: Swift.Optional<GraphQLID?> {
    get {
      return graphQLMap["physician_id"] as? Swift.Optional<GraphQLID?> ?? Swift.Optional<GraphQLID?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "physician_id")
    }
  }

  public var logoBase64: Swift.Optional<String?> {
    get {
      return graphQLMap["logo_base64"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "logo_base64")
    }
  }

  public var clinicName: Swift.Optional<String?> {
    get {
      return graphQLMap["clinic_name"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "clinic_name")
    }
  }

  public var clinicAddress: Swift.Optional<String?> {
    get {
      return graphQLMap["clinic_address"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "clinic_address")
    }
  }

  public var clinicTel: Swift.Optional<String?> {
    get {
      return graphQLMap["clinic_tel"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "clinic_tel")
    }
  }

  public var clinicFax: Swift.Optional<String?> {
    get {
      return graphQLMap["clinic_fax"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "clinic_fax")
    }
  }

  public var clinicEmail: Swift.Optional<String?> {
    get {
      return graphQLMap["clinic_email"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "clinic_email")
    }
  }

  public var clinicWebsite: Swift.Optional<String?> {
    get {
      return graphQLMap["clinic_website"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "clinic_website")
    }
  }
}

/// A Sign
public struct SignInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(name: Swift.Optional<String?> = nil, image: Swift.Optional<String?> = nil, degrees: Swift.Optional<String?> = nil, pcp: Swift.Optional<Bool?> = nil, certification: Swift.Optional<String?> = nil) {
    graphQLMap = ["name": name, "image": image, "degrees": degrees, "pcp": pcp, "certification": certification]
  }

  public var name: Swift.Optional<String?> {
    get {
      return graphQLMap["name"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  public var image: Swift.Optional<String?> {
    get {
      return graphQLMap["image"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "image")
    }
  }

  public var degrees: Swift.Optional<String?> {
    get {
      return graphQLMap["degrees"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "degrees")
    }
  }

  public var pcp: Swift.Optional<Bool?> {
    get {
      return graphQLMap["pcp"] as? Swift.Optional<Bool?> ?? Swift.Optional<Bool?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "pcp")
    }
  }

  public var certification: Swift.Optional<String?> {
    get {
      return graphQLMap["certification"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "certification")
    }
  }
}

/// A report file
public struct RptfileInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(content: Swift.Optional<String?> = nil) {
    graphQLMap = ["content": content]
  }

  public var content: Swift.Optional<String?> {
    get {
      return graphQLMap["content"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "content")
    }
  }
}

/// Add a test
public struct TestInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(result: Swift.Optional<String?> = nil, kind: Swift.Optional<Tests?> = nil, comment: Swift.Optional<String?> = nil, image: Swift.Optional<String?> = nil) {
    graphQLMap = ["result": result, "kind": kind, "comment": comment, "image": image]
  }

  public var result: Swift.Optional<String?> {
    get {
      return graphQLMap["result"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "result")
    }
  }

  public var kind: Swift.Optional<Tests?> {
    get {
      return graphQLMap["kind"] as? Swift.Optional<Tests?> ?? Swift.Optional<Tests?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "kind")
    }
  }

  public var comment: Swift.Optional<String?> {
    get {
      return graphQLMap["comment"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "comment")
    }
  }

  public var image: Swift.Optional<String?> {
    get {
      return graphQLMap["image"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "image")
    }
  }
}

public enum Tests: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  /// Tone
  case tone
  /// Speech
  case speech
  /// Tinnitus
  case tinnitus
  /// Mini-Cog
  case minicog
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "tone": self = .tone
      case "speech": self = .speech
      case "tinnitus": self = .tinnitus
      case "minicog": self = .minicog
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .tone: return "tone"
      case .speech: return "speech"
      case .tinnitus: return "tinnitus"
      case .minicog: return "minicog"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: Tests, rhs: Tests) -> Bool {
    switch (lhs, rhs) {
      case (.tone, .tone): return true
      case (.speech, .speech): return true
      case (.tinnitus, .tinnitus): return true
      case (.minicog, .minicog): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [Tests] {
    return [
      .tone,
      .speech,
      .tinnitus,
      .minicog,
    ]
  }
}

/// A profile
public struct ProfileInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(icd_9: Swift.Optional<String?> = nil, icd_10: Swift.Optional<String?> = nil, signature: Swift.Optional<String?> = nil, currentClinicId: Swift.Optional<GraphQLID?> = nil, currentPhysicianId: Swift.Optional<GraphQLID?> = nil) {
    graphQLMap = ["icd_9": icd_9, "icd_10": icd_10, "signature": signature, "current_clinic_id": currentClinicId, "current_physician_id": currentPhysicianId]
  }

  public var icd_9: Swift.Optional<String?> {
    get {
      return graphQLMap["icd_9"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "icd_9")
    }
  }

  public var icd_10: Swift.Optional<String?> {
    get {
      return graphQLMap["icd_10"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "icd_10")
    }
  }

  public var signature: Swift.Optional<String?> {
    get {
      return graphQLMap["signature"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "signature")
    }
  }

  public var currentClinicId: Swift.Optional<GraphQLID?> {
    get {
      return graphQLMap["current_clinic_id"] as? Swift.Optional<GraphQLID?> ?? Swift.Optional<GraphQLID?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "current_clinic_id")
    }
  }

  public var currentPhysicianId: Swift.Optional<GraphQLID?> {
    get {
      return graphQLMap["current_physician_id"] as? Swift.Optional<GraphQLID?> ?? Swift.Optional<GraphQLID?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "current_physician_id")
    }
  }
}

public enum UserCateogry: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case admin
  case clinic
  case clinician
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "Admin": self = .admin
      case "Clinic": self = .clinic
      case "Clinician": self = .clinician
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .admin: return "Admin"
      case .clinic: return "Clinic"
      case .clinician: return "Clinician"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: UserCateogry, rhs: UserCateogry) -> Bool {
    switch (lhs, rhs) {
      case (.admin, .admin): return true
      case (.clinic, .clinic): return true
      case (.clinician, .clinician): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [UserCateogry] {
    return [
      .admin,
      .clinic,
      .clinician,
    ]
  }
}

public final class AudiosQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    query Audios($category: String!) {
      audios(category: $category) {
        __typename
        ...AudioDetails
      }
    }
    """

  public let operationName = "Audios"

  public var queryDocument: String { return operationDefinition.appending(AudioDetails.fragmentDefinition) }

  public var category: String

  public init(category: String) {
    self.category = category
  }

  public var variables: GraphQLMap? {
    return ["category": category]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("audios", arguments: ["category": GraphQLVariable("category")], type: .list(.object(Audio.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(audios: [Audio?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "audios": audios.flatMap { (value: [Audio?]) -> [ResultMap?] in value.map { (value: Audio?) -> ResultMap? in value.flatMap { (value: Audio) -> ResultMap in value.resultMap } } }])
    }

    /// Audio files
    @available(*, deprecated, message: "deprecated in favor of clinic.audios")
    public var audios: [Audio?]? {
      get {
        return (resultMap["audios"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Audio?] in value.map { (value: ResultMap?) -> Audio? in value.flatMap { (value: ResultMap) -> Audio in Audio(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [Audio?]) -> [ResultMap?] in value.map { (value: Audio?) -> ResultMap? in value.flatMap { (value: Audio) -> ResultMap in value.resultMap } } }, forKey: "audios")
      }
    }

    public struct Audio: GraphQLSelectionSet {
      public static let possibleTypes = ["Audio"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(AudioDetails.self),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(category: String? = nil, fileFileName: String? = nil, id: GraphQLID? = nil, wordList: [String?]? = nil, alias: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "Audio", "category": category, "file_file_name": fileFileName, "id": id, "word_list": wordList, "alias": alias])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var audioDetails: AudioDetails {
          get {
            return AudioDetails(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class AllAudioQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    query AllAudio {
      audios {
        __typename
        ...AudioDetails
      }
    }
    """

  public let operationName = "AllAudio"

  public var queryDocument: String { return operationDefinition.appending(AudioDetails.fragmentDefinition) }

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("audios", type: .list(.object(Audio.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(audios: [Audio?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "audios": audios.flatMap { (value: [Audio?]) -> [ResultMap?] in value.map { (value: Audio?) -> ResultMap? in value.flatMap { (value: Audio) -> ResultMap in value.resultMap } } }])
    }

    /// Audio files
    @available(*, deprecated, message: "deprecated in favor of clinic.audios")
    public var audios: [Audio?]? {
      get {
        return (resultMap["audios"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Audio?] in value.map { (value: ResultMap?) -> Audio? in value.flatMap { (value: ResultMap) -> Audio in Audio(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [Audio?]) -> [ResultMap?] in value.map { (value: Audio?) -> ResultMap? in value.flatMap { (value: Audio) -> ResultMap in value.resultMap } } }, forKey: "audios")
      }
    }

    public struct Audio: GraphQLSelectionSet {
      public static let possibleTypes = ["Audio"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(AudioDetails.self),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(category: String? = nil, fileFileName: String? = nil, id: GraphQLID? = nil, wordList: [String?]? = nil, alias: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "Audio", "category": category, "file_file_name": fileFileName, "id": id, "word_list": wordList, "alias": alias])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var audioDetails: AudioDetails {
          get {
            return AudioDetails(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class SingleAudioQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    query SingleAudio($id: ID!) {
      audio(id: $id) {
        __typename
        ...AudioDetails
        base64
      }
    }
    """

  public let operationName = "SingleAudio"

  public var queryDocument: String { return operationDefinition.appending(AudioDetails.fragmentDefinition) }

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("audio", arguments: ["id": GraphQLVariable("id")], type: .object(Audio.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(audio: Audio? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "audio": audio.flatMap { (value: Audio) -> ResultMap in value.resultMap }])
    }

    public var audio: Audio? {
      get {
        return (resultMap["audio"] as? ResultMap).flatMap { Audio(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "audio")
      }
    }

    public struct Audio: GraphQLSelectionSet {
      public static let possibleTypes = ["Audio"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(AudioDetails.self),
        GraphQLField("base64", type: .scalar(String.self)),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(category: String? = nil, fileFileName: String? = nil, id: GraphQLID? = nil, wordList: [String?]? = nil, alias: String? = nil, base64: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "Audio", "category": category, "file_file_name": fileFileName, "id": id, "word_list": wordList, "alias": alias, "base64": base64])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var base64: String? {
        get {
          return resultMap["base64"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "base64")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var audioDetails: AudioDetails {
          get {
            return AudioDetails(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class CreateAudioMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    mutation CreateAudio($audio: AudioInput) {
      create_audio(audio: $audio) {
        __typename
        id
        category
        file_file_name
        word_list
        base64
      }
    }
    """

  public let operationName = "CreateAudio"

  public var audio: AudioInput?

  public init(audio: AudioInput? = nil) {
    self.audio = audio
  }

  public var variables: GraphQLMap? {
    return ["audio": audio]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("create_audio", arguments: ["audio": GraphQLVariable("audio")], type: .object(CreateAudio.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(createAudio: CreateAudio? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "create_audio": createAudio.flatMap { (value: CreateAudio) -> ResultMap in value.resultMap }])
    }

    /// Create a new audio file
    public var createAudio: CreateAudio? {
      get {
        return (resultMap["create_audio"] as? ResultMap).flatMap { CreateAudio(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "create_audio")
      }
    }

    public struct CreateAudio: GraphQLSelectionSet {
      public static let possibleTypes = ["Audio"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .scalar(GraphQLID.self)),
        GraphQLField("category", type: .scalar(String.self)),
        GraphQLField("file_file_name", type: .scalar(String.self)),
        GraphQLField("word_list", type: .list(.scalar(String.self))),
        GraphQLField("base64", type: .scalar(String.self)),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID? = nil, category: String? = nil, fileFileName: String? = nil, wordList: [String?]? = nil, base64: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "Audio", "id": id, "category": category, "file_file_name": fileFileName, "word_list": wordList, "base64": base64])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID? {
        get {
          return resultMap["id"] as? GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var category: String? {
        get {
          return resultMap["category"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "category")
        }
      }

      public var fileFileName: String? {
        get {
          return resultMap["file_file_name"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "file_file_name")
        }
      }

      public var wordList: [String?]? {
        get {
          return resultMap["word_list"] as? [String?]
        }
        set {
          resultMap.updateValue(newValue, forKey: "word_list")
        }
      }

      public var base64: String? {
        get {
          return resultMap["base64"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "base64")
        }
      }
    }
  }
}

public final class DeleteAudioMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    mutation DeleteAudio($id: ID!) {
      delete_audio(id: $id)
    }
    """

  public let operationName = "DeleteAudio"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("delete_audio", arguments: ["id": GraphQLVariable("id")], type: .scalar(Bool.self)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(deleteAudio: Bool? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "delete_audio": deleteAudio])
    }

    /// Delete an audio file
    public var deleteAudio: Bool? {
      get {
        return resultMap["delete_audio"] as? Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "delete_audio")
      }
    }
  }
}

public final class LoginMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    mutation Login($email: String!, $password: String!) {
      login(email: $email, password: $password)
    }
    """

  public let operationName = "Login"

  public var email: String
  public var password: String

  public init(email: String, password: String) {
    self.email = email
    self.password = password
  }

  public var variables: GraphQLMap? {
    return ["email": email, "password": password]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("login", arguments: ["email": GraphQLVariable("email"), "password": GraphQLVariable("password")], type: .scalar(String.self)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(login: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "login": login])
    }

    /// Issues token that can be used in `Authorization` header
    public var login: String? {
      get {
        return resultMap["login"] as? String
      }
      set {
        resultMap.updateValue(newValue, forKey: "login")
      }
    }
  }
}

public final class ForgotPasswordMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    mutation ForgotPassword($email: String!) {
      reset_password(email: $email)
    }
    """

  public let operationName = "ForgotPassword"

  public var email: String

  public init(email: String) {
    self.email = email
  }

  public var variables: GraphQLMap? {
    return ["email": email]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("reset_password", arguments: ["email": GraphQLVariable("email")], type: .scalar(Bool.self)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(resetPassword: Bool? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "reset_password": resetPassword])
    }

    /// Update password
    public var resetPassword: Bool? {
      get {
        return resultMap["reset_password"] as? Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "reset_password")
      }
    }
  }
}

public final class UpdateClinicProfileMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    mutation UpdateClinicProfile($clinic: ClinicInput) {
      update_clinic(clinic: $clinic)
    }
    """

  public let operationName = "UpdateClinicProfile"

  public var clinic: ClinicInput?

  public init(clinic: ClinicInput? = nil) {
    self.clinic = clinic
  }

  public var variables: GraphQLMap? {
    return ["clinic": clinic]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("update_clinic", arguments: ["clinic": GraphQLVariable("clinic")], type: .scalar(Bool.self)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(updateClinic: Bool? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "update_clinic": updateClinic])
    }

    /// Update a Clinician
    public var updateClinic: Bool? {
      get {
        return resultMap["update_clinic"] as? Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "update_clinic")
      }
    }
  }
}

public final class CreateClinicianMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    mutation CreateClinician($clinician: ClinicianInput) {
      create_clinician(clinician: $clinician) {
        __typename
        ...ClinicianDetails
      }
    }
    """

  public let operationName = "CreateClinician"

  public var queryDocument: String { return operationDefinition.appending(ClinicianDetails.fragmentDefinition) }

  public var clinician: ClinicianInput?

  public init(clinician: ClinicianInput? = nil) {
    self.clinician = clinician
  }

  public var variables: GraphQLMap? {
    return ["clinician": clinician]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("create_clinician", arguments: ["clinician": GraphQLVariable("clinician")], type: .object(CreateClinician.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(createClinician: CreateClinician? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "create_clinician": createClinician.flatMap { (value: CreateClinician) -> ResultMap in value.resultMap }])
    }

    /// Add a New Clinician
    public var createClinician: CreateClinician? {
      get {
        return (resultMap["create_clinician"] as? ResultMap).flatMap { CreateClinician(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "create_clinician")
      }
    }

    public struct CreateClinician: GraphQLSelectionSet {
      public static let possibleTypes = ["Clinician"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(ClinicianDetails.self),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var clinicianDetails: ClinicianDetails {
          get {
            return ClinicianDetails(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class UpdateClinicianMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    mutation UpdateClinician($id: ID!, $clinician: ClinicianInput) {
      update_clinician(id: $id, clinician: $clinician)
    }
    """

  public let operationName = "UpdateClinician"

  public var id: GraphQLID
  public var clinician: ClinicianInput?

  public init(id: GraphQLID, clinician: ClinicianInput? = nil) {
    self.id = id
    self.clinician = clinician
  }

  public var variables: GraphQLMap? {
    return ["id": id, "clinician": clinician]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("update_clinician", arguments: ["id": GraphQLVariable("id"), "clinician": GraphQLVariable("clinician")], type: .scalar(Bool.self)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(updateClinician: Bool? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "update_clinician": updateClinician])
    }

    /// Update a Clinician
    public var updateClinician: Bool? {
      get {
        return resultMap["update_clinician"] as? Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "update_clinician")
      }
    }
  }
}

public final class CliniciansQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    query Clinicians {
      clinicians {
        __typename
        ...ClinicianDetails
      }
    }
    """

  public let operationName = "Clinicians"

  public var queryDocument: String { return operationDefinition.appending(ClinicianDetails.fragmentDefinition) }

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("clinicians", type: .list(.object(Clinician.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(clinicians: [Clinician?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "clinicians": clinicians.flatMap { (value: [Clinician?]) -> [ResultMap?] in value.map { (value: Clinician?) -> ResultMap? in value.flatMap { (value: Clinician) -> ResultMap in value.resultMap } } }])
    }

    /// All clinicians
    public var clinicians: [Clinician?]? {
      get {
        return (resultMap["clinicians"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Clinician?] in value.map { (value: ResultMap?) -> Clinician? in value.flatMap { (value: ResultMap) -> Clinician in Clinician(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [Clinician?]) -> [ResultMap?] in value.map { (value: Clinician?) -> ResultMap? in value.flatMap { (value: Clinician) -> ResultMap in value.resultMap } } }, forKey: "clinicians")
      }
    }

    public struct Clinician: GraphQLSelectionSet {
      public static let possibleTypes = ["Clinician"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(ClinicianDetails.self),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var clinicianDetails: ClinicianDetails {
          get {
            return ClinicianDetails(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class UpdateLocalClinicMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    mutation UpdateLocalClinic($id: ID!, $clinic: LocalClinicInput) {
      update_local_clinic(id: $id, clinic: $clinic)
    }
    """

  public let operationName = "UpdateLocalClinic"

  public var id: GraphQLID
  public var clinic: LocalClinicInput?

  public init(id: GraphQLID, clinic: LocalClinicInput? = nil) {
    self.id = id
    self.clinic = clinic
  }

  public var variables: GraphQLMap? {
    return ["id": id, "clinic": clinic]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("update_local_clinic", arguments: ["id": GraphQLVariable("id"), "clinic": GraphQLVariable("clinic")], type: .scalar(Bool.self)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(updateLocalClinic: Bool? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "update_local_clinic": updateLocalClinic])
    }

    /// Update a local clinic
    public var updateLocalClinic: Bool? {
      get {
        return resultMap["update_local_clinic"] as? Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "update_local_clinic")
      }
    }
  }
}

public final class CreateLocalClinicMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    mutation CreateLocalClinic($clinic: LocalClinicInput) {
      create_local_clinic(clinic: $clinic) {
        __typename
        ...LocalClinicDetails
      }
    }
    """

  public let operationName = "CreateLocalClinic"

  public var queryDocument: String { return operationDefinition.appending(LocalClinicDetails.fragmentDefinition) }

  public var clinic: LocalClinicInput?

  public init(clinic: LocalClinicInput? = nil) {
    self.clinic = clinic
  }

  public var variables: GraphQLMap? {
    return ["clinic": clinic]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("create_local_clinic", arguments: ["clinic": GraphQLVariable("clinic")], type: .object(CreateLocalClinic.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(createLocalClinic: CreateLocalClinic? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "create_local_clinic": createLocalClinic.flatMap { (value: CreateLocalClinic) -> ResultMap in value.resultMap }])
    }

    /// Create a new local clinic
    public var createLocalClinic: CreateLocalClinic? {
      get {
        return (resultMap["create_local_clinic"] as? ResultMap).flatMap { CreateLocalClinic(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "create_local_clinic")
      }
    }

    public struct CreateLocalClinic: GraphQLSelectionSet {
      public static let possibleTypes = ["LocalClinic"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(LocalClinicDetails.self),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID? = nil, name: String? = nil, email: String? = nil, address: String? = nil, tel: String? = nil, fax: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "LocalClinic", "id": id, "name": name, "email": email, "address": address, "tel": tel, "fax": fax])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var localClinicDetails: LocalClinicDetails {
          get {
            return LocalClinicDetails(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class LocalClinicsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    query LocalClinics {
      local_clinics {
        __typename
        ...LocalClinicDetails
      }
    }
    """

  public let operationName = "LocalClinics"

  public var queryDocument: String { return operationDefinition.appending(LocalClinicDetails.fragmentDefinition) }

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("local_clinics", type: .list(.object(LocalClinic.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(localClinics: [LocalClinic?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "local_clinics": localClinics.flatMap { (value: [LocalClinic?]) -> [ResultMap?] in value.map { (value: LocalClinic?) -> ResultMap? in value.flatMap { (value: LocalClinic) -> ResultMap in value.resultMap } } }])
    }

    /// All local clinics managed by current user
    public var localClinics: [LocalClinic?]? {
      get {
        return (resultMap["local_clinics"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [LocalClinic?] in value.map { (value: ResultMap?) -> LocalClinic? in value.flatMap { (value: ResultMap) -> LocalClinic in LocalClinic(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [LocalClinic?]) -> [ResultMap?] in value.map { (value: LocalClinic?) -> ResultMap? in value.flatMap { (value: LocalClinic) -> ResultMap in value.resultMap } } }, forKey: "local_clinics")
      }
    }

    public struct LocalClinic: GraphQLSelectionSet {
      public static let possibleTypes = ["LocalClinic"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(LocalClinicDetails.self),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID? = nil, name: String? = nil, email: String? = nil, address: String? = nil, tel: String? = nil, fax: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "LocalClinic", "id": id, "name": name, "email": email, "address": address, "tel": tel, "fax": fax])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var localClinicDetails: LocalClinicDetails {
          get {
            return LocalClinicDetails(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class UpdateLocalClinicianMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    mutation UpdateLocalClinician($id: ID!, $clinician: LocalClinicianInput) {
      update_local_clinician(id: $id, clinician: $clinician)
    }
    """

  public let operationName = "UpdateLocalClinician"

  public var id: GraphQLID
  public var clinician: LocalClinicianInput?

  public init(id: GraphQLID, clinician: LocalClinicianInput? = nil) {
    self.id = id
    self.clinician = clinician
  }

  public var variables: GraphQLMap? {
    return ["id": id, "clinician": clinician]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("update_local_clinician", arguments: ["id": GraphQLVariable("id"), "clinician": GraphQLVariable("clinician")], type: .scalar(Bool.self)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(updateLocalClinician: Bool? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "update_local_clinician": updateLocalClinician])
    }

    /// Update a local clinician
    public var updateLocalClinician: Bool? {
      get {
        return resultMap["update_local_clinician"] as? Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "update_local_clinician")
      }
    }
  }
}

public final class CreateLocalClinicianMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    mutation CreateLocalClinician($clinician: LocalClinicianInput) {
      create_local_clinician(clinician: $clinician) {
        __typename
        ...LocalClinicianDetails
      }
    }
    """

  public let operationName = "CreateLocalClinician"

  public var queryDocument: String { return operationDefinition.appending(LocalClinicianDetails.fragmentDefinition) }

  public var clinician: LocalClinicianInput?

  public init(clinician: LocalClinicianInput? = nil) {
    self.clinician = clinician
  }

  public var variables: GraphQLMap? {
    return ["clinician": clinician]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("create_local_clinician", arguments: ["clinician": GraphQLVariable("clinician")], type: .object(CreateLocalClinician.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(createLocalClinician: CreateLocalClinician? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "create_local_clinician": createLocalClinician.flatMap { (value: CreateLocalClinician) -> ResultMap in value.resultMap }])
    }

    /// Create a new local clinician
    public var createLocalClinician: CreateLocalClinician? {
      get {
        return (resultMap["create_local_clinician"] as? ResultMap).flatMap { CreateLocalClinician(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "create_local_clinician")
      }
    }

    public struct CreateLocalClinician: GraphQLSelectionSet {
      public static let possibleTypes = ["LocalClinician"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(LocalClinicianDetails.self),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID? = nil, name: String? = nil, email: String? = nil, certification: String? = nil, degrees: String? = nil, pcp: Bool? = nil) {
        self.init(unsafeResultMap: ["__typename": "LocalClinician", "id": id, "name": name, "email": email, "certification": certification, "degrees": degrees, "pcp": pcp])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var localClinicianDetails: LocalClinicianDetails {
          get {
            return LocalClinicianDetails(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class LocalCliniciansQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    query LocalClinicians {
      local_clinicians {
        __typename
        ...LocalClinicianDetails
      }
    }
    """

  public let operationName = "LocalClinicians"

  public var queryDocument: String { return operationDefinition.appending(LocalClinicianDetails.fragmentDefinition) }

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("local_clinicians", type: .list(.object(LocalClinician.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(localClinicians: [LocalClinician?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "local_clinicians": localClinicians.flatMap { (value: [LocalClinician?]) -> [ResultMap?] in value.map { (value: LocalClinician?) -> ResultMap? in value.flatMap { (value: LocalClinician) -> ResultMap in value.resultMap } } }])
    }

    /// All local clinics managed by current user
    public var localClinicians: [LocalClinician?]? {
      get {
        return (resultMap["local_clinicians"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [LocalClinician?] in value.map { (value: ResultMap?) -> LocalClinician? in value.flatMap { (value: ResultMap) -> LocalClinician in LocalClinician(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [LocalClinician?]) -> [ResultMap?] in value.map { (value: LocalClinician?) -> ResultMap? in value.flatMap { (value: LocalClinician) -> ResultMap in value.resultMap } } }, forKey: "local_clinicians")
      }
    }

    public struct LocalClinician: GraphQLSelectionSet {
      public static let possibleTypes = ["LocalClinician"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(LocalClinicianDetails.self),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID? = nil, name: String? = nil, email: String? = nil, certification: String? = nil, degrees: String? = nil, pcp: Bool? = nil) {
        self.init(unsafeResultMap: ["__typename": "LocalClinician", "id": id, "name": name, "email": email, "certification": certification, "degrees": degrees, "pcp": pcp])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var localClinicianDetails: LocalClinicianDetails {
          get {
            return LocalClinicianDetails(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class CreatePatientMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    mutation CreatePatient($patient: PatientInput) {
      create_patient(patient: $patient) {
        __typename
        ...PatientDetails
      }
    }
    """

  public let operationName = "CreatePatient"

  public var queryDocument: String { return operationDefinition.appending(PatientDetails.fragmentDefinition) }

  public var patient: PatientInput?

  public init(patient: PatientInput? = nil) {
    self.patient = patient
  }

  public var variables: GraphQLMap? {
    return ["patient": patient]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("create_patient", arguments: ["patient": GraphQLVariable("patient")], type: .object(CreatePatient.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(createPatient: CreatePatient? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "create_patient": createPatient.flatMap { (value: CreatePatient) -> ResultMap in value.resultMap }])
    }

    /// Add a New Patient
    public var createPatient: CreatePatient? {
      get {
        return (resultMap["create_patient"] as? ResultMap).flatMap { CreatePatient(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "create_patient")
      }
    }

    public struct CreatePatient: GraphQLSelectionSet {
      public static let possibleTypes = ["Patient"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(PatientDetails.self),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(city: String? = nil, createdAt: String? = nil, dateOfBirth: String? = nil, firstName: String? = nil, gender: Genders? = nil, patientId: String? = nil, id: GraphQLID? = nil, lastName: String? = nil, mailingAddress_1: String? = nil, mailingAddress_2: String? = nil, phoneNumber: String? = nil, state: String? = nil, updatedAt: String? = nil, zip: String? = nil, email: String? = nil, insurance: String? = nil, ssn: String? = nil, icd_9: String? = nil, icd_10: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "Patient", "city": city, "created_at": createdAt, "date_of_birth": dateOfBirth, "first_name": firstName, "gender": gender, "patient_id": patientId, "id": id, "last_name": lastName, "mailing_address_1": mailingAddress_1, "mailing_address_2": mailingAddress_2, "phone_number": phoneNumber, "state": state, "updated_at": updatedAt, "zip": zip, "email": email, "insurance": insurance, "ssn": ssn, "icd_9": icd_9, "icd_10": icd_10])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var patientDetails: PatientDetails {
          get {
            return PatientDetails(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class DeletePatientMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    mutation DeletePatient($id: ID!) {
      delete_patient(id: $id)
    }
    """

  public let operationName = "DeletePatient"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("delete_patient", arguments: ["id": GraphQLVariable("id")], type: .scalar(Bool.self)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(deletePatient: Bool? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "delete_patient": deletePatient])
    }

    /// Delete a patient
    public var deletePatient: Bool? {
      get {
        return resultMap["delete_patient"] as? Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "delete_patient")
      }
    }
  }
}

public final class UpdatePatientMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    mutation UpdatePatient($id: ID!, $patient: PatientInput) {
      update_patient(id: $id, patient: $patient)
    }
    """

  public let operationName = "UpdatePatient"

  public var id: GraphQLID
  public var patient: PatientInput?

  public init(id: GraphQLID, patient: PatientInput? = nil) {
    self.id = id
    self.patient = patient
  }

  public var variables: GraphQLMap? {
    return ["id": id, "patient": patient]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("update_patient", arguments: ["id": GraphQLVariable("id"), "patient": GraphQLVariable("patient")], type: .scalar(Bool.self)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(updatePatient: Bool? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "update_patient": updatePatient])
    }

    /// Update a Patient
    public var updatePatient: Bool? {
      get {
        return resultMap["update_patient"] as? Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "update_patient")
      }
    }
  }
}

public final class CreatePatientReportMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    mutation CreatePatientReport($patient_id: ID!, $patient_report: ReportInput, $signs: [SignInput], $rptfiles: [RptfileInput]) {
      create_report(patient_id: $patient_id, report: $patient_report, signs: $signs, files: $rptfiles) {
        __typename
        report_url
      }
    }
    """

  public let operationName = "CreatePatientReport"

  public var patient_id: GraphQLID
  public var patient_report: ReportInput?
  public var signs: [SignInput?]?
  public var rptfiles: [RptfileInput?]?

  public init(patient_id: GraphQLID, patient_report: ReportInput? = nil, signs: [SignInput?]? = nil, rptfiles: [RptfileInput?]? = nil) {
    self.patient_id = patient_id
    self.patient_report = patient_report
    self.signs = signs
    self.rptfiles = rptfiles
  }

  public var variables: GraphQLMap? {
    return ["patient_id": patient_id, "patient_report": patient_report, "signs": signs, "rptfiles": rptfiles]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("create_report", arguments: ["patient_id": GraphQLVariable("patient_id"), "report": GraphQLVariable("patient_report"), "signs": GraphQLVariable("signs"), "files": GraphQLVariable("rptfiles")], type: .object(CreateReport.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(createReport: CreateReport? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "create_report": createReport.flatMap { (value: CreateReport) -> ResultMap in value.resultMap }])
    }

    /// Add a patient report
    public var createReport: CreateReport? {
      get {
        return (resultMap["create_report"] as? ResultMap).flatMap { CreateReport(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "create_report")
      }
    }

    public struct CreateReport: GraphQLSelectionSet {
      public static let possibleTypes = ["ReportType"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("report_url", type: .scalar(String.self)),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(reportUrl: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "ReportType", "report_url": reportUrl])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var reportUrl: String? {
        get {
          return resultMap["report_url"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "report_url")
        }
      }
    }
  }
}

public final class PatientQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    query Patient($id: ID!) {
      patient(id: $id) {
        __typename
        ...PatientDetails
        tests {
          __typename
          ...TestDetails
        }
      }
    }
    """

  public let operationName = "Patient"

  public var queryDocument: String { return operationDefinition.appending(PatientDetails.fragmentDefinition).appending(TestDetails.fragmentDefinition) }

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("patient", arguments: ["id": GraphQLVariable("id")], type: .object(Patient.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(patient: Patient? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "patient": patient.flatMap { (value: Patient) -> ResultMap in value.resultMap }])
    }

    /// Search by id
    public var patient: Patient? {
      get {
        return (resultMap["patient"] as? ResultMap).flatMap { Patient(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "patient")
      }
    }

    public struct Patient: GraphQLSelectionSet {
      public static let possibleTypes = ["Patient"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(PatientDetails.self),
        GraphQLField("tests", type: .list(.object(Test.selections))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var tests: [Test?]? {
        get {
          return (resultMap["tests"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Test?] in value.map { (value: ResultMap?) -> Test? in value.flatMap { (value: ResultMap) -> Test in Test(unsafeResultMap: value) } } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [Test?]) -> [ResultMap?] in value.map { (value: Test?) -> ResultMap? in value.flatMap { (value: Test) -> ResultMap in value.resultMap } } }, forKey: "tests")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var patientDetails: PatientDetails {
          get {
            return PatientDetails(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }

      public struct Test: GraphQLSelectionSet {
        public static let possibleTypes = ["Test"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(TestDetails.self),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(comment: String? = nil, createdAt: String? = nil, id: GraphQLID? = nil, kind: String? = nil, result: String? = nil, updatedAt: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "Test", "comment": comment, "created_at": createdAt, "id": id, "kind": kind, "result": result, "updated_at": updatedAt])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var fragments: Fragments {
          get {
            return Fragments(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }

        public struct Fragments {
          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public var testDetails: TestDetails {
            get {
              return TestDetails(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }
        }
      }
    }
  }
}

public final class PatientsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    query Patients {
      patients {
        __typename
        ...PatientDetails
      }
    }
    """

  public let operationName = "Patients"

  public var queryDocument: String { return operationDefinition.appending(PatientDetails.fragmentDefinition) }

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("patients", type: .list(.object(Patient.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(patients: [Patient?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "patients": patients.flatMap { (value: [Patient?]) -> [ResultMap?] in value.map { (value: Patient?) -> ResultMap? in value.flatMap { (value: Patient) -> ResultMap in value.resultMap } } }])
    }

    /// All patients
    public var patients: [Patient?]? {
      get {
        return (resultMap["patients"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Patient?] in value.map { (value: ResultMap?) -> Patient? in value.flatMap { (value: ResultMap) -> Patient in Patient(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [Patient?]) -> [ResultMap?] in value.map { (value: Patient?) -> ResultMap? in value.flatMap { (value: Patient) -> ResultMap in value.resultMap } } }, forKey: "patients")
      }
    }

    public struct Patient: GraphQLSelectionSet {
      public static let possibleTypes = ["Patient"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(PatientDetails.self),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(city: String? = nil, createdAt: String? = nil, dateOfBirth: String? = nil, firstName: String? = nil, gender: Genders? = nil, patientId: String? = nil, id: GraphQLID? = nil, lastName: String? = nil, mailingAddress_1: String? = nil, mailingAddress_2: String? = nil, phoneNumber: String? = nil, state: String? = nil, updatedAt: String? = nil, zip: String? = nil, email: String? = nil, insurance: String? = nil, ssn: String? = nil, icd_9: String? = nil, icd_10: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "Patient", "city": city, "created_at": createdAt, "date_of_birth": dateOfBirth, "first_name": firstName, "gender": gender, "patient_id": patientId, "id": id, "last_name": lastName, "mailing_address_1": mailingAddress_1, "mailing_address_2": mailingAddress_2, "phone_number": phoneNumber, "state": state, "updated_at": updatedAt, "zip": zip, "email": email, "insurance": insurance, "ssn": ssn, "icd_9": icd_9, "icd_10": icd_10])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var patientDetails: PatientDetails {
          get {
            return PatientDetails(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class CreateTestMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    mutation CreateTest($patient_id: ID!, $test: TestInput) {
      create_test(patient_id: $patient_id, test: $test) {
        __typename
        id
      }
    }
    """

  public let operationName = "CreateTest"

  public var patient_id: GraphQLID
  public var test: TestInput?

  public init(patient_id: GraphQLID, test: TestInput? = nil) {
    self.patient_id = patient_id
    self.test = test
  }

  public var variables: GraphQLMap? {
    return ["patient_id": patient_id, "test": test]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("create_test", arguments: ["patient_id": GraphQLVariable("patient_id"), "test": GraphQLVariable("test")], type: .object(CreateTest.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(createTest: CreateTest? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "create_test": createTest.flatMap { (value: CreateTest) -> ResultMap in value.resultMap }])
    }

    /// Add a test to patient
    public var createTest: CreateTest? {
      get {
        return (resultMap["create_test"] as? ResultMap).flatMap { CreateTest(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "create_test")
      }
    }

    public struct CreateTest: GraphQLSelectionSet {
      public static let possibleTypes = ["Test"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .scalar(GraphQLID.self)),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID? = nil) {
        self.init(unsafeResultMap: ["__typename": "Test", "id": id])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID? {
        get {
          return resultMap["id"] as? GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }
    }
  }
}

public final class UpdateProfileMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    mutation UpdateProfile($profile: ProfileInput!) {
      update_profile(profile: $profile)
    }
    """

  public let operationName = "UpdateProfile"

  public var profile: ProfileInput

  public init(profile: ProfileInput) {
    self.profile = profile
  }

  public var variables: GraphQLMap? {
    return ["profile": profile]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("update_profile", arguments: ["profile": GraphQLVariable("profile")], type: .scalar(Bool.self)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(updateProfile: Bool? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "update_profile": updateProfile])
    }

    /// Update current user's profile
    public var updateProfile: Bool? {
      get {
        return resultMap["update_profile"] as? Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "update_profile")
      }
    }
  }
}

public final class CommonProfileQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    query CommonProfile {
      profile {
        __typename
        type
      }
    }
    """

  public let operationName = "CommonProfile"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("profile", type: .object(Profile.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(profile: Profile? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "profile": profile.flatMap { (value: Profile) -> ResultMap in value.resultMap }])
    }

    /// Current clinician's profile
    public var profile: Profile? {
      get {
        return (resultMap["profile"] as? ResultMap).flatMap { Profile(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "profile")
      }
    }

    public struct Profile: GraphQLSelectionSet {
      public static let possibleTypes = ["Profile"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("type", type: .scalar(UserCateogry.self)),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(type: UserCateogry? = nil) {
        self.init(unsafeResultMap: ["__typename": "Profile", "type": type])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var type: UserCateogry? {
        get {
          return resultMap["type"] as? UserCateogry
        }
        set {
          resultMap.updateValue(newValue, forKey: "type")
        }
      }
    }
  }
}

public final class ClinicProfileQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    query ClinicProfile {
      clinic_profile {
        __typename
        id
        name
        email
        telephone
        fax
        address
        website
        type
      }
    }
    """

  public let operationName = "ClinicProfile"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("clinic_profile", type: .object(ClinicProfile.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(clinicProfile: ClinicProfile? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "clinic_profile": clinicProfile.flatMap { (value: ClinicProfile) -> ResultMap in value.resultMap }])
    }

    /// Current Clinic
    public var clinicProfile: ClinicProfile? {
      get {
        return (resultMap["clinic_profile"] as? ResultMap).flatMap { ClinicProfile(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "clinic_profile")
      }
    }

    public struct ClinicProfile: GraphQLSelectionSet {
      public static let possibleTypes = ["Clinic"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .scalar(GraphQLID.self)),
        GraphQLField("name", type: .scalar(String.self)),
        GraphQLField("email", type: .scalar(String.self)),
        GraphQLField("telephone", type: .scalar(String.self)),
        GraphQLField("fax", type: .scalar(String.self)),
        GraphQLField("address", type: .scalar(String.self)),
        GraphQLField("website", type: .scalar(String.self)),
        GraphQLField("type", type: .scalar(UserCateogry.self)),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID? = nil, name: String? = nil, email: String? = nil, telephone: String? = nil, fax: String? = nil, address: String? = nil, website: String? = nil, type: UserCateogry? = nil) {
        self.init(unsafeResultMap: ["__typename": "Clinic", "id": id, "name": name, "email": email, "telephone": telephone, "fax": fax, "address": address, "website": website, "type": type])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID? {
        get {
          return resultMap["id"] as? GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String? {
        get {
          return resultMap["name"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "name")
        }
      }

      public var email: String? {
        get {
          return resultMap["email"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "email")
        }
      }

      public var telephone: String? {
        get {
          return resultMap["telephone"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "telephone")
        }
      }

      public var fax: String? {
        get {
          return resultMap["fax"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "fax")
        }
      }

      public var address: String? {
        get {
          return resultMap["address"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "address")
        }
      }

      public var website: String? {
        get {
          return resultMap["website"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "website")
        }
      }

      public var type: UserCateogry? {
        get {
          return resultMap["type"] as? UserCateogry
        }
        set {
          resultMap.updateValue(newValue, forKey: "type")
        }
      }
    }
  }
}

public final class ProfileQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    query Profile {
      profile {
        __typename
        type
        ...profile_details
        help_and_info
        signature
      }
    }
    """

  public let operationName = "Profile"

  public var queryDocument: String { return operationDefinition.appending(ProfileDetails.fragmentDefinition) }

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("profile", type: .object(Profile.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(profile: Profile? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "profile": profile.flatMap { (value: Profile) -> ResultMap in value.resultMap }])
    }

    /// Current clinician's profile
    public var profile: Profile? {
      get {
        return (resultMap["profile"] as? ResultMap).flatMap { Profile(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "profile")
      }
    }

    public struct Profile: GraphQLSelectionSet {
      public static let possibleTypes = ["Profile"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("type", type: .scalar(UserCateogry.self)),
        GraphQLFragmentSpread(ProfileDetails.self),
        GraphQLField("help_and_info", type: .scalar(String.self)),
        GraphQLField("signature", type: .scalar(String.self)),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(type: UserCateogry? = nil, icd_9: String? = nil, icd_10: String? = nil, helpAndInfo: String? = nil, signature: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "Profile", "type": type, "icd_9": icd_9, "icd_10": icd_10, "help_and_info": helpAndInfo, "signature": signature])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var type: UserCateogry? {
        get {
          return resultMap["type"] as? UserCateogry
        }
        set {
          resultMap.updateValue(newValue, forKey: "type")
        }
      }

      public var helpAndInfo: String? {
        get {
          return resultMap["help_and_info"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "help_and_info")
        }
      }

      public var signature: String? {
        get {
          return resultMap["signature"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "signature")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var profileDetails: ProfileDetails {
          get {
            return ProfileDetails(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class RptfilesQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    query Rptfiles {
      rptfiles {
        __typename
        content
      }
    }
    """

  public let operationName = "Rptfiles"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("rptfiles", type: .list(.object(Rptfile.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(rptfiles: [Rptfile?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "rptfiles": rptfiles.flatMap { (value: [Rptfile?]) -> [ResultMap?] in value.map { (value: Rptfile?) -> ResultMap? in value.flatMap { (value: Rptfile) -> ResultMap in value.resultMap } } }])
    }

    /// list rpt files
    public var rptfiles: [Rptfile?]? {
      get {
        return (resultMap["rptfiles"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Rptfile?] in value.map { (value: ResultMap?) -> Rptfile? in value.flatMap { (value: ResultMap) -> Rptfile in Rptfile(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [Rptfile?]) -> [ResultMap?] in value.map { (value: Rptfile?) -> ResultMap? in value.flatMap { (value: Rptfile) -> ResultMap in value.resultMap } } }, forKey: "rptfiles")
      }
    }

    public struct Rptfile: GraphQLSelectionSet {
      public static let possibleTypes = ["RptfileType"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("content", type: .scalar(String.self)),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(content: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "RptfileType", "content": content])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var content: String? {
        get {
          return resultMap["content"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "content")
        }
      }
    }
  }
}

public final class UpdateRptfileMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    mutation UpdateRptfile($id: ID!, $rptfile: RptfileInput) {
      update_rptfile(id: $id, rptfile: $rptfile)
    }
    """

  public let operationName = "UpdateRptfile"

  public var id: GraphQLID
  public var rptfile: RptfileInput?

  public init(id: GraphQLID, rptfile: RptfileInput? = nil) {
    self.id = id
    self.rptfile = rptfile
  }

  public var variables: GraphQLMap? {
    return ["id": id, "rptfile": rptfile]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("update_rptfile", arguments: ["id": GraphQLVariable("id"), "rptfile": GraphQLVariable("rptfile")], type: .scalar(Bool.self)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(updateRptfile: Bool? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "update_rptfile": updateRptfile])
    }

    public var updateRptfile: Bool? {
      get {
        return resultMap["update_rptfile"] as? Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "update_rptfile")
      }
    }
  }
}

public final class SignsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    query Signs {
      signs {
        __typename
        ...SignDetails
      }
    }
    """

  public let operationName = "Signs"

  public var queryDocument: String { return operationDefinition.appending(SignDetails.fragmentDefinition) }

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("signs", type: .list(.object(Sign.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(signs: [Sign?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "signs": signs.flatMap { (value: [Sign?]) -> [ResultMap?] in value.map { (value: Sign?) -> ResultMap? in value.flatMap { (value: Sign) -> ResultMap in value.resultMap } } }])
    }

    /// list signs
    public var signs: [Sign?]? {
      get {
        return (resultMap["signs"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Sign?] in value.map { (value: ResultMap?) -> Sign? in value.flatMap { (value: ResultMap) -> Sign in Sign(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [Sign?]) -> [ResultMap?] in value.map { (value: Sign?) -> ResultMap? in value.flatMap { (value: Sign) -> ResultMap in value.resultMap } } }, forKey: "signs")
      }
    }

    public struct Sign: GraphQLSelectionSet {
      public static let possibleTypes = ["Sign"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(SignDetails.self),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID? = nil, name: String? = nil, image: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "Sign", "id": id, "name": name, "image": image])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var signDetails: SignDetails {
          get {
            return SignDetails(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class UpdateSignMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    mutation UpdateSign($id: ID!, $sign: SignInput) {
      update_sign(id: $id, sign: $sign)
    }
    """

  public let operationName = "UpdateSign"

  public var id: GraphQLID
  public var sign: SignInput?

  public init(id: GraphQLID, sign: SignInput? = nil) {
    self.id = id
    self.sign = sign
  }

  public var variables: GraphQLMap? {
    return ["id": id, "sign": sign]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("update_sign", arguments: ["id": GraphQLVariable("id"), "sign": GraphQLVariable("sign")], type: .scalar(Bool.self)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(updateSign: Bool? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "update_sign": updateSign])
    }

    public var updateSign: Bool? {
      get {
        return resultMap["update_sign"] as? Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "update_sign")
      }
    }
  }
}

public struct AudioDetails: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition =
    """
    fragment AudioDetails on Audio {
      __typename
      category
      file_file_name
      id
      word_list
      alias
    }
    """

  public static let possibleTypes = ["Audio"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("category", type: .scalar(String.self)),
    GraphQLField("file_file_name", type: .scalar(String.self)),
    GraphQLField("id", type: .scalar(GraphQLID.self)),
    GraphQLField("word_list", type: .list(.scalar(String.self))),
    GraphQLField("alias", type: .scalar(String.self)),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(category: String? = nil, fileFileName: String? = nil, id: GraphQLID? = nil, wordList: [String?]? = nil, alias: String? = nil) {
    self.init(unsafeResultMap: ["__typename": "Audio", "category": category, "file_file_name": fileFileName, "id": id, "word_list": wordList, "alias": alias])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var category: String? {
    get {
      return resultMap["category"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "category")
    }
  }

  public var fileFileName: String? {
    get {
      return resultMap["file_file_name"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "file_file_name")
    }
  }

  public var id: GraphQLID? {
    get {
      return resultMap["id"] as? GraphQLID
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
    }
  }

  public var wordList: [String?]? {
    get {
      return resultMap["word_list"] as? [String?]
    }
    set {
      resultMap.updateValue(newValue, forKey: "word_list")
    }
  }

  public var alias: String? {
    get {
      return resultMap["alias"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "alias")
    }
  }
}

public struct ClinicianDetails: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition =
    """
    fragment ClinicianDetails on Clinician {
      __typename
      id
      name
      email
      degrees
      certification
      pcp
      clinics {
        __typename
        name
      }
      disabled
    }
    """

  public static let possibleTypes = ["Clinician"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("id", type: .scalar(GraphQLID.self)),
    GraphQLField("name", type: .scalar(String.self)),
    GraphQLField("email", type: .scalar(String.self)),
    GraphQLField("degrees", type: .scalar(String.self)),
    GraphQLField("certification", type: .scalar(String.self)),
    GraphQLField("pcp", type: .scalar(Bool.self)),
    GraphQLField("clinics", type: .list(.object(Clinic.selections))),
    GraphQLField("disabled", type: .scalar(Bool.self)),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID? = nil, name: String? = nil, email: String? = nil, degrees: String? = nil, certification: String? = nil, pcp: Bool? = nil, clinics: [Clinic?]? = nil, disabled: Bool? = nil) {
    self.init(unsafeResultMap: ["__typename": "Clinician", "id": id, "name": name, "email": email, "degrees": degrees, "certification": certification, "pcp": pcp, "clinics": clinics.flatMap { (value: [Clinic?]) -> [ResultMap?] in value.map { (value: Clinic?) -> ResultMap? in value.flatMap { (value: Clinic) -> ResultMap in value.resultMap } } }, "disabled": disabled])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: GraphQLID? {
    get {
      return resultMap["id"] as? GraphQLID
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
    }
  }

  public var name: String? {
    get {
      return resultMap["name"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "name")
    }
  }

  public var email: String? {
    get {
      return resultMap["email"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "email")
    }
  }

  public var degrees: String? {
    get {
      return resultMap["degrees"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "degrees")
    }
  }

  public var certification: String? {
    get {
      return resultMap["certification"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "certification")
    }
  }

  public var pcp: Bool? {
    get {
      return resultMap["pcp"] as? Bool
    }
    set {
      resultMap.updateValue(newValue, forKey: "pcp")
    }
  }

  public var clinics: [Clinic?]? {
    get {
      return (resultMap["clinics"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Clinic?] in value.map { (value: ResultMap?) -> Clinic? in value.flatMap { (value: ResultMap) -> Clinic in Clinic(unsafeResultMap: value) } } }
    }
    set {
      resultMap.updateValue(newValue.flatMap { (value: [Clinic?]) -> [ResultMap?] in value.map { (value: Clinic?) -> ResultMap? in value.flatMap { (value: Clinic) -> ResultMap in value.resultMap } } }, forKey: "clinics")
    }
  }

  public var disabled: Bool? {
    get {
      return resultMap["disabled"] as? Bool
    }
    set {
      resultMap.updateValue(newValue, forKey: "disabled")
    }
  }

  public struct Clinic: GraphQLSelectionSet {
    public static let possibleTypes = ["Clinic"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("name", type: .scalar(String.self)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(name: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "Clinic", "name": name])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var name: String? {
      get {
        return resultMap["name"] as? String
      }
      set {
        resultMap.updateValue(newValue, forKey: "name")
      }
    }
  }
}

public struct LocalClinicDetails: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition =
    """
    fragment LocalClinicDetails on LocalClinic {
      __typename
      id
      name
      email
      address
      tel
      fax
    }
    """

  public static let possibleTypes = ["LocalClinic"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("id", type: .scalar(GraphQLID.self)),
    GraphQLField("name", type: .scalar(String.self)),
    GraphQLField("email", type: .scalar(String.self)),
    GraphQLField("address", type: .scalar(String.self)),
    GraphQLField("tel", type: .scalar(String.self)),
    GraphQLField("fax", type: .scalar(String.self)),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID? = nil, name: String? = nil, email: String? = nil, address: String? = nil, tel: String? = nil, fax: String? = nil) {
    self.init(unsafeResultMap: ["__typename": "LocalClinic", "id": id, "name": name, "email": email, "address": address, "tel": tel, "fax": fax])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: GraphQLID? {
    get {
      return resultMap["id"] as? GraphQLID
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
    }
  }

  public var name: String? {
    get {
      return resultMap["name"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "name")
    }
  }

  public var email: String? {
    get {
      return resultMap["email"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "email")
    }
  }

  public var address: String? {
    get {
      return resultMap["address"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "address")
    }
  }

  public var tel: String? {
    get {
      return resultMap["tel"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "tel")
    }
  }

  public var fax: String? {
    get {
      return resultMap["fax"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "fax")
    }
  }
}

public struct LocalClinicianDetails: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition =
    """
    fragment LocalClinicianDetails on LocalClinician {
      __typename
      id
      name
      email
      certification
      degrees
      pcp
    }
    """

  public static let possibleTypes = ["LocalClinician"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("id", type: .scalar(GraphQLID.self)),
    GraphQLField("name", type: .scalar(String.self)),
    GraphQLField("email", type: .scalar(String.self)),
    GraphQLField("certification", type: .scalar(String.self)),
    GraphQLField("degrees", type: .scalar(String.self)),
    GraphQLField("pcp", type: .scalar(Bool.self)),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID? = nil, name: String? = nil, email: String? = nil, certification: String? = nil, degrees: String? = nil, pcp: Bool? = nil) {
    self.init(unsafeResultMap: ["__typename": "LocalClinician", "id": id, "name": name, "email": email, "certification": certification, "degrees": degrees, "pcp": pcp])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: GraphQLID? {
    get {
      return resultMap["id"] as? GraphQLID
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
    }
  }

  public var name: String? {
    get {
      return resultMap["name"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "name")
    }
  }

  public var email: String? {
    get {
      return resultMap["email"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "email")
    }
  }

  public var certification: String? {
    get {
      return resultMap["certification"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "certification")
    }
  }

  public var degrees: String? {
    get {
      return resultMap["degrees"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "degrees")
    }
  }

  public var pcp: Bool? {
    get {
      return resultMap["pcp"] as? Bool
    }
    set {
      resultMap.updateValue(newValue, forKey: "pcp")
    }
  }
}

public struct PatientDetails: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition =
    """
    fragment PatientDetails on Patient {
      __typename
      city
      created_at
      date_of_birth
      first_name
      gender
      patient_id
      id
      last_name
      mailing_address_1
      mailing_address_2
      phone_number
      state
      updated_at
      zip
      email
      insurance
      ssn
      icd_9
      icd_10
    }
    """

  public static let possibleTypes = ["Patient"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("city", type: .scalar(String.self)),
    GraphQLField("created_at", type: .scalar(String.self)),
    GraphQLField("date_of_birth", type: .scalar(String.self)),
    GraphQLField("first_name", type: .scalar(String.self)),
    GraphQLField("gender", type: .scalar(Genders.self)),
    GraphQLField("patient_id", type: .scalar(String.self)),
    GraphQLField("id", type: .scalar(GraphQLID.self)),
    GraphQLField("last_name", type: .scalar(String.self)),
    GraphQLField("mailing_address_1", type: .scalar(String.self)),
    GraphQLField("mailing_address_2", type: .scalar(String.self)),
    GraphQLField("phone_number", type: .scalar(String.self)),
    GraphQLField("state", type: .scalar(String.self)),
    GraphQLField("updated_at", type: .scalar(String.self)),
    GraphQLField("zip", type: .scalar(String.self)),
    GraphQLField("email", type: .scalar(String.self)),
    GraphQLField("insurance", type: .scalar(String.self)),
    GraphQLField("ssn", type: .scalar(String.self)),
    GraphQLField("icd_9", type: .scalar(String.self)),
    GraphQLField("icd_10", type: .scalar(String.self)),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(city: String? = nil, createdAt: String? = nil, dateOfBirth: String? = nil, firstName: String? = nil, gender: Genders? = nil, patientId: String? = nil, id: GraphQLID? = nil, lastName: String? = nil, mailingAddress_1: String? = nil, mailingAddress_2: String? = nil, phoneNumber: String? = nil, state: String? = nil, updatedAt: String? = nil, zip: String? = nil, email: String? = nil, insurance: String? = nil, ssn: String? = nil, icd_9: String? = nil, icd_10: String? = nil) {
    self.init(unsafeResultMap: ["__typename": "Patient", "city": city, "created_at": createdAt, "date_of_birth": dateOfBirth, "first_name": firstName, "gender": gender, "patient_id": patientId, "id": id, "last_name": lastName, "mailing_address_1": mailingAddress_1, "mailing_address_2": mailingAddress_2, "phone_number": phoneNumber, "state": state, "updated_at": updatedAt, "zip": zip, "email": email, "insurance": insurance, "ssn": ssn, "icd_9": icd_9, "icd_10": icd_10])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var city: String? {
    get {
      return resultMap["city"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "city")
    }
  }

  public var createdAt: String? {
    get {
      return resultMap["created_at"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "created_at")
    }
  }

  public var dateOfBirth: String? {
    get {
      return resultMap["date_of_birth"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "date_of_birth")
    }
  }

  public var firstName: String? {
    get {
      return resultMap["first_name"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "first_name")
    }
  }

  public var gender: Genders? {
    get {
      return resultMap["gender"] as? Genders
    }
    set {
      resultMap.updateValue(newValue, forKey: "gender")
    }
  }

  public var patientId: String? {
    get {
      return resultMap["patient_id"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "patient_id")
    }
  }

  public var id: GraphQLID? {
    get {
      return resultMap["id"] as? GraphQLID
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
    }
  }

  public var lastName: String? {
    get {
      return resultMap["last_name"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "last_name")
    }
  }

  public var mailingAddress_1: String? {
    get {
      return resultMap["mailing_address_1"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "mailing_address_1")
    }
  }

  public var mailingAddress_2: String? {
    get {
      return resultMap["mailing_address_2"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "mailing_address_2")
    }
  }

  public var phoneNumber: String? {
    get {
      return resultMap["phone_number"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "phone_number")
    }
  }

  public var state: String? {
    get {
      return resultMap["state"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "state")
    }
  }

  public var updatedAt: String? {
    get {
      return resultMap["updated_at"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "updated_at")
    }
  }

  public var zip: String? {
    get {
      return resultMap["zip"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "zip")
    }
  }

  public var email: String? {
    get {
      return resultMap["email"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "email")
    }
  }

  public var insurance: String? {
    get {
      return resultMap["insurance"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "insurance")
    }
  }

  public var ssn: String? {
    get {
      return resultMap["ssn"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "ssn")
    }
  }

  public var icd_9: String? {
    get {
      return resultMap["icd_9"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "icd_9")
    }
  }

  public var icd_10: String? {
    get {
      return resultMap["icd_10"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "icd_10")
    }
  }
}

public struct TestDetails: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition =
    """
    fragment TestDetails on Test {
      __typename
      comment
      created_at
      id
      kind
      result
      updated_at
    }
    """

  public static let possibleTypes = ["Test"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("comment", type: .scalar(String.self)),
    GraphQLField("created_at", type: .scalar(String.self)),
    GraphQLField("id", type: .scalar(GraphQLID.self)),
    GraphQLField("kind", type: .scalar(String.self)),
    GraphQLField("result", type: .scalar(String.self)),
    GraphQLField("updated_at", type: .scalar(String.self)),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(comment: String? = nil, createdAt: String? = nil, id: GraphQLID? = nil, kind: String? = nil, result: String? = nil, updatedAt: String? = nil) {
    self.init(unsafeResultMap: ["__typename": "Test", "comment": comment, "created_at": createdAt, "id": id, "kind": kind, "result": result, "updated_at": updatedAt])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var comment: String? {
    get {
      return resultMap["comment"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "comment")
    }
  }

  public var createdAt: String? {
    get {
      return resultMap["created_at"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "created_at")
    }
  }

  public var id: GraphQLID? {
    get {
      return resultMap["id"] as? GraphQLID
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
    }
  }

  public var kind: String? {
    get {
      return resultMap["kind"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "kind")
    }
  }

  public var result: String? {
    get {
      return resultMap["result"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "result")
    }
  }

  public var updatedAt: String? {
    get {
      return resultMap["updated_at"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "updated_at")
    }
  }
}

public struct ProfileDetails: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition =
    """
    fragment profile_details on Profile {
      __typename
      icd_9
      icd_10
      help_and_info
    }
    """

  public static let possibleTypes = ["Profile"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("icd_9", type: .scalar(String.self)),
    GraphQLField("icd_10", type: .scalar(String.self)),
    GraphQLField("help_and_info", type: .scalar(String.self)),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(icd_9: String? = nil, icd_10: String? = nil, helpAndInfo: String? = nil) {
    self.init(unsafeResultMap: ["__typename": "Profile", "icd_9": icd_9, "icd_10": icd_10, "help_and_info": helpAndInfo])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var icd_9: String? {
    get {
      return resultMap["icd_9"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "icd_9")
    }
  }

  public var icd_10: String? {
    get {
      return resultMap["icd_10"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "icd_10")
    }
  }

  public var helpAndInfo: String? {
    get {
      return resultMap["help_and_info"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "help_and_info")
    }
  }
}

public struct SignDetails: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition =
    """
    fragment SignDetails on Sign {
      __typename
      id
      name
      image
    }
    """

  public static let possibleTypes = ["Sign"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("id", type: .scalar(GraphQLID.self)),
    GraphQLField("name", type: .scalar(String.self)),
    GraphQLField("image", type: .scalar(String.self)),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID? = nil, name: String? = nil, image: String? = nil) {
    self.init(unsafeResultMap: ["__typename": "Sign", "id": id, "name": name, "image": image])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: GraphQLID? {
    get {
      return resultMap["id"] as? GraphQLID
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
    }
  }

  public var name: String? {
    get {
      return resultMap["name"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "name")
    }
  }

  public var image: String? {
    get {
      return resultMap["image"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "image")
    }
  }
}
