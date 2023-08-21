import XCTest
@testable import eudi_lib_sdjwt_swift

final class IssuanceTests: XCTestCase {

    var signer = Signer()

    func testDisclsure() {
        let parts = ["_26bc4LT-ac6q2KI6cBW5es", "family_name", "Möbius"]
        let salt = parts[0]
        let key = parts[1]
        let value = parts [2]

        var disclosedClaim = DisclosedClaim(key, .init(value))

        let disclosure = try? disclosedClaim.base64Encode(saltProvider: Signer(saltProvider: MockSaltProvider(saltString: salt)).saltProvider)

        print(disclosure)
        print(disclosure?.flatString)

        XCTAssertTrue(disclosure?.flatString.contains("WyJfMjZiYzRMVC1hYzZxMktJNmNCVzVlcyIsICJmYW1pbHlfbmFtZSIsICJNw7ZiaXVzIl0") == true)
    }

    func testArray() {
        let parts = ["lklxF5jMYlGTPUovMNIvCA", "FR"]
        let key = "nationalities"
        let salt = parts[0]
        let value = parts[1]

        var disclosedClaim = DisclosedClaim(key, .array([.init(value)]))

        let disclosure = try? disclosedClaim.base64Encode(saltProvider: Signer(saltProvider: MockSaltProvider(saltString: salt)).saltProvider)

        print(disclosure)
        print(disclosure?.flatString)

        XCTAssertTrue(disclosure?.flatString.contains("WyJsa2x4RjVqTVlsR1RQVW92TU5JdkNBIiwgIkZSIl0") == true)

    }

    func testMixedArray() {
        let plainClaim = PlainClaim("nationalities", .array([.init("DE")]))
        var disclosedArray = DisclosedClaim("nationalities", .array([.init("FR")]))

        guard let encodedClaim = try? disclosedArray.base64Encode(saltProvider: MockSaltProvider(saltString: "lklxF5jMYlGTPUovMNIvCA")) else {
            XCTFail()
            return
        }

        let mixedClaim = MixedClaim(plainClaim: plainClaim,
                                    disclosedClaim: encodedClaim)

        print(mixedClaim)
        print(mixedClaim?.flatString)

        XCTAssertTrue(mixedClaim?.flatString.contains("WyJsa2x4RjVqTVlsR1RQVW92TU5JdkNBIiwgIkZSIl0") == true)
        XCTAssertTrue(mixedClaim?.flatString.contains("DE") == true)

    }

    func testFlatObjectIssueance() {
        let jsonString = """
        "address": {
          "street_address": "123 Main St",
          "locality": "Anytown",
          "region": "Anystate",
          "country": "US"
        }
        """

        @SDJWTBuilder
        var testJWT: [String: SDElementValue] {
            DisclosedClaim("sub", .base("6c5c0a49-b589-431d-bae7-219122a9ec2c"))
                .flatDisclose(signer: signer)
            PlainClaim("iss", .base("https://example.com/issuer"))
            PlainClaim("iat", .base(1516239022))
            PlainClaim("exp", .base(1735689661))
            DisclosedClaim("adress", .init(builder: {
                DisclosedClaim("street_address", .base("Schulstr. 12"))
                DisclosedClaim("locality", .base("Schulpforta"))
                DisclosedClaim("region", .base("Sachsen-Anhalt"))
                DisclosedClaim("country", .base("DE"))
            }))
            .flatDisclose(signer: signer)
        }

        let builder = Builder(signer: signer)
//        try? builder.encode(sdjwtRepresentation: testJWT)

        XCTAssertNotNil(try? builder.encode(sdjwtRepresentation: testJWT))
    }
}
