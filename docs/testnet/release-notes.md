## Release notes

### v0.7.0

We are currently on our second testnet, and the first open testnet release since the launch of the Secret Network.

This release includes full secret contract functionality, stability, network configuratin, and many other changes.

#### CLI

* The default coin type for HD derivation in the CLI has changed from 118 (ATOM) to 529 (SCRT). To revert to the previous scheme,
 use the flag `--legacy-hd-path`. Due to the way the cosmos ledger app functions, this flag must be used when adding ledger keys.
 
* You can now use `--label` to execute contracts instead of using a contract address. Use with the flag `--label` and omit the contract address
(not available for queries on this release)

* The default `--gas-prices` for the CLI is set to `1uscrt`

* Fixed a bug that caused the flag `--generate-only` to function incorrectly

* Added new secretd commands:
  * `secretd check-enclave` - will check the enclave status. Use this to check if SGX is working
  * `secretd reset-enclave` - will delete registration specific files. Use when reseting a node using `unsafe-reset-all` or when debugging the registration process


#### Network

* `SW_HARDENING_AND_CONFIGURATION_NEEDED` is now an acceptable attestation status _for this testnet_

* The default `min-gas-prices` for validators is set by default to __1uscrt__

* Increased `timeout_precommit` to 2s from 1s to allow more time to collect precommits from validators for long executions

* Set max gas per block to 10,000,000 gas

* Added an option to set max query gas allowed per node. The default is set at 3,000,000 gas. You can find this value in the `~/.sceretd/config/app.toml`

#### Contracts

* This version will require any previous contracts to be recompiled using the "v0.7.0" branch & updates to the NPM package

* Added functionality for `external queries`. This allows a contract to query the chain state, or another contract mid-execution

* Changed the Wasm message types to include a new field: `callback_code_hash`. This field must include the code hash of 
any contracts you wish to send a message to, from another contract

* Added Staking for secret contracts! You can now perform staking operations directly from secret contracts

#### Registration Process

* Added more detail in on-chain verification. You should now see the exact reason for reigstration failure returned

* Added local verification during attestation. `Platform Okay!` will be printed out if the platform is compatable with the 
target network, as well as additional detail if patching is required

#### General

* Changed the .deb installer to choose the user that runs the command rather than the terminal owner
* Security and stablility fixes

### v0.5.0

Our initial testnet release.

#### Network

* Added SGX as a requirement for all network nodes. To sync with the network, a node must go through the registration process

#### CLI

* Added the `compute` module, which is used to interact with secret contracts
* Added the `register` module, which is used to authenticate new nodes before they can sync with the network
* Replaced the standard cosmwasm command `query tx contract-state smart` with `query tx query`

#### Contracts

* Added initial secret contract functionality! This release does not yet contain external querying, or staking
* Published SecretJS to NPM for usage in browsers and node.js apps

#### General

* Created Azure images for easy deployment. These are available as quickstart templates, and will be available on the marketplace in the future