// cla64_hier.v
// BONUS -- open-ended. No detailed scaffold is provided; this is meant to
// be a genuine design exercise. Not required for lab submission.
//
// You will likely need to modify cla4.v (or add signals alongside it) so
// that block-generate/block-propagate summaries of its own Gi, Pi signals
// are exposed as outputs, since the second-level lookahead unit below
// needs them. As with every module in this lab from Task 2 onward, every
// gate/assign you add should carry an explicit delay.
//
// Starting point (from Tutorial 3, Q4(d)):
//   - Reuse 16 four-bit CLA blocks (your cla4.v) -- their internal logic
//     doesn't change.
//   - For each block k, define:
//       Gblk_k = "this block produces a carry regardless of its incoming
//                 carry" -- a Boolean function of that block's own 4
//                 bit-level Gi, Pi signals.
//       Pblk_k = "an incoming carry sails straight through this whole
//                 block" -- likewise a function of its own Gi, Pi.
//   - Build a second-level lookahead unit -- structurally identical to
//     cla4.v, just one level up -- that computes each block's carry-in
//     directly from Gblk_0..Gblk_15, Pblk_0..Pblk_15, and cin, instead of
//     rippling block to block.
//
// To test this, wire it into dut.v as a fourth option (copy the pattern
// used for the other three) and run it through the same tb.v. Compare
// your final delay to cla64_blocked.v from Task 4.

module cla64_hier(
  input  [63:0] a,
  input  [63:0] b,
  input         cin,
  output [63:0] sum,
  output        cout
);

  // TODO: your hierarchical design goes here.
  //Gblk_k = G(4k-1) xor G(4k-2) ..
  //Pblk_k = Gblk_k-1 
  Gblk_0 = cout 
  Gblk_1
  Gblk_2
  Gblk_3
  Gblk_4
  Gblk_5
  Gblk_6
  Gblk_7
  Gblk_8
  Gblk_9
  Gblk_10
  Gblk_11
  Gblk_12
  Gblk_13
  Gblk_14
  Gblk_15 

  Pblk_0
  Pblk_1
  Pblk_2
  Pblk_3
  Pblk_4
  Pblk_5
  Pblk_6
  Pblk_7
  Pblk_8
  Pblk_9
  Pblk_10
  Pblk_11
  Pblk_12
  Pblk_13
  Pblk_14
  Pblk_15
endmodule
