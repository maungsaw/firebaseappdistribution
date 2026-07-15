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

- Entry: FCM and Pushy notification handlers → `performRemoteWipeIfRequested`
- Require signed / encrypted envelope; reject plain `action: WIPE_DATA`
- On accept: clean DB, clear secure cache, remove folders

## Phone security

- Capabilities from `DeviceAuthService`
- Session gate: `PhoneSecuritySession` (verify once per app launch until lock)
- UI: `PhoneSecurityCard` on settings; unlock dialogs for protected routes (e.g. User)
