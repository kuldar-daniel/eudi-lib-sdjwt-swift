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

extension Encodable {
  func toJSONString(outputFormatting: JSONEncoder.OutputFormatting = .prettyPrinted) throws -> String {
    let encoder = JSONEncoder()
    encoder.outputFormatting = outputFormatting

    let jsonData = try encoder.encode(self)

    if let jsonString = String(data: jsonData, encoding: .utf8) {
      return jsonString
    } else {
      throw SDJWTError.serializationError
    }
  }

  func toJSONData() throws -> Data {
    let encoder = JSONEncoder()
    let jsonData = try encoder.encode(self)
    return jsonData
  }
}
