# Reproduction Map — Per-Claim Script and Data File Mapping

This file maps every numerical claim, table, figure, and theorem reference in the paper to the script and data file that produces it, plus a one-line verification command.

The claim numbering follows the paper's Table 5 (Reproduction Map). For the script registry (S1-S16, F1-F3) see paper Table 4 or `README.md`.

---

## Section 1 (Introduction) and Abstract Claims

| Paper location          | Claim                                                              | Verification                                              |
|-------------------------|--------------------------------------------------------------------|-----------------------------------------------------------|
| Abstract sentence 1     | "first quantitative prediction of grokking delay under AdamW"      | n/a (positioning)                                         |
| Abstract, MAPE 17.7%    | Tier-1 MAPE on N=26 held-out runs spanning 41× delay range         | `Table_predictive_MAPE.json` (S13)                        |
| Abstract, MAPE 18.0%    | Tier-2 cross-architecture MAPE on N=34                             | `Table_predictive_MAPE.json` (S13)                        |
| Abstract, MAPE 23.3%    | Tier-3 full cross-task MAPE on N=46                                | `Table_predictive_MAPE.json` (S13)                        |
| Abstract, α*=47.2° / 47.8° | C-coefficient calibrated on p=89 predicts p=97 within 1.3% error | `alpha_star_calibration.json` (S11)                       |
| Abstract, Block F 0/6 vs 3/3 | Causal interventions eliminate grokking; baseline groks 3/3   | `Table_block_F_outcomes.json` (S2 + S7)                   |
| Intro Fig 1            | Phenomenon, mechanism, prediction visual                            | `figures/fig1_visual_abstract.pdf` (F1)                   |
| Intro, R² ≈ 0.97       | Per-trajectory exponential fit quality                              | `per_traj_kappas.json` (S5)                               |

---

## Section 2 (Setup) Claims

| Paper location | Claim                                                  | Source                                                |
|----------------|--------------------------------------------------------|-------------------------------------------------------|
| §2 Notation    | AdamW recursion form                                   | `code/shared_grokking.py` (defines `train_one_run`)   |
| §2 Headline cell | p=97, η=10⁻³, λ=1.0, op=add, arch=1L                 | All training scripts default to this cell             |

---

## Section 3 (Theorems) Claims

| Paper location           | Claim                                                          | Source                                                      |
|--------------------------|----------------------------------------------------------------|-------------------------------------------------------------|
| Proposition 1 (upper)    | Norm contraction upper bound (clean SGD)                       | Proof in paper App. A; analytical                           |
| Proposition 2 (lower)    | Matching lower bound (clean SGD)                               | Proof in paper App. B; analytical                           |
| Corollary 1 (necessity)  | Norm-separation necessary for positive delay                   | Proof in paper App. C; tested on `sparse_parity.json`       |
| Theorem 1 (joint necessity) | Quantile-margin proof: positive delay requires norm sep + α* | Proof in paper App. H; α* calibration via S11               |

---

## Section 4 (Empirical Verification of Theorem Form) Claims

| Paper location | Claim                                              | Script | Data file                            | Verify                                                                      |
|----------------|----------------------------------------------------|--------|--------------------------------------|-----------------------------------------------------------------------------|
| §4.2 Result 1  | Per-trajectory log-linear fit median R² = 0.97 (N=39, IQR [0.94, 0.98], 69% with R²>0.95) | S5 | `data/campaign1_summary.json` | `cd code && python explore_trajectories.py` (writes `results/per_traj_kappas.json`) |
| §4.2           | Aggregate η-exponent 1.02 ± 0.08 (R²=0.98); λ-exponent 1.26 ± 0.21 (R²=0.90) | S6 | `data/campaign1_summary.json` | `cd code && python analyze_v3.py`                                          |

---

## Section 5 (The Correction Factor κ for AdamW) Claims

