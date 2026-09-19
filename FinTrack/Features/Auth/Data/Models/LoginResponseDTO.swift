//
//  LoginResponseDTO.swift
//  FinTrack
//

struct LoginResponseDTO: Decodable {
    let token: String
    let user: UserModel
}

extension LoginResponseDTO {
    func toEntity() -> AuthenticatedUser {
        AuthenticatedUser(
            user: user.toEntity(),
            token: token
        )
    }
}
