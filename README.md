# BooCoin (BOO)

A SIP-010-like fungible token implemented in Clarity using Clarinet.

## Features
- SIP-010-style interface: transfer, get-balance, get-total-supply, decimals, symbol, name
- Owner-only minting; any holder can burn their own tokens

## Project structure
- `Clarinet.toml` — Clarinet project manifest
- `contracts/sip010-ft-trait.clar` — Local SIP-010-like trait definition
- `contracts/boocoin.clar` — BooCoin token implementation

## Prerequisites
- Clarinet installed (check with `clarinet -V`).

## Common commands
- Syntax/type check:
  ```bash
  clarinet check
  ```
- REPL console with contracts loaded:
  ```bash
  clarinet console
  ```

## Example usage (in console)
Mint, transfer, and check balances (replace SP… with your principal IDs in console):
```clarity
(contract-call? .boocoin mint u1000000 tx-sender) ;; owner mints to self
(contract-call? .boocoin transfer u500000 tx-sender 'SP3FBR2AGKX... (some 0x))
(contract-call? .boocoin get-balance tx-sender)
(contract-call? .boocoin get-total-supply)
```

## Notes
- Decimals: 6 (`TOKEN-DECIMALS = u6`)
- Symbol: `BOO`, Name: `boocoin`
- This repo includes a local trait for simplicity; you can swap to a canonical SIP-010 trait as needed and adjust signatures accordingly.
