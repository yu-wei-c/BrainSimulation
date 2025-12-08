# Project T – Brain Network Modelling

The **NetworkModelling** project provides empirical structural and functional brain data for **brain network modelling**.

It is designed as a teaching resource for:

> **FFR120 / FYM119 – Simulation of Complex Systems, lp2 HT25 (7.5 hp)**  
> Project work supervised by TA **Yu-Wei Chang**

In this project, you will use empirical **structural connectivity** (from DTI) as the scaffold for simulating **functional time series** and/or **functional networks**, and then compare your model output to empirical **fMRI** data.

---

## Concept

The core idea is to link structure and function:

- Each subject has a **structural brain network** (246 × 246) describing how 246 brain regions are connected.
- These regions are defined by a **BNA atlas**, which provides the list of regions and their labels.
- Using the structural network as a backbone, you build a **network model of brain activity** that generates:
  - Simulated time series for each region, and/or  
  - A simulated functional connectivity network.
- The simulated output can then be compared against **empirical fMRI data** from the same parcellation.

This allows you to explore questions such as:

- How well can structural connectivity explain functional connectivity?
- How do model assumptions (e.g. coupling strength, noise, dynamics) affect the match to empirical data?

---

## Data structure

All data for Project T live in this folder:

```text
NetworkModelling/
  data/
    DTI/
    fMRI/
    bna_atlas.xlsx
```
### BNA atlas

- **File:** `NetworkModelling/data/bna_atlas.xlsx`
- **Content:**
  - A list of 246 brain regions used in the project.
  - Region identifiers, names and (optionally) additional annotations.
- **Role:**
  - Defines the parcellation for both structural and functional data.
  - Provides labels you can use when plotting or reporting results.
- **Example visualisation:**
  - In `data_visualizatoin.m` the atlas is visualised as shown in `atlas_AD.jpg`, `atlas_CA.jpg`, and `atlas_SL.jpg`.

### Structural connectivity (DTI)

- **Folder:** `NetworkModelling/data/DTI/`
- **Content:**
  - Several Excel files (one per subject).
  - Each file contains a 246 × 246 structural connectivity matrix.
  - Rows and columns correspond to the 246 BNA regions in `bna_atlas.xlsx`.
- **Example visualisation:**
  - In `data_visualizatoin.m` the empirical structural network is visualised, as shown in `indivual_structual_netowrk.jpg`.
- **Interpretation:**
  - Matrix entries represent the connection strength between pairs of regions.
  - You can treat these as weights in a network model (e.g. coupling strengths in a dynamical system on the graph).

### Functional data (fMRI)

- **Folder:** `NetworkModelling/data/fMRI/`
- **Content:**
  - Empirical functional data for the same set of 246 regions, organised by subject.
  - Depending on the file format, this may be:
    - Region-wise time series, and/or
    - Pre-computed functional connectivity matrices (e.g. correlation networks).
- **Example visualisation:**
  - In `data_visualizatoin.m` the empirical functional network is visualised, as shown in `indivual_function_netowrk.jpg`.
- **Role:**
  - Serves as the target or “ground truth” when evaluating your model.
  - You can compare:
    - Simulated vs empirical time series statistics, or
    - Simulated vs empirical functional connectivity (e.g. correlation or coherence).

---

## Typical workflow

A typical modelling workflow for this project could be:

1. **Choose a subject**
   - Select one structural network from `data/DTI/`.
   - Optionally, select the matching fMRI data from `data/fMRI/`.

2. **Load the data**
   - Load the 246 × 246 structural matrix.
   - Load the BNA atlas and ensure that labels and indices are aligned.
   - Load the corresponding fMRI data for that subject.

3. **Build a network model**
   - Define a dynamical model on the graph (e.g. linear stochastic system, neural-mass model, oscillator network, etc.).
   - Use the structural connectivity as the coupling matrix between regions.

4. **Simulate regional time series**
   - Simulate time series for all 246 regions.
   - Ensure that simulation length and sampling rate are compatible with the empirical fMRI data (or adjust in post-processing).

5. **Derive a functional network from the simulation**
   - From the simulated time series, compute a functional connectivity matrix (for example, Pearson correlation between regional time series).
   - This gives you a model-derived functional network.

6. **Compare model and empirical data**
   - Compare the simulated functional network with the empirical fMRI network, for example by:
     - Global measures (e.g. correlation between upper triangles of the matrices).
     - Network statistics (e.g. degree, clustering, path length).
     - More advanced metrics (e.g. modular structure, efficiency).
   - Optionally, tune model parameters (e.g. coupling strength, noise level) to improve the fit.

---

## Example project ideas

Using this dataset, students can:

- Investigate how global coupling strength affects the similarity between structural and functional networks.
- Compare different dynamical models (e.g. linear vs nonlinear) on the same structural scaffold.
- Explore how network topology (e.g. hubs, modules) shapes simulated functional connectivity.
- Study subject-to-subject variability:
  - Do some subjects have structural networks that more easily reproduce their fMRI data?
- Implement model fitting or optimisation:
  - Adjust parameters to maximise similarity between simulated and empirical functional networks.

The exact tasks, deliverables and evaluation criteria are defined in the course project instructions provided separately.

---

## Data usage and restrictions

The data in this folder are provided exclusively for use within:

> **FFR120 / FYM119 – Simulation of Complex Systems, lp2 HT25 (7.5 hp)**

Any use beyond this scope — including redistribution, publication, or use in other projects — is **not allowed**.

By using these data, you agree to these terms.
