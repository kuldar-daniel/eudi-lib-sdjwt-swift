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

extension SignatureAlgorithm: CaseIterable {
  public static var allCases: [SignatureAlgorithm] {
    if #available(iOS 11, *) {
      return [.HS256, .HS384, .HS512, .RS256, .RS384, .RS512, .ES256, .ES384, .ES512, .PS256, .PS384, .PS512]
    } else {
      return [.HS256, .HS384, .HS512, .RS256, .RS384, .RS512, .ES256, .ES384, .ES512]
    }
  }
}
