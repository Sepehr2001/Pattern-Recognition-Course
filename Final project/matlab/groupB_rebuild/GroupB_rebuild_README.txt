Group B rebuild — MATLAB R2023b

1. Create:
  \SSVEP_Article_Reproduction\matlab\groupB_rebuild

2. Put B00_B02_groupB_rebuild_pipeline.m in that folder.

3. Run:
   B00_B02_groupB_rebuild_pipeline

4. Select the Tsinghua Benchmark Dataset root folder when MATLAB asks.

The script:
- audits all 18 Group B subject files;
- verifies 9, 10, 11, and 12 Hz indices from Freq_Phase.mat;
- selects Oz channel 62;
- crops samples 126:1375;
- applies four-level db4 DWT;
- extracts cD4 and reconstructs D4 to 1250 samples;
- computes FFT;
- saves the dominant frequency and five strongest local peaks for every trial;
- compares both 7.8–15.6 Hz and 7.8125–15.625 Hz interpretations;
- exports two Classification Learner files;
- saves all intermediate raw, cD4, reconstructed D4, and comparison data.

Send these console sections back:
- Verified target-frequency mapping
- Rounded article band results
- Theoretical D4 band results
- Subject-class comparison
