module Seal.Types

type capability =
  | CapMeasure
  | CapOpen
  | CapSeal
  | CapTransition
  | CapAdmin

type operation =
  | OpMeasure
  | OpOpen
  | OpSeal
  | OpTransition

type evidence_state =
  | EvidenceMissing
  | EvidenceValid

type receipt_state =
  | ReceiptMissing
  | ReceiptValid

type subject =
  | Subject : id:nat -> subject

type decision =
  | Allow
  | DenyMissingCapability
  | DenyMissingEvidence
  | DenyMissingReceipt
