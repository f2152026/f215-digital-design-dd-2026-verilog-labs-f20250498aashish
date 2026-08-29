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
wire [63:0] p, g;
genvar k;
generate
  for (k = 0; k<64; k= k+1) begin: gen_pandg
    xor #(2) (p[k], a[k], b[k]);
    and #(2) (g[k], a[k], b[k]);
  end
endgenerate

wire [15:0] gblk, pblk;
genvar i;
generate 
  for (i = 0; i<16; i= i+1) begin: gengblkpblk
    assign #2 gblk[i] = g[4*i+3] | (p[4*i+3] & g[4*i+2]) | (p[4*i+3] & p[4*i+2] & g[4*i+1]) | (p[4*i+3] & p[4*i+2] & p[4*i+1] & g[4*i]);
    assign #2 pblk[i] = p[4*i+3] & p[4*i+2] & p[4*i+1] & p[4*i];
  end 
endgenerate 

wire [15:1] c;
assign #2 c[1] = gblk[0] | (pblk[0] & cin);
assign #2 c[2] = gblk[1] | (pblk[1] & gblk[0])| (pblk[1] & pblk[0] & cin );
assign #2 c[3] = gblk[2] | (pblk[2] & gblk[1])| (pblk[2] & pblk[1] & gblk[0]) | (pblk[2] & pblk[1] & pblk[0] &cin );
assign #2 c[4] = gblk[3] | (pblk[3] & gblk[2])| (pblk[3] & pblk[2] & gblk[1])| (pblk[3] & pblk[2] & pblk[1] & gblk[0])| (pblk[3] & pblk[2] & pblk[1] & pblk[0] & cin);
assign #2 c[5]  = gblk[4]  | (pblk[4] & gblk[3])  | (pblk[4] & pblk[3] & gblk[2])  | (pblk[4] & pblk[3] & pblk[2] & gblk[1])  | (pblk[4] & pblk[3] & pblk[2] & pblk[1] & gblk[0])  | (pblk[4] & pblk[3] & pblk[2] & pblk[1] & pblk[0] & cin);

assign #2 c[6]  = gblk[5]  | (pblk[5] & gblk[4])  | (pblk[5] & pblk[4] & gblk[3])  | (pblk[5] & pblk[4] & pblk[3] & gblk[2])  | (pblk[5] & pblk[4] & pblk[3] & pblk[2] & gblk[1])  | (pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & gblk[0])  | (pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & pblk[0] & cin);

assign #2 c[7]  = gblk[6]  | (pblk[6] & gblk[5])  | (pblk[6] & pblk[5] & gblk[4])  | (pblk[6] & pblk[5] & pblk[4] & gblk[3])  | (pblk[6] & pblk[5] & pblk[4] & pblk[3] & gblk[2])  | (pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & gblk[1])  | (pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & gblk[0])  | (pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & pblk[0] & cin);

assign #2 c[8]  = gblk[7]  | (pblk[7] & gblk[6])  | (pblk[7] & pblk[6] & gblk[5])  | (pblk[7] & pblk[6] & pblk[5] & gblk[4])  | (pblk[7] & pblk[6] & pblk[5] & pblk[4] & gblk[3])  | (pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & gblk[2])  | (pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & gblk[1])  | (pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & gblk[0])  | (pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & pblk[0] & cin);

assign #2 c[9]  = gblk[8]  | (pblk[8] & gblk[7])  | (pblk[8] & pblk[7] & gblk[6])  | (pblk[8] & pblk[7] & pblk[6] & gblk[5])  | (pblk[8] & pblk[7] & pblk[6] & pblk[5] & gblk[4])  | (pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & gblk[3])  | (pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & gblk[2])  | (pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & gblk[1])  | (pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & gblk[0])  | (pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & pblk[0] & cin);

assign #2 c[10] = gblk[9]  | (pblk[9] & gblk[8])  | (pblk[9] & pblk[8] & gblk[7])  | (pblk[9] & pblk[8] & pblk[7] & gblk[6])  | (pblk[9] & pblk[8] & pblk[7] & pblk[6] & gblk[5])  | (pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & gblk[4])  | (pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & gblk[3])  | (pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & gblk[2])  | (pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & gblk[1])  | (pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & gblk[0])  | (pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & pblk[0] & cin);

assign #2 c[11] = gblk[10] | (pblk[10] & gblk[9])  | (pblk[10] & pblk[9] & gblk[8])  | (pblk[10] & pblk[9] & pblk[8] & gblk[7])  | (pblk[10] & pblk[9] & pblk[8] & pblk[7] & gblk[6])  | (pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & gblk[5])  | (pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & gblk[4])  | (pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & gblk[3])  | (pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & gblk[2])  | (pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & gblk[1])  | (pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & gblk[0])  | (pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & pblk[0] & cin);

assign #2 c[12] = gblk[11] | (pblk[11] & gblk[10]) | (pblk[11] & pblk[10] & gblk[9])  | (pblk[11] & pblk[10] & pblk[9] & gblk[8])  | (pblk[11] & pblk[10] & pblk[9] & pblk[8] & gblk[7])  | (pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & gblk[6])  | (pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & gblk[5])  | (pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & gblk[4])  | (pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & gblk[3])  | (pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & gblk[2])  | (pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & gblk[1])  | (pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & gblk[0])  | (pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & pblk[0] & cin);

