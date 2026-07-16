# Security flows

## Login + device register

1. User submits trimmed phone + password.
2. `LoginUseCase` → public POST `/auth/login`.
3. Persist `access_token`, `refresh_token`.
4. Emit `AuthLoginSuccessState` (router → home).
5. Background: `RegisterDeviceUseCase` → protected POST `/auth/devices-register` with:
   - `device_id`, `model` from `DeviceInfoService`
   - `fcm_token` = FCM or Pushy token from `PushTokenService`

Register errors: log only; keep session.

## Remote wipe

```
Backend POST /users/{userId}/wipe
  → FCM/Pushy data payload (signed)
  → App validate HMAC + deviceId + userId + expiresAt + nonce
  → Best-effort POST /devices/wipe-ack (Bearer access_token)
  → Wipe local DB + cache + files
```

- Entry: FCM and Pushy handlers → `performRemoteWipeIfRequested`
- Require signed command; reject plain `action: WIPE_DATA`
- Server command fields: `signature`, `action`, `issuedAt`, `expiresAt`,
  `commandId`, `userId`, `nonce`, `deviceId`
- HMAC secret (server push): fixed `RemoteWipeCrypto.backendSharedSigningKey`
  (must match Agent App API)
- Canonical: `action|issuedAt|expiresAt|nonce|commandId|userId|deviceId`
- Signature encoding: Base64 (server) or hex (legacy envelopes)
- Legacy encrypted envelopes still use device-bound
  `{databasePwd}:{deviceId}:remote-wipe-sign:v1`
- On accept: wipe-ack (while token still present), then clean DB/cache/folders

## Phone security

- Capabilities from `DeviceAuthService`
- Session gate: `PhoneSecuritySession` (verify once per app launch until lock)
- UI: `PhoneSecurityCard` on settings; unlock dialogs for protected routes (e.g. User)
