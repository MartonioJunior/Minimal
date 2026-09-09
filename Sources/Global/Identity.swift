//
//  Identity.swift
//  Minimal
//
//  Created by Martônio Júnior on 04/09/2026.
//

func identity<T>(_: T.Type = T.self) -> (T) -> T { \.self }
