module Seal.Policy

open Seal.Types

type policy = list capability

let required_capability (op:operation) : Tot capability =
  match op with
  | OpMeasure -> CapMeasure
  | OpOpen -> CapOpen
  | OpSeal -> CapSeal
  | OpTransition -> CapTransition

let op_requires_evidence (op:operation) : Tot bool =
  match op with
  | OpMeasure -> false
  | OpOpen -> true
  | OpSeal -> true
  | OpTransition -> true

let op_requires_receipt (op:operation) : Tot bool =
  match op with
  | OpMeasure -> false
  | OpOpen -> false
  | OpSeal -> false
  | OpTransition -> true

let cap_eq (left:capability) (right:capability) : Tot bool =
  match left, right with
  | CapMeasure, CapMeasure -> true
  | CapOpen, CapOpen -> true
  | CapSeal, CapSeal -> true
  | CapTransition, CapTransition -> true
  | CapAdmin, CapAdmin -> true
  | _, _ -> false

let rec has_cap (caps:policy) (cap:capability) : Tot bool (decreases caps) =
  match caps with
  | [] -> false
  | hd :: tl -> if cap_eq hd cap then true else has_cap tl cap
