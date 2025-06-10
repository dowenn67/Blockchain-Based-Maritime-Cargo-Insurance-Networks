;; Maritime Insurance Provider Verification Contract
;; Manages verification and registration of maritime insurance providers

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u100))
(define-constant ERR_ALREADY_VERIFIED (err u101))
(define-constant ERR_NOT_FOUND (err u102))
(define-constant ERR_INVALID_LICENSE (err u103))

;; Data structures
(define-map verified-insurers
  { insurer: principal }
  {
    license-number: (string-ascii 50),
    verification-date: uint,
    is-active: bool,
    coverage-limit: uint
  }
)

(define-map insurer-ratings
  { insurer: principal }
  { rating: uint, total-policies: uint }
)

;; Public functions
(define-public (register-insurer (license-number (string-ascii 50)) (coverage-limit uint))
  (let ((insurer tx-sender))
    (asserts! (> (len license-number) u0) ERR_INVALID_LICENSE)
    (asserts! (is-none (map-get? verified-insurers { insurer: insurer })) ERR_ALREADY_VERIFIED)
    (map-set verified-insurers
      { insurer: insurer }
      {
        license-number: license-number,
        verification-date: block-height,
        is-active: true,
        coverage-limit: coverage-limit
      }
    )
    (map-set insurer-ratings { insurer: insurer } { rating: u5, total-policies: u0 })
    (ok true)
  )
)

(define-public (deactivate-insurer (insurer principal))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (match (map-get? verified-insurers { insurer: insurer })
      insurer-data (begin
        (map-set verified-insurers
          { insurer: insurer }
          (merge insurer-data { is-active: false })
        )
        (ok true)
      )
      ERR_NOT_FOUND
    )
  )
)

(define-public (update-rating (insurer principal) (new-rating uint))
  (begin
    (asserts! (and (>= new-rating u1) (<= new-rating u10)) (err u104))
    (match (map-get? insurer-ratings { insurer: insurer })
      rating-data (begin
        (map-set insurer-ratings
          { insurer: insurer }
          (merge rating-data { rating: new-rating })
        )
        (ok true)
      )
      ERR_NOT_FOUND
    )
  )
)

;; Read-only functions
(define-read-only (is-verified-insurer (insurer principal))
  (match (map-get? verified-insurers { insurer: insurer })
    insurer-data (get is-active insurer-data)
    false
  )
)

(define-read-only (get-insurer-info (insurer principal))
  (map-get? verified-insurers { insurer: insurer })
)

(define-read-only (get-insurer-rating (insurer principal))
  (map-get? insurer-ratings { insurer: insurer })
)
