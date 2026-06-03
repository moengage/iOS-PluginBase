---
name: native-feature-implementation
description: Create a minor version PR for iOS-PluginBase based on a new native SDK API and SDK contract. Scaffolds the feature branch, implements the bridge method, updates constants, CHANGELOG, and version — then generates the branch locally via a CI script.
parameters:
  - name: "ticket_id"
    description: "JIRA ticket ID, e.g. 'MOEN-44072'. Extracted from command text if not supplied."
    optional: true
  - name: "feature_description"
    description: "Natural language description of the feature, including the native framework it belongs to — analytics, inapps, messaging, or core. E.g. 'set device attribute from analytics', 'disable in-apps from inapps', 'show nudge from inapps', 'reset user from core'."
  - name: "contract_pr_url"
    description: "GitHub PR URL in mobile-sdk-contracts that adds the feature contract. E.g. 'https://github.com/moengage/mobile-sdk-contracts/pull/12'."
  - name: "ios_native_version"
    description: "Minimum native iOS SDK version required for this feature. Updates sdkVerMin in package.json and adds an 'Updated MoEngage-iOS-SDK to X' CHANGELOG entry. E.g. '9.10.0'. Optional — if not provided, sdkVerMin is not updated."
    optional: true
  - name: "native_sdk_pr_url"
    description: "GitHub PR URL in MoEngage-iPhone-SDK that adds the native API. E.g. 'https://github.com/moengage/MoEngage-iPhone-SDK/pull/45'. Optional — if not provided, master branch is used."
    optional: true
---

# Minor Version PR — iOS-PluginBase

You are implementing a minor version change in `iOS-PluginBase` that bridges a new native iOS SDK
API to hybrid frameworks via the plugin bridge. The contract is defined in the
`mobile-sdk-contracts` repo on the provided `contract_branch`.

---

## Phase 0 — Clarify Inputs

### 0.1 Extract ticket ID
Scan the user's full command for `MOEN-\d+` → **`ticketId`**.
If not found in the command or parameters, ask before proceeding.

### 0.2 Confirm all required inputs are present
If either `feature_description` or `contract_pr_url` is missing, ask for them before proceeding.
`ios_native_version` is optional — do not ask for it if absent.

Derive:
- **`featureName`** — lowercase slug from `feature_description` (e.g. `disableinapps`)
- **`prNumber`** — numeric part of `contract_pr_url` (e.g. `12`)
- **`branchName`** — `feature/<ticketId>-<featureName>` (e.g. `feature/MOEN-44072-disableinapps`)

---

## Phase 1 — Read Contracts from PR (Hybrid ↔ PluginBase boundary)

This phase defines the **interface between the hybrid layer and PluginBase** — what method names
the hybrid SDK calls, and what payload shape it sends/receives. It has nothing to do with the
native iOS SDK.

### 1.1 Fetch PR file list

```bash
gh pr view <prNumber> --repo moengage/mobile-sdk-contracts --json title,body,files,headRefName
```

From the response extract:
- **`contractBranch`** — `headRefName`
- **`contractDir`** — directory component of each changed file path (e.g. `inApp` from `json/hybridToNative/inApp/showNudge.json`)
- **`hybridToNativeFiles`** — changed files under `json/hybridToNative/`
- **`nativeToHybridFiles`** — changed files under `json/nativeToHybrid/` (may be empty)

### 1.2 Read contract files and detect change type

From the PR file list, note for each file whether it was **added** (new) or **modified** (existing):

For each file in `hybridToNativeFiles`:
```
https://raw.githubusercontent.com/moengage/mobile-sdk-contracts/<contractBranch>/<path>
```
- Filename (without `.json`) = **method name**
- Content = **input payload schema**

For each file in `nativeToHybridFiles`:
```
https://raw.githubusercontent.com/moengage/mobile-sdk-contracts/<contractBranch>/<path>
```
- Content = **response payload schema**

### 1.3 Classify

First determine whether the contract file is new or modified:

| File status | Meaning |
 --- || --- | --- || --- | --- || --- |
 --- || **New file** added | New method — full bridge implementation needed (Phase 2 required) |
| **Existing file** modified | Payload change only — no new native API, no new bridge method |

