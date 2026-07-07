module Seal.Matrix

open Seal.Types
open Seal.Policy
open Seal.Gate

let is_allow (decision:decision) : Tot bool =
  match decision with
  | Allow -> true
  | DenyMissingCapability -> false
  | DenyMissingEvidence -> false
  | DenyMissingReceipt -> false

let measure_missing_capability_denies
  (sub:subject)
  (caps:policy)
  (evidence:evidence_state)
  (receipt:receipt_state)
  : Lemma
      (requires (has_cap caps CapMeasure == false))
      (ensures (gate sub OpMeasure caps evidence receipt == DenyMissingCapability))
  = ()

let measure_capability_allows
  (sub:subject)
  (caps:policy)
  (evidence:evidence_state)
  (receipt:receipt_state)
  : Lemma
      (requires (has_cap caps CapMeasure == true))
      (ensures (gate sub OpMeasure caps evidence receipt == Allow))
  = ()

let measure_evidence_irrelevant
  (sub:subject)
  (caps:policy)
  (left:evidence_state)
  (right:evidence_state)
  (receipt:receipt_state)
  : Lemma
      (ensures (gate sub OpMeasure caps left receipt == gate sub OpMeasure caps right receipt))
  =
  if has_cap caps CapMeasure then () else ()

let measure_receipt_irrelevant
  (sub:subject)
  (caps:policy)
  (evidence:evidence_state)
  (left:receipt_state)
  (right:receipt_state)
  : Lemma
      (ensures (gate sub OpMeasure caps evidence left == gate sub OpMeasure caps evidence right))
  =
  if has_cap caps CapMeasure then () else ()

let open_missing_capability_denies
  (sub:subject)
  (caps:policy)
  (evidence:evidence_state)
  (receipt:receipt_state)
  : Lemma
      (requires (has_cap caps CapOpen == false))
      (ensures (gate sub OpOpen caps evidence receipt == DenyMissingCapability))
  = ()

let open_missing_evidence_denies
  (sub:subject)
  (caps:policy)
  (receipt:receipt_state)
  : Lemma
      (requires (has_cap caps CapOpen == true))
      (ensures (gate sub OpOpen caps EvidenceMissing receipt == DenyMissingEvidence))
  = ()

let open_valid_evidence_allows
  (sub:subject)
  (caps:policy)
  (receipt:receipt_state)
  : Lemma
      (requires (has_cap caps CapOpen == true))
      (ensures (gate sub OpOpen caps EvidenceValid receipt == Allow))
  = ()

let open_receipt_irrelevant
  (sub:subject)
  (caps:policy)
  (evidence:evidence_state)
  (left:receipt_state)
  (right:receipt_state)
  : Lemma
      (ensures (gate sub OpOpen caps evidence left == gate sub OpOpen caps evidence right))
  =
  if has_cap caps CapOpen then
    match evidence with
    | EvidenceMissing -> ()
    | EvidenceValid -> ()
  else
    ()

let seal_missing_capability_denies
  (sub:subject)
  (caps:policy)
  (evidence:evidence_state)
  (receipt:receipt_state)
  : Lemma
      (requires (has_cap caps CapSeal == false))
      (ensures (gate sub OpSeal caps evidence receipt == DenyMissingCapability))
  = ()

let seal_missing_evidence_denies
  (sub:subject)
  (caps:policy)
  (receipt:receipt_state)
  : Lemma
      (requires (has_cap caps CapSeal == true))
      (ensures (gate sub OpSeal caps EvidenceMissing receipt == DenyMissingEvidence))
  = ()

let seal_valid_evidence_allows
  (sub:subject)
  (caps:policy)
  (receipt:receipt_state)
  : Lemma
      (requires (has_cap caps CapSeal == true))
      (ensures (gate sub OpSeal caps EvidenceValid receipt == Allow))
  = ()

