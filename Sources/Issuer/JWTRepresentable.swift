/*
 * Copyright (c) 2023 European Commission
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import Foundation
import JOSESwift
import SwiftyJSON

typealias Base64String = String
typealias UnsignedJWT = (header: JWSHeader, payload: Payload)

protocol JWTRepresentable {

  var header: JWSHeader { get }
  var payload: JSON { get }

  func asUnsignedJWT() throws -> UnsignedJWT
  func sign<KeyType>(signer: Signer<KeyType>) throws -> JWS

  init(header: JWSHeader, payload: JSON) throws
}

extension JWTRepresentable {
  func asUnsignedJWT() throws -> UnsignedJWT {
    let payload = Payload(try payload.rawData())
    return(header, payload)
  }
}