| Paper location | Claim                                          | Script        | Data file                                                | Verify                                                                  |
|----------------|------------------------------------------------|---------------|----------------------------------------------------------|-------------------------------------------------------------------------|
| §5.1 Headline  | κ_AdamW = 0.24 (1L, N=39, IQR [0.20, 0.28], pooled CV 27%, within-cell median CV 14%) | S15 | `Table_campaign1_kappa_summary.json` (`results/`)        | `cd code && python analyze_kappa_statistics.py`                          |
| §5.1           | κ_mult = 0.23 (modular multiplication, p=97)   | S6            | `data/campaign1_summary.json`                            | grep `op="mult"` runs                                                   |
| §5.2 Theorem 1 | α* = 47.2° (p=89 calibration → p=97), observed 47.8°, error 1.3% | S11 | `data/alpha_star_calibration.json`                       | `cd code && python run_block_H_cross_cell.py` (training, ~1h)            |
| §5.2           | C-coefficient stable to CV 1.7% across p-sweep | S11           | `data/alpha_star_calibration.json`                       | inspect alpha_star_calibration.json                                     |
| §5.3 Predictive | κ_train=0.252, V★_train=2501 (calibration cell, N=10 unique 1L runs at p=97, η=1e-3, λ=1.0) | S13 | `Table_predictive_MAPE.json`                             | `cd code && python predictive_validation_three_tier.py`                  |
| §5.3 Tier-1 MAPE | 17.7% on N=26 hyperparameter held-out (41.3× delay range)       | S13          | `Table_predictive_MAPE.json` (key `Tier_1_hyperparameter`)  | as above                                                                |
| §5.3 Tier-2 MAPE | 18.0% on N=34 (1L → MLP)                                        | S13          | `Table_predictive_MAPE.json` (key `Tier_2_cross_arch`)      | as above                                                                |
| §5.3 Tier-3 MAPE | 23.3% on N=46 full cross-task (43.5× range)                     | S13          | `Table_predictive_MAPE.json` (key `Tier_3_full`)            | as above                                                                |
| §5.3           | Method A range 32.8% / 34.3% / 37.4% (three tiers)              | S13          | `Table_predictive_MAPE.json` (`MAPE_A_pct` per tier)        | as above                                                                |
| §5.3           | V★/V_mem ratio CV ≈ 14% on 1L (structured, not universal)       | S14          | `results/cross_cell_residuals.json`                          | `cd code && python analyze_cross_cell_residuals.py`                      |
| §5.4 Kosson    | κ_LL = f_window · κ_kos                                         | S12           | `data/transformer2_refit_summary.json`                    | `cd code && python verify_refit_T_grok95.py`                            |
| §5.4           | κ_kos = 0.668 (paper-2L), CV 5-6% within architecture           | S12           | `Table_kosson_decomposition.json`                          | as above                                                                |
| §5.4           | f_window CV 29% across 12 Block H cells (honest null finding)   | S12 + S11     | derived from S11 + S12                                    | `cd code && python verify_refit_T_grok95.py`                            |

---

## Section 6 (Cross-Task Validation and Necessity) Claims