assign #2 c[13] = gblk[12] | (pblk[12] & gblk[11]) | (pblk[12] & pblk[11] & gblk[10]) | (pblk[12] & pblk[11] & pblk[10] & gblk[9])  | (pblk[12] & pblk[11] & pblk[10] & pblk[9] & gblk[8])  | (pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & gblk[7])  | (pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & gblk[6])  | (pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & gblk[5])  | (pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & gblk[4])  | (pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & gblk[3])  | (pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & gblk[2])  | (pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & gblk[1])  | (pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & gblk[0])  | (pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & pblk[0] & cin);

assign #2 c[14] = gblk[13] | (pblk[13] & gblk[12]) | (pblk[13] & pblk[12] & gblk[11]) | (pblk[13] & pblk[12] & pblk[11] & gblk[10]) | (pblk[13] & pblk[12] & pblk[11] & pblk[10] & gblk[9])  | (pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & gblk[8])  | (pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & gblk[7])  | (pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & gblk[6])  | (pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & gblk[5])  | (pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & gblk[4])  | (pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & gblk[3])  | (pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & gblk[2])  | (pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & gblk[1])  | (pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & gblk[0])  | (pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & pblk[0] & cin);

assign #2 c[15] = gblk[14] | (pblk[14] & gblk[13]) | (pblk[14] & pblk[13] & gblk[12]) | (pblk[14] & pblk[13] & pblk[12] & gblk[11]) | (pblk[14] & pblk[13] & pblk[12] & pblk[11] & gblk[10]) | (pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & gblk[9])  | (pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & gblk[8])  | (pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & gblk[7])  | (pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & gblk[6])  | (pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & gblk[5])  | (pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & gblk[4])  | (pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & gblk[3])  | (pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & gblk[2])  | (pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & gblk[1])  | (pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & gblk[0])  | (pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & pblk[0] & cin);

assign #2 cout  = gblk[15] | (pblk[15] & gblk[14]) | (pblk[15] & pblk[14] & gblk[13]) | (pblk[15] & pblk[14] & pblk[13] & gblk[12]) | (pblk[15] & pblk[14] & pblk[13] & pblk[12] & gblk[11]) | (pblk[15] & pblk[14] & pblk[13] & pblk[12] & pblk[11] & gblk[10]) | (pblk[15] & pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & gblk[9])  | (pblk[15] & pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & gblk[8])  | (pblk[15] & pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & gblk[7])  | (pblk[15] & pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & gblk[6])  | (pblk[15] & pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & gblk[5])  | (pblk[15] & pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & gblk[4])  | (pblk[15] & pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & gblk[3])  | (pblk[15] & pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & gblk[2])  | (pblk[15] & pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & gblk[1])  | (pblk[15] & pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & gblk[0])  | (pblk[15] & pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & pblk[0] & cin);

  cla4 block0  (.a(a[3:0]),   .b(b[3:0]),   .cin(cin),   .sum(sum[3:0]),   .cout());
  cla4 block1  (.a(a[7:4]),   .b(b[7:4]),   .cin(c[1]),  .sum(sum[7:4]),   .cout());
  cla4 block2  (.a(a[11:8]),  .b(b[11:8]),  .cin(c[2]),  .sum(sum[11:8]),  .cout());
  cla4 block3  (.a(a[15:12]), .b(b[15:12]), .cin(c[3]),  .sum(sum[15:12]), .cout());
  cla4 block4  (.a(a[19:16]), .b(b[19:16]), .cin(c[4]),  .sum(sum[19:16]), .cout());
  cla4 block5  (.a(a[23:20]), .b(b[23:20]), .cin(c[5]),  .sum(sum[23:20]), .cout());
  cla4 block6  (.a(a[27:24]), .b(b[27:24]), .cin(c[6]),  .sum(sum[27:24]), .cout());
  cla4 block7  (.a(a[31:28]), .b(b[31:28]), .cin(c[7]),  .sum(sum[31:28]), .cout());
  cla4 block8  (.a(a[35:32]), .b(b[35:32]), .cin(c[8]),  .sum(sum[35:32]), .cout());
  cla4 block9  (.a(a[39:36]), .b(b[39:36]), .cin(c[9]),  .sum(sum[39:36]), .cout());
  cla4 block10 (.a(a[43:40]), .b(b[43:40]), .cin(c[10]), .sum(sum[43:40]), .cout());
  cla4 block11 (.a(a[47:44]), .b(b[47:44]), .cin(c[11]), .sum(sum[47:44]), .cout());
  cla4 block12 (.a(a[51:48]), .b(b[51:48]), .cin(c[12]), .sum(sum[51:48]), .cout());
  cla4 block13 (.a(a[55:52]), .b(b[55:52]), .cin(c[13]), .sum(sum[55:52]), .cout());
  cla4 block14 (.a(a[59:56]), .b(b[59:56]), .cin(c[14]), .sum(sum[59:56]), .cout());
  cla4 block15 (.a(a[63:60]), .b(b[63:60]), .cin(c[15]), .sum(sum[63:60]), .cout());
  

  
endmodule
