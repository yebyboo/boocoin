(use-trait ft .sip010-ft-trait.sip010-ft-trait)

(define-constant ERR-NOT-AUTHORIZED u100)
(define-constant ERR-INSUFFICIENT-BALANCE u101)
(define-constant ERR-NO-OWNER u102)

(define-constant TOKEN-NAME "boocoin")
(define-constant TOKEN-SYMBOL "BOO")
(define-constant TOKEN-DECIMALS u6)

(define-data-var owner (optional principal) none)
(define-data-var total-supply uint u0)

(define-map balances { account: principal } { balance: uint })

(define-read-only (get-name)
  (ok TOKEN-NAME)
)

(define-read-only (get-symbol)
  (ok TOKEN-SYMBOL)
)

(define-read-only (get-decimals)
  (ok TOKEN-DECIMALS)
)

(define-read-only (get-total-supply)
  (ok (var-get total-supply))
)

(define-read-only (get-balance (who principal))
  (ok (balance-of who))
)

(define-private (balance-of (who principal))
  (default-to u0 (get balance (map-get? balances { account: who })))
)

(define-private (set-balance (who principal) (new-balance uint))
  (if (is-eq new-balance u0)
    (map-delete balances { account: who })
    (map-set balances { account: who } { balance: new-balance })
  )
)

(define-private (debit (who principal) (amount uint))
  (let ((bal (balance-of who)))
    (if (>= bal amount)
      (begin
        (set-balance who (- bal amount))
        (ok true)
      )
      (err ERR-INSUFFICIENT-BALANCE)
    )
  )
)

(define-private (credit (who principal) (amount uint))
  (let ((bal (balance-of who)))
    (begin
      (set-balance who (+ bal amount))
      true
    )
  )
)

(define-public (transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
  (if (is-eq tx-sender sender)
    (begin
      (try! (debit sender amount))
      (credit recipient amount)
      (ok true)
    )
    (err ERR-NOT-AUTHORIZED)
  )
)

(define-public (mint (amount uint) (recipient principal))
  (match (var-get owner)
    owner-principal (if (is-eq tx-sender owner-principal)
      (begin
      (credit recipient amount)
      (var-set total-supply (+ (var-get total-supply) amount))
      (ok true)
      )
      (err ERR-NOT-AUTHORIZED)
    )
    (err ERR-NO-OWNER)
  )
)

(define-public (burn (amount uint))
  (begin
    (try! (debit tx-sender amount))
    (var-set total-supply (- (var-get total-supply) amount))
    (ok true)
  )
)

(define-public (set-owner (who principal))
  (if (is-none (var-get owner))
    (begin
      (var-set owner (some who))
      (ok true)
    )
    (err ERR-NOT-AUTHORIZED)
  )
)

(impl-trait .sip010-ft-trait.sip010-ft-trait)
