module Seal.Proofs

open Seal.Types
open Seal.Policy
open Seal.Gate

let no_capability_implies_not_allow
  (sub:subject)
  (op:operation)
  (caps:policy)
  (evidence:evidence_state)
  (receipt:receipt_state)
  : Lemma
      (requires (has_cap caps (required_capability op) == false))
      (ensures (gate sub op caps evidence receipt == DenyMissingCapability))
  = ()

let open_without_evidence_denies
  (sub:subject)
  (caps:policy)
  (receipt:receipt_state)
  : Lemma
      (requires (has_cap caps CapOpen == true))
      (ensures (gate sub OpOpen caps EvidenceMissing receipt == DenyMissingEvidence))
  = ()

let seal_without_evidence_denies
  (sub:subject)
  (caps:policy)
  (receipt:receipt_state)
  : Lemma
      (requires (has_cap caps CapSeal == true))
      (ensures (gate sub OpSeal caps EvidenceMissing receipt == DenyMissingEvidence))
  = ()

let transition_without_receipt_denies
  (sub:subject)
  (caps:policy)
  : Lemma
      (requires (has_cap caps CapTransition == true))
      (ensures (gate sub OpTransition caps EvidenceValid ReceiptMissing == DenyMissingReceipt))
  = ()

let allow_implies_required_capability_exists
  (sub:subject)
  (op:operation)
  (caps:policy)
  (evidence:evidence_state)
  (receipt:receipt_state)
  : Lemma
      (requires (gate sub op caps evidence receipt == Allow))
      (ensures (has_cap caps (required_capability op) == true))
  =
  if has_cap caps (required_capability op) then () else ()

let allow_implies_evidence_exists_when_required
  (sub:subject)
  (op:operation)
  (caps:policy)
  (evidence:evidence_state)
  (receipt:receipt_state)
  : Lemma
      (requires (gate sub op caps evidence receipt == Allow))
      (ensures ((op_requires_evidence op == true) ==> (evidence_valid evidence == true)))
  =
  match op with
  | OpMeasure -> ()
  | OpOpen ->
      (match evidence with
       | EvidenceValid -> ()
       | EvidenceMissing ->
           if has_cap caps CapOpen then () else ())
  | OpSeal ->
      (match evidence with
       | EvidenceValid -> ()
       | EvidenceMissing ->
           if has_cap caps CapSeal then () else ())
  | OpTransition ->
      (match evidence with
       | EvidenceValid -> ()
       | EvidenceMissing ->
           if has_cap caps CapTransition then () else ())

let allow_implies_receipt_exists_when_required
  (sub:subject)
  (op:operation)
  (caps:policy)
  (evidence:evidence_state)
  (receipt:receipt_state)
  : Lemma
      (requires (gate sub op caps evidence receipt == Allow))
      (ensures ((op_requires_receipt op == true) ==> (receipt_valid receipt == true)))
  =
  match op with
  | OpMeasure -> ()
  | OpOpen -> ()
  | OpSeal -> ()
  | OpTransition ->
      (match receipt with
       | ReceiptValid -> ()
       | ReceiptMissing ->
           if has_cap caps CapTransition then
             match evidence with
             | EvidenceValid -> ()
             | EvidenceMissing -> ()
           else
             ())
