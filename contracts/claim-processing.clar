;; Maritime Insurance Claim Processing Contract
;; Handles submission, evaluation, and processing of insurance claims

(define-constant ERR_UNAUTHORIZED (err u400))
(define-constant ERR_CLAIM_EXISTS (err u401))
(define-constant ERR_CLAIM_NOT_FOUND (err u402))
(define-constant ERR_INVALID_POLICY (err u403))
(define-constant ERR_CLAIM_ALREADY_PROCESSED (err u404))
(define-constant ERR_INSUFFICIENT_EVIDENCE (err u405))

;; Claim status constants
(define-constant CLAIM_SUBMITTED u1)
(define-constant CLAIM_UNDER_REVIEW u2)
(define-constant CLAIM_APPROVED u3)
(define-constant CLAIM_REJECTED u4)
(define-constant CLAIM_PAID u5)

;; Data structures
(define-map claims
  { claim-id: uint }
  {
    policy-id: uint,
    claimant: principal,
    incident-description: (string-ascii 500),
    claimed-amount: uint,
    incident-date: uint,
    location: (string-ascii 100),
    evidence-hash: (string-ascii 64),
    status: uint,
    assessor: (optional principal),
    assessment-notes: (optional (string-ascii 300)),
    approved-amount: uint,
    submitted-at: uint,
    processed-at: uint
  }
)

(define-map claim-evidence
  { claim-id: uint }
  {
    documents: (list 10 (string-ascii 64)),
    photos: (list 10 (string-ascii 64)),
    witness-statements: (list 5 (string-ascii 64))
  }
)

(define-data-var claim-counter uint u0)

;; Public functions
(define-public (submit-claim
    (policy-id uint)
    (incident-description (string-ascii 500))
    (claimed-amount uint)
    (incident-date uint)
    (location (string-ascii 100))
    (evidence-hash (string-ascii 64))
  )
  (let ((claim-id (+ (var-get claim-counter) u1)))
    (asserts! (> (len incident-description) u10) ERR_INSUFFICIENT_EVIDENCE)
    (asserts! (> claimed-amount u0) (err u406))
    (map-set claims
      { claim-id: claim-id }
      {
        policy-id: policy-id,
        claimant: tx-sender,
        incident-description: incident-description,
        claimed-amount: claimed-amount,
        incident-date: incident-date,
        location: location,
        evidence-hash: evidence-hash,
        status: CLAIM_SUBMITTED,
        assessor: none,
        assessment-notes: none,
        approved-amount: u0,
        submitted-at: block-height,
        processed-at: u0
      }
    )
    (var-set claim-counter claim-id)
    (ok claim-id)
  )
)

(define-public (assign-assessor (claim-id uint) (assessor principal))
  (match (map-get? claims { claim-id: claim-id })
    claim-data (begin
      (asserts! (is-eq (get status claim-data) CLAIM_SUBMITTED) ERR_CLAIM_ALREADY_PROCESSED)
      (map-set claims
        { claim-id: claim-id }
        (merge claim-data {
          assessor: (some assessor),
          status: CLAIM_UNDER_REVIEW
        })
      )
      (ok true)
    )
    ERR_CLAIM_NOT_FOUND
  )
)

(define-public (process-claim
    (claim-id uint)
    (approved bool)
    (approved-amount uint)
    (assessment-notes (string-ascii 300))
  )
  (match (map-get? claims { claim-id: claim-id })
    claim-data (begin
      (asserts! (is-eq (some tx-sender) (get assessor claim-data)) ERR_UNAUTHORIZED)
      (asserts! (is-eq (get status claim-data) CLAIM_UNDER_REVIEW) ERR_CLAIM_ALREADY_PROCESSED)
      (map-set claims
        { claim-id: claim-id }
        (merge claim-data {
          status: (if approved CLAIM_APPROVED CLAIM_REJECTED),
          approved-amount: approved-amount,
          assessment-notes: (some assessment-notes),
          processed-at: block-height
        })
      )
      (ok true)
    )
    ERR_CLAIM_NOT_FOUND
  )
)

(define-public (add-evidence
    (claim-id uint)
    (documents (list 10 (string-ascii 64)))
    (photos (list 10 (string-ascii 64)))
    (witness-statements (list 5 (string-ascii 64)))
  )
  (match (map-get? claims { claim-id: claim-id })
    claim-data (begin
      (asserts! (is-eq tx-sender (get claimant claim-data)) ERR_UNAUTHORIZED)
      (map-set claim-evidence
        { claim-id: claim-id }
        {
          documents: documents,
          photos: photos,
          witness-statements: witness-statements
        }
      )
      (ok true)
    )
    ERR_CLAIM_NOT_FOUND
  )
)

(define-public (mark-claim-paid (claim-id uint))
  (match (map-get? claims { claim-id: claim-id })
    claim-data (begin
      (asserts! (is-eq (get status claim-data) CLAIM_APPROVED) (err u407))
      (map-set claims
        { claim-id: claim-id }
        (merge claim-data { status: CLAIM_PAID })
      )
      (ok true)
    )
    ERR_CLAIM_NOT_FOUND
  )
)

;; Read-only functions
(define-read-only (get-claim (claim-id uint))
  (map-get? claims { claim-id: claim-id })
)

(define-read-only (get-claim-evidence (claim-id uint))
  (map-get? claim-evidence { claim-id: claim-id })
)

(define-read-only (get-claim-counter)
  (var-get claim-counter)
)

(define-read-only (get-claims-by-status (status uint))
  ;; This would require iteration in a real implementation
  ;; For now, return the counter as a placeholder
  (var-get claim-counter)
)