For **payload changes on existing files**:

| Modified file | Implementation change |
 --- || --- | --- || --- | --- || --- |
 --- || `hybridToNative` modified | Hybrid sends additional fields to PluginBase → update the existing bridge method to extract and pass the new fields to the native SDK call |
| `nativeToHybrid` modified | Native sends additional fields back → update the existing response/event builder in `MoEngagePluginUtils` to include the new fields in the payload sent to hybrid |

For payload changes, **skip Phase 2** (no new native API needed) and go directly to Phase 3.

For new files, classify response presence and continue to Phase 2:

| New contract files | Classification |
 --- || --- | --- || --- | --- || --- |
 --- || `hybridToNative` only | **Fire-and-forget** — no response expected |
| both `hybridToNative` and `nativeToHybrid` | **Expects response** — type (2/3/4) resolved in Phase 2 |

Print a `### Contract Summary` with method name(s), file status (new/modified), payload schema changes, and classification.

---

## Phase 2 — Find the Native API (PluginBase ↔ Native boundary)

This phase defines the **interface between PluginBase and the native iOS SDK** — how PluginBase
calls the native SDK and how the native SDK returns its result. This determines the final bridge
type and the exact PluginBase method signature.

### 2a — Resolve source

**If `native_sdk_pr_url` was provided:**
Fetch the PR file list using the gh CLI:
```bash
gh pr view <prNumber> --repo moengage/MoEngage-iPhone-SDK --json title,body,files,headRefName
```
- Extract `nativeBranch` from `headRefName`
- Read each changed `.swift` file directly:
```
https://raw.githubusercontent.com/moengage/MoEngage-iPhone-SDK/<nativeBranch>/<path>
```

**If `native_sdk_pr_url` was NOT provided:**
Resolve the source path from the framework mentioned in `feature_description`:

| Framework keyword | Source path prefix | Public SDK class |
 --- || --- | --- || --- | --- || --- | --- || --- |
 --- || `analytics` | `Sources/MoEngageCore/Analytics/` | `MoEngageSDKAnalytics` |
| `inapps` | `Sources/MoEngageInApps/` | `MoEngageSDKInApp` |
| `messaging` | `Sources/MoEngageMessaging/` | `MoEngageSDKMessaging` |
| `core` | `Sources/MoEngageCore/` | `MoEngageSDKCore` |

Fetch the public SDK class file directly on `master`, e.g. for analytics:
```
https://raw.githubusercontent.com/moengage/MoEngage-iPhone-SDK/master/Sources/MoEngageCore/Analytics/Public/MoEngageSDKAnalytics.swift
```
If the method is not found in the main public class file, fall back to a targeted search:
```
https://api.github.com/search/code?q=<featureName>+repo:moengage/MoEngage-iPhone-SDK+language:Swift+path:Sources/<frameworkPath>
```

### 2b — Extract from native source and finalize type

**If Phase 1 found `hybridToNative` only (no response):**
No need to inspect the native signature for type — it is **Type 1** (fire-and-forget). Still read
the native signature to extract parameter names and any tvOS/availability guards.

**If Phase 1 found both `hybridToNative` and `nativeToHybrid` (response exists):**
Read the native method signature and apply this decision tree:

```
Native method has completionHandler / completionBlock / completion closure?
  YES → Ask the user:
        "Native API has a completion handler. How should PluginBase return the response to hybrid?
         1. completionBlock — PluginBase exposes a completionBlock, result passed directly to hybrid caller (Type 2)
         2. flushMessage — PluginBase emits the result as an event via the standard message handler (Type 3)"
        Wait for user's answer before continuing.

  NO (returns Void, no closure param) → native delivers result via protocol/delegate
        → Check the delegate protocol:
              Standard MoEngagePluginBridgeDelegate / flushMessage pipeline?
                YES → Type 3 (auto-determined, no need to ask)
              Feature-specific listener protocol requiring a dedicated NSObject handler?
                YES → Type 4 (auto-determined, no need to ask)
```

In both Type 3 and Type 4, **PluginBase → hybrid is always via listener/event** — never a completion block on the PluginBase method.

