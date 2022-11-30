//
//  AuthEntity.swift
//  WeatherApp
//
//  Created by Adem Tarhan on 3.11.2022.
//




enum AuthError: Error {
    case logInError
    case creatError
    case invalidPassword
    case invalidEmail
    case timeout
    case unKnownError
    case wrongPassword
}