| Paper location           | Claim                                                  | Script        | Data file                                            | Verify                                                                  |
|--------------------------|--------------------------------------------------------|---------------|-------------------------------------------------------|-------------------------------------------------------------------------|
| §6.1 Modular mult        | κ_mult = 0.23 (3 seeds, IQR [0.23, 0.27], CV 16%)      | S6            | `data/campaign1_summary.json`                        | `cd code && python analyze_v3.py`                                       |
| §6.2 Sparse parity       | T_grok − T_mem = 0 in 3/3 seeds; V_post > V_mem (norm inversion) | -      | `data/sparse_parity.json`                            | inspect file                                                            |
| §6.3 SGD/AdamW gap       | SGD plateaus at chance (1.9%); AdamW groks 3/3         | -             | `data/sgd_test.json`                                 | inspect file                                                            |
| §6.4 1L vs 2L            | t-test p < 10⁻⁹                                         | S15           | `kappa_statistics_summary.json`                      | `cd code && python analyze_kappa_statistics.py`                          |
| §6.4 Paper-2L            | κ = 0.370 ± 0.056 (N=29, CV 15%)                       | S15 (uses S9, S12) | `Table_paper_2L_kappa_summary.json`             | `cd code && python analyze_kappa_statistics.py`                          |
| §6.4 Alt-2L              | κ = 0.175 ± 0.018 (N=30, CV 10%)                       | S15 (uses S10) | `Table_alt_2L_kappa_summary.json`                   | as above                                                                |
| §6.4 R6 (App. M)         | Held-out paper-2L MAPE 15.1% (calibrated on 1L only)   | S13 (paper-2L test) | `predictive_validation_three_tier.json`        | `cd code && python predictive_validation_three_tier.py`                 |
| §6.5 Block F             | F1: 3/3 grok                                            | S2            | `Table_block_F_outcomes.json`                        | `cd code && python master_experiment_v7.py --condition F1` (training)    |
| §6.5 Block F             | F2: 3/3 grok (rescale; framed as null at N=3)           | S2            | `Table_block_F_outcomes.json`                        | as above                                                                |
| §6.5 Block F             | F3 norm-freeze: 0/3 grok in 30k; α_final = 13.1°       | S2            | `Table_block_F_outcomes.json` + `block_F_runs.json`  | as above                                                                |
| §6.5 Block F             | F4 wd-freeze: 0/3 grok in 30k; α_final = 10.4°         | S2            | `Table_block_F_outcomes.json` + `block_F_runs.json`  | as above                                                                |

---

## Appendix-level Claims

### Appendix A, B, C (Proofs)

Analytical only. No script.

### Appendix D (AdamW analysis)

| Claim                                  | Source                                          |
|----------------------------------------|-------------------------------------------------|
| AdamW correction structure             | citation + S12 (Kosson refit)                   |
| Asymptotic implicit bias               | citation only [Xie & Li 2024]                   |

### Appendix G (Predictive validation)

| Claim                                  | Script        | Data file                                            |
|----------------------------------------|---------------|-------------------------------------------------------|
| §G.1 Calibration (10 unique trajectories, footnote on dedup) | S13 + S15 | `predictive_validation_three_tier.json`             |
| §G.2 Table 1 (three-tier MAPE)         | S13            | `predictive_validation_three_tier.json`              |
| §G.2 Table 2 (per-cell MAPE breakdown) | S13            | `predictive_validation_three_tier.json` (per_cell)   |
| §G.4 Cross-cell residuals (V★/V_mem)   | S14            | `cross_cell_residuals.json`                          |
| §G.5 LOOCV (V★ stable to ~6%, κ to ~7%) | S4            | `V_star_LOOCV.json`                                  |

### Appendix H (Joint necessity proof)

Analytical only; α* formula derivation. Empirical α* per-cell verification via S11 (`Table_block_H_alpha_star.json`).

### Appendix K (Cross-architecture full statistics)

| Claim                                          | Script        | Data file                                            |
|------------------------------------------------|---------------|-------------------------------------------------------|
| Within-arch CV ≤ 15% (rules out fitting artefact) | S15        | `kappa_statistics_summary.json`                      |
| Between-arch ~ 2× spread                       | S15            | All four arch summaries                              |
| Kosson decomposition: κ_kos CV 6.2% within arch | S12           | `Table_kosson_decomposition.json`                    |
| f_window not architecture-universal (CV 29% across Block H 12 cells) | S12+S11 | derived                                          |

### Appendix M (Overshoot dynamics) — formerly App. L

| Claim                                          | Script        | Data file                                            |
|------------------------------------------------|---------------|-------------------------------------------------------|
| Overshoot power law: extra_delay/delay₉₅ = 0.025·ρ_drop⁻⁵·⁵¹ | S12 | `data/transformer2_refit_summary.json`              |
| R² = 0.869, p < 10⁻¹³, N = 29                 | S12            | `data/transformer2_refit_summary.json` (`summary_overshoot`) |

### Appendix B (Block H per-cell results)

