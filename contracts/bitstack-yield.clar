;; Title: BitStack Yield Protocol
;;
;; Summary:
;; A secure, multi-protocol yield aggregation platform for Bitcoin assets on Stacks.
;; BitStack Yield optimizes returns by dynamically allocating deposits across various 
;; DeFi protocols while maintaining strict security controls.
;;
;; Description:
;; BitStack Yield enables users to deposit SIP-010 tokens and earn optimized yields across
;; multiple whitelisted protocols. The contract implements comprehensive security measures,
;; including emergency shutdown capabilities, deposit limits, and protocol whitelisting.
;; Administrators can manage protocols, set APY rates, and configure platform parameters
;; to ensure optimal performance and security.

;; Constants

;; Authorization
(define-constant contract-owner tx-sender)
(define-constant PROTOCOL-ACTIVE true)
(define-constant PROTOCOL-INACTIVE false)

;; Limits and Rates
(define-constant MAX-PROTOCOL-ID u100)
(define-constant MAX-APY u10000) ;; 100% APY in basis points
(define-constant MIN-APY u0)

;; Error Codes
(define-constant ERR-NOT-AUTHORIZED (err u1000))
(define-constant ERR-INVALID-AMOUNT (err u1001))
(define-constant ERR-INSUFFICIENT-BALANCE (err u1002))
(define-constant ERR-PROTOCOL-NOT-WHITELISTED (err u1003))
(define-constant ERR-STRATEGY-DISABLED (err u1004))
(define-constant ERR-MAX-DEPOSIT-REACHED (err u1005))
(define-constant ERR-MIN-DEPOSIT-NOT-MET (err u1006))
(define-constant ERR-INVALID-PROTOCOL-ID (err u1007))
(define-constant ERR-PROTOCOL-EXISTS (err u1008))
(define-constant ERR-INVALID-APY (err u1009))
(define-constant ERR-INVALID-NAME (err u1010))
(define-constant ERR-INVALID-TOKEN (err u1011))
(define-constant ERR-TOKEN-NOT-WHITELISTED (err u1012))

;; Data Variables

(define-data-var total-tvl uint u0)
(define-data-var platform-fee-rate uint u100) ;; 1% (base 10000)
(define-data-var min-deposit uint u100000) ;; Minimum deposit in sats
(define-data-var max-deposit uint u1000000000) ;; Maximum deposit in sats
(define-data-var emergency-shutdown bool false)

;; Data Maps

;; User data
(define-map user-deposits
  { user: principal }
  {
    amount: uint,
    last-deposit-block: uint,
  }
)

(define-map user-rewards
  { user: principal }
  {
    pending: uint,
    claimed: uint,
  }
)

;; Protocol data
(define-map protocols
  { protocol-id: uint }
  {
    name: (string-ascii 64),
    active: bool,
    apy: uint,
  }
)