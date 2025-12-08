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
  - Empirical functional data for the same set of 246 regions, organised by subject (they are matching the structural connectivity).
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

### Units and scaling

Here we summarise the unit conventions used in the provided data.

#### Structural connectivity (DTI)

In the `.xlsx` files in the `DTI` folder, the values in the structural network are **unitless** and bounded between **0** and **1**.

- Each edge weight is the **mean fractional anisotropy (FA)** along all streamlines connecting two brain regions.
- FA quantifies how directional the diffusion of water molecules is in white matter:
  - **0** means completely isotropic diffusion (equally in all directions).
  - **1** means perfectly anisotropic diffusion (diffusion only along one axis).

In other words, higher values in the structural network can be interpreted as a **stronger and more coherent white-matter pathway** between two regions.

#### Functional data (fMRI)

In the `.xlsx` files in the `fMRI` folder, the time-series matrices contain the **BOLD signal averaged within each region** and **z-scored across time** (unitless; mean 0 and standard deviation 1 per region).

- Each value therefore represents how much that region’s activity at a given time point deviates from its own mean (in standard-deviation units).
- From these time series, you can compute **functional connectivity matrices**, where each entry is the **Pearson correlation** between two regions’ time series (also unitless, ranging from –1 to 1).

---

## Typical workflow

A typical modelling workflow for this project could be:

1. **Choose subjects**
   - Select/average structural networks from `data/DTI/`.
   - Select the matching fMRI data from `data/fMRI/`.

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

- Compare different dynamical models (e.g. linear vs nonlinear) on the same structural scaffold.
- Explore how network topology (e.g. hubs, modules) shapes simulated functional connectivity.
- Study subject-to-subject variability:
  - Do some subjects have structural networks that more easily reproduce their fMRI data?
- Implement model fitting or optimisation:
  - Adjust parameters to maximise similarity between simulated and empirical functional networks.

The exact tasks, deliverables and evaluation criteria are defined in the course project instructions.

---

## Data usage and restrictions

The data in this folder are provided exclusively for use within:

> **FFR120 / FYM119 – Simulation of Complex Systems, lp2 HT25 (7.5 hp)**

Any use beyond this scope — including redistribution, publication, or use in other projects — is **not allowed**.

By using these data, you agree to these terms.
