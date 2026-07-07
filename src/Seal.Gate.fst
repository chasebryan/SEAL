module Seal.Gate

open Seal.Types
open Seal.Policy

let evidence_valid (evidence:evidence_state) : Tot bool =
  match evidence with
  | EvidenceMissing -> false
  | EvidenceValid -> true

let receipt_valid (receipt:receipt_state) : Tot bool =
  match receipt with
  | ReceiptMissing -> false
  | ReceiptValid -> true

let gate
  (sub:subject)
  (op:operation)
  (caps:policy)
  (evidence:evidence_state)
  (receipt:receipt_state)
  : Tot decision =
  if has_cap caps (required_capability op) then
    if op_requires_evidence op then
      if evidence_valid evidence then
        if op_requires_receipt op then
          if receipt_valid receipt then Allow else DenyMissingReceipt
        else
          Allow
      else
        DenyMissingEvidence
    else if op_requires_receipt op then
      if receipt_valid receipt then Allow else DenyMissingReceipt
    else
      Allow
  else
    DenyMissingCapability