| Claim                                          | Script        | Data file                                            |
|------------------------------------------------|---------------|-------------------------------------------------------|
| Cross-cell α* mean 52.8° ± 7.9°, CV 15.0%, N_cells=12 | S11+S7 | `Table_block_H_alpha_star.json` (`cross_cell`)        |
| Per-cell α*, V★, τ_V/τ_α (12 cells)            | S11+S7        | `Table_block_H_alpha_star.json` (`per_cell`)          |
| τ_V/τ_α = 0.28 ± 0.05 (norm contracts ~4× faster than direction) | S11+S7 | `block_H_runs.json` (overall)                       |

---

## Figures

| Figure                                  | Source script                | Source data                                                | Verify                                                             |
|-----------------------------------------|------------------------------|-------------------------------------------------------------|--------------------------------------------------------------------|
| Fig 1 (visual abstract)                 | F1: `make_figures_v3.py`     | `data/campaign1_summary.json`                              | `cd code && python make_figures_v3.py`                              |
| Fig 2 (per-trajectory fits)             | F1: `make_figures_v3.py`     | `data/campaign1_summary.json`                              | as above                                                           |
| Fig 3 (κ universality)                  | F1: `make_figures_v3.py`     | `data/campaign1_summary.json`                              | as above                                                           |
| Fig 4 (necessity dichotomy)             | F1: `make_figures_v3.py`     | `data/sparse_parity.json` + `data/sgd_test.json`           | as above                                                           |
| Fig 5 (cross-arch overlay)              | F2: `make_fig5_v3.py`        | `data/campaign1_summary.json` + `data/transformer2_*.json` | `cd code && python make_fig5_v3.py`                                 |
| Fig 6 (norm-direction decoupling)       | F2: `make_fig5_v3.py`        | `data/block_H_runs.json`                                   | as above                                                           |
| Fig 7 (causal ablation)                 | F3: `make_fig6_v3.py`        | `data/block_F_runs.json`                                   | `cd code && python make_fig6_v3.py`                                 |
| Fig 8 (predictive scatter)              | F3: `make_fig6_v3.py`        | `predictive_validation_B.json`                             | as above                                                           |

Note: figure scripts produce *schematic versions* of the published figures (sufficient for verification of the underlying numerical content). The polished published figures in `figures/` use the same data files and the same numerical content but were rendered with additional matplotlib styling.

---

## Tables in paper

| Table   | Content                                  | Generated by  | Source data                                            |
|---------|------------------------------------------|---------------|---------------------------------------------------------|
| Table 1 | Three-tier predictive MAPE               | S13           | `predictive_validation_three_tier.json`                 |
| Table 2 | Per-cell predictive MAPE breakdown       | S13           | `predictive_validation_three_tier.json` (per_cell)      |
| Table 3 | Block F outcomes                         | S2 + S7       | `Table_block_F_outcomes.json`                           |
| Table 4 | Script Registry (this file's S1-S16, F1-F3) | manual    | n/a                                                     |
| Table 5 | Reproduction Map                         | manual        | n/a (encoded in this file)                              |
| Table 6 | Positioning vs grokking literature       | manual        | n/a                                                     |
| Table B3 (App. B) | Block H per-cell α*, V★, τ_V/τ_α | S11+S7      | `Table_block_H_alpha_star.json`                         |

---

## End-to-end verification (recommended)

```bash
cd code

# Tier 1: 30-second audit
python audit_repo.py
cat ../audit_report.txt

# Tier 2: regenerate all results (~10 min, CPU only)
python S16_regenerate_summaries.py
python explore_trajectories.py
python analyze_v3.py
python analyze_kappa_statistics.py
python analyze_cross_cell_residuals.py
python predictive_validation.py
python predictive_validation_three_tier.py
python verify_refit_T_grok95.py
python audit_repo.py    # Re-run audit
```

Expected output: `16 PASS, 0 PARTIAL, 0 FAIL, 0 SKIP`. Items marked `SKIP` (none expected) would mean an upstream script must be run first; the audit reports exactly which.