Extract:
- **Full method signature** (name, parameters, return type)
- **Parameter types** — especially enums (e.g. `MoEngageNudgePosition`)
- **Threading / availability** — `@MainActor`, `@available`, `#if os(tvOS)` guards
- **Closest existing bridge method** in `MoEngagePluginBridge.swift` to use as template

Type is fully determined here. Do **not** ask the user to confirm the type.

Print a `### Native API Summary` with the finalized type and reasoning.

---

## Phase 3 — Read Current PluginBase State

Read these files:

1. `Sources/MoEngagePluginBase/MoEngagePluginBridge.swift`
2. `Sources/MoEngagePluginBase/MoEngagePluginConstants.swift`
3. `Sources/MoEngagePluginBase/MoEngagePluginUtils.swift`
4. `Sources/MoEngagePluginBase/MoEngagePluginParser.swift`
5. `package.json` — current version and current `sdkVerMin`
6. `CHANGELOG.md` — format reference

Identify:
- Which `// MARK:` section in `MoEngagePluginBridge.swift` the new method belongs to
- Whether new constants are needed
- Whether a new parser/utility helper is needed or an existing one can be reused
- Current version (e.g. `6.9.0`) → new minor version (e.g. `6.10.0`)
- Current `sdkVerMin` → will be updated to `<ios_native_version>`

---

## Phase 4 — Propose Implementation Plan

Output a numbered checklist under `### Implementation Plan`:

1. Branch: `<branchName>`
2. Files to change and exactly what to add/modify in each:
   - `MoEngagePluginBridge.swift` — new bridge method (type determined in Phase 1)
   - `MoEngagePluginConstants.swift` — any new constant keys
   - `MoEngagePluginUtils.swift` — any new parser/helper (or "no change")
   - `package.json` — minor version bump + `sdkVerMin` → `<ios_native_version>`
   - `CHANGELOG.md` — new entry
3. tvOS guard if native API is iOS-only
4. Callback event wiring if Type 3

Ask: *"Does this plan look right before I implement?"* Wait for approval.

---

## Phase 5 — Implement

Once approved, implement **in this order**:

### 5a — Constants

Open `Sources/MoEngagePluginBase/MoEngagePluginConstants.swift`.

Add any new keys required by the contract payload inside the correct existing `struct`. Follow
existing naming: `static let camelCaseName = "camelCaseName"`. Do not create a new struct unless
the feature belongs to a completely new domain.

### 5b — Utils / Parser

Open `MoEngagePluginUtils.swift` or `MoEngagePluginParser.swift` as appropriate.

If the contract payload requires a new extractor, add a `static func` following existing patterns:
```swift
static func fetchXxx(from payload: [String: Any]) -> NativeType? { ... }
```
Reuse existing helpers wherever possible. Keep the bridge method thin — all payload construction
goes in `MoEngagePluginUtils`, all parsing in `MoEngagePluginParser`.

### 5c — Bridge method in MoEngagePluginBridge.swift

Add the new `@objc public func` under the correct `// MARK:` section.

**Rules that apply to all types:**
- Always `@objc public` — hybrid SDKs reach this via ObjC runtime or direct Swift call
- First parameter is always `_ payload: [String: Any]`
- Extract `identifier` via `MoEngagePluginUtils.fetchIdentifierFromPayload` first
- **Always pass `identifier` to every native API call** — the parameter label varies by framework; extract the correct label from the native method signature in Phase 2:

  | Framework | Typical label |
 --- |  --- |  --- || --- | --- || --- | --- || --- |
 --- |  | `analytics` | `forAppID:` or `workspaceId:` |
  | `inapps` | `forAppId:` |
  | `messaging` | `forAppId:` |
  | `core` | `workspaceId:` |
- Add `#if os(tvOS)` guard with a descriptive log if the native API is iOS-only
- Response payload keys must exactly match the `nativeToHybrid` contract file read in Phase 1

Read the relevant example file before generating code:

| Type | Example file |
 --- || --- | --- || --- | --- || --- |
 --- || Type 1 — fire-and-forget | `examples/Type1_FireAndForget.swift` |
| Type 2 — completion handler | `examples/Type2_CompletionHandler.swift` |
| Type 3 — flush event | `examples/Type3_FlushEvent.swift` |
| Type 4 — dedicated listener handler | `examples/Type4_DedicatedListenerHandler.swift` |

