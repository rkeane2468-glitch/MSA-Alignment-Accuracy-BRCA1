# MSA-Alignment-Accuracy-BRCA1
Final year project analyzing Multiple Sequence Alignment tools accuracy using simulated BRCA1 sequences.

## Project Aims
- Compare a few MSA tools
- Test differengt delition sizes (10bps vs 30bps)
-  Compare overlapping vs non-overlapping deletions
-  Analyse alignment accuracy

## MSA Tools Ussed
- MAFFT
- Muscle
- Clustal W
- Clustal Omega
- Kalign
- MSAProbs

## Dataset 
- Based on Brca1 sequence
- -simulated deletions: 10bp and 30bps, overlapping and non-overlapping

## Metrics
- Totalo Column Score
- Alignment edit length distance

## Analysis
- RStudio - Boxplots and Line graphs

## Steps to run experiment
1. generate datasets
2. Run alignments
3. Compare aligend sequences to reference alignment(AliDist)
4. Calculate Metrics
5. Analyse in R


