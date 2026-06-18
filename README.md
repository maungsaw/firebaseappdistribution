# Flutter Android CI/CD Automation Engine

This repository is equipped with an automated Continuous Integration and Continuous Deployment (CI/CD) pipeline. Every code push or merge into the primary distribution branches automatically triggers a quality analysis suite, compiles a production-ready application binary, and deploys it over-the-air to the QA testing cluster[cite: 1, 2].

---

## 🏗️ Pipeline Architecture

The automated delivery pipeline handles the entire lifecycle from code submission to tester delivery[cite: 1, 2]:

1. **Environment Provisioning:** Installs Java 17 (Temurin) and the stable Flutter SDK with pipeline caching enabled[cite: 1, 2].
2. **Quality Gates:** Executes static analysis (`flutter analyze`) and unit testing suites (`flutter test`)[cite: 1, 2].
3. **Compilation:** Generates a production-optimized, release-ready `.apk` binary file[cite: 1, 2].
4. **Distribution:** Securely uploads the compiled artifact via a Google Service Account key directly to the Firebase platform[cite: 1, 2].

---

## 🔑 CI/CD Infrastructure Prerequisites

To ensure proper workflow execution on GitHub Actions, the following encrypted variables must be explicitly defined within your GitHub repository secrets dashboard:

### 1. Extraction of Variables

#### 📱 Firebase App ID (`FIREBASE_APP_ID`)
1. Open the [Firebase Console](https://console.firebase.google.com/) and navigate to your target project[cite: 1, 2].
2. Click the **Gear Icon (⚙️)** next to *Project Overview* and select **Project settings**[cite: 1, 2].
3. Under the **General** tab, scroll to **Your apps** and select your explicit Android configuration[cite: 1, 2].
4. Copy the unique **App ID** string (Format sequence: `1:123456789012:android:a1b2c3d4e5f6g7h8`)[cite: 1, 2].

#### 🔐 Google Service Account JSON Key (`FIREBASE_CREDENTIALS`)
1. Within Firebase **Project settings**, shift horizontally to the **Service accounts** tab[cite: 1, 2].
2. Click **Generate new private key** and confirm the structural security warning dialog[cite: 1, 2].
3. A secure file carrying a `.json` extension will download locally to your machine[cite: 1, 2].
4. Open this file using a code editor and copy the **entire JSON block structure** from the opening brace `{` to the closing brace `}` inclusive[cite: 1, 2].

### 2. Injecting Repository Secrets
1. Navigate to your repository hosted on **GitHub**.
2. Select the **Settings** configuration option across the top global navigation banner.
3. On the left vertical menu bar, expand **Secrets and variables** and select **Actions**.
4. Use the **New repository secret** button to save both entities exactly as described below:

| Secret Key Name | Required Source Value & Structural Expectation |
| :--- | :--- |
| `FIREBASE_APP_ID` | The complete, unmodified Android App ID string extracted from the Firebase settings. |
| `FIREBASE_CREDENTIALS` | The absolute code contents extracted from your downloaded Google Cloud Service Account private key JSON document. |