For **Type 4**, three things must be done:
1. A new file `MoEngagePlugin<Feature>ListenerHandler.swift` — the `NSObject` subclass conforming
   to the feature-specific listener protocol. The `init(identifier:)` calls `registerListenerInSDK()`
   which registers `self` with the native SDK immediately at construction time.
2. **Update `MoEngagePlugin.setDelegates()`** (in `MoEngagePlugin.swift`) — add a line to instantiate
   the listener handler once per SDK instance during module initialization:
   ```swift
   _ = MoEngagePlugin<Feature>ListenerHandler(identifier: identifier)
   ```
   Listener handlers are registered **once at SDK init**, not inside individual bridge method calls.
3. The bridge method in `MoEngagePluginBridge.swift` — calls the native method directly. Do **not**
   instantiate the listener handler inside the bridge method — it is already registered via `setDelegates()`.

Add `// TODO: verify listener protocol method name and error mapping` if the exact protocol
method signature is unknown.

---

### 5d + 5e — Version bump and CHANGELOG

Invoke the `version-update` skill with:
- `new_version` = next minor version (e.g. `6.9.0` → `6.10.0`)
- `changelog_entries` = `["[minor] Added support for <feature_description>"]` — **do NOT include the ticket ID in the changelog entry**
- `native_sdk_version` = `<ios_native_version>` — **only if `ios_native_version` was provided**; omit otherwise

When `ios_native_version` is provided, the `version-update` skill will:
- Set `sdkVerMin` → `<ios_native_version>` in `package.json`
- Append `Updated MoEngage-iOS-SDK to <ios_native_version>` to the CHANGELOG entry

When `ios_native_version` is **not** provided:
- `sdkVerMin` in `package.json` is left unchanged
- No SDK version line is added to the CHANGELOG

---

## Phase 6 — Branch, Commit, Push and PR

### 6.1 — Create branch and commit

```bash
# 1. Check status
git status

# 2. Create feature branch
git checkout -b <branchName>

# 3. Stage all changes (including any new files like ListenerHandler for Type 4)
git add -A

# 4. Commit
git commit -m "<ticketId>: Added support for <feature_description>"
```

If `git checkout -b` fails because the branch already exists, stop and ask the user whether to
delete it or pick a different name.

### 6.2 — Push and create PR

```bash
# 5. Push branch
git push -u origin <branchName>

# 6. Create PR targeting development
gh pr create \
  --repo moengage/iOS-PluginBase \
  --base development \
  --title "<ticketId>: Added support for <feature_description>" \
  --body "$(cat <<'EOF'
### Jira Ticket
https://moengagetrial.atlassian.net/browse/<ticketId>

### Description
Added support for <feature_description>

### Contract PR
<contract_pr_url>

### Native SDK
<native_sdk_pr_url or "moengage/MoEngage-iPhone-SDK @ master">

### Changes
- `MoEngagePluginBridge.swift` — <new method / updated method: methodName, type: 1/2/3/4>
- `MoEngagePluginConstants.swift` — <new constants or "no change">
- `MoEngagePluginUtils.swift` — <new helper or "no change">
- `package.json` — version <old> → <new>, sdkVerMin <old> → <ios_native_version>
- `CHANGELOG.md` — new entry
EOF
)"
```

Print the PR URL on completion.

---

## Phase 7 — Summary

Print:

```
PR:       <pr_url>
Branch:   <branchName>
Version:  <old> → <new>
sdkVerMin: <old> → <ios_native_version>   ← omit this line if ios_native_version not provided
Ticket:   <ticketId>
Contract PR: <contract_pr_url>

Files changed:
  - MoEngagePluginBridge.swift      (<new/updated> method: <methodName>, type: <1/2/3/4>)
  - MoEngagePluginConstants.swift   (new constants: <list> or "no change")
  - MoEngagePluginUtils.swift       (new helper: <funcName> or "no change")
  - package.json                    (version bump + sdkVerMin)
  - CHANGELOG.md                    (new entry)

Native SDK source: <native_sdk_pr_url or "moengage/MoEngage-iPhone-SDK @ master">
```