let seal_receipt_irrelevant
  (sub:subject)
  (caps:policy)
  (evidence:evidence_state)
  (left:receipt_state)
  (right:receipt_state)
  : Lemma
      (ensures (gate sub OpSeal caps evidence left == gate sub OpSeal caps evidence right))
  =
  if has_cap caps CapSeal then
    match evidence with
    | EvidenceMissing -> ()
    | EvidenceValid -> ()
  else
    ()

let transition_missing_capability_denies
  (sub:subject)
  (caps:policy)
  (evidence:evidence_state)
  (receipt:receipt_state)
  : Lemma
      (requires (has_cap caps CapTransition == false))
      (ensures (gate sub OpTransition caps evidence receipt == DenyMissingCapability))
  = ()

let transition_missing_evidence_denies
  (sub:subject)
  (caps:policy)
  (receipt:receipt_state)
  : Lemma
      (requires (has_cap caps CapTransition == true))
      (ensures (gate sub OpTransition caps EvidenceMissing receipt == DenyMissingEvidence))
  = ()

let transition_missing_receipt_denies
  (sub:subject)
  (caps:policy)
  : Lemma
      (requires (has_cap caps CapTransition == true))
      (ensures (gate sub OpTransition caps EvidenceValid ReceiptMissing == DenyMissingReceipt))
  = ()

let transition_valid_evidence_and_receipt_allows
  (sub:subject)
  (caps:policy)
  : Lemma
      (requires (has_cap caps CapTransition == true))
      (ensures (gate sub OpTransition caps EvidenceValid ReceiptValid == Allow))
  = ()

let missing_capability_dominates_missing_evidence
  (sub:subject)
  (op:operation)
  (caps:policy)
  (receipt:receipt_state)
  : Lemma
      (requires (has_cap caps (required_capability op) == false))
      (ensures (gate sub op caps EvidenceMissing receipt == DenyMissingCapability))
  = ()

let missing_capability_dominates_missing_receipt
  (sub:subject)
  (op:operation)
  (caps:policy)
  (evidence:evidence_state)
  : Lemma
      (requires (has_cap caps (required_capability op) == false))
      (ensures (gate sub op caps evidence ReceiptMissing == DenyMissingCapability))
  = ()

let missing_evidence_dominates_missing_receipt_when_evidence_required
  (sub:subject)
  (op:operation)
  (caps:policy)
  : Lemma
      (requires ((has_cap caps (required_capability op) == true) /\ (op_requires_evidence op == true)))
      (ensures (gate sub op caps EvidenceMissing ReceiptMissing == DenyMissingEvidence))
  =
  match op with
  | OpMeasure -> ()
  | OpOpen -> ()
  | OpSeal -> ()
  | OpTransition -> ()

let allow_impossible_for_open_without_evidence_valid
  (sub:subject)
  (caps:policy)
  (receipt:receipt_state)
  : Lemma
      (ensures (is_allow (gate sub OpOpen caps EvidenceMissing receipt) == false))
  =
  if has_cap caps CapOpen then () else ()

let allow_impossible_for_seal_without_evidence_valid
  (sub:subject)
  (caps:policy)
  (receipt:receipt_state)
  : Lemma
      (ensures (is_allow (gate sub OpSeal caps EvidenceMissing receipt) == false))
  =
  if has_cap caps CapSeal then () else ()

let allow_impossible_for_transition_without_evidence_valid
  (sub:subject)
  (caps:policy)
  (receipt:receipt_state)
  : Lemma
      (ensures (is_allow (gate sub OpTransition caps EvidenceMissing receipt) == false))
  =
  if has_cap caps CapTransition then () else ()

let allow_impossible_for_transition_without_receipt_valid
  (sub:subject)
  (caps:policy)
  (evidence:evidence_state)
  : Lemma
      (ensures (is_allow (gate sub OpTransition caps evidence ReceiptMissing) == false))
  =
  if has_cap caps CapTransition then
    match evidence with
    | EvidenceMissing -> ()
    | EvidenceValid -> ()
  else
    ()
