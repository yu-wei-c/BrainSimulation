# Project J – Spreading Dynamics in Brain Networks

The **SpreadingDynamics** project provides empirical structural brain networks and PET pathology maps for **modelling the spread of pathological protein aggregates** in the brain.

It is designed as a teaching resource for:

> **FFR120 / FYM119 – Simulation of Complex Systems, lp2 HT25 (7.5 hp)**  
> Project work supervised by TA **Yu-Wei Chang**

In this project, you will use empirical **structural connectivity** (from DTI) as the backbone for simulating how **amyloid and tau pathology** spread over the brain network, and then compare your model output to empirical **PET SUVR** maps.

---

## Concept

The core idea is to link structure and pathology:

- Each subject has a **structural brain network** describing how brain regions are connected (derived from DTI).
- The same parcellation is used for **amyloid** and **tau** PET data.
- Using the structural network as a scaffold, you build a **spreading model of pathology** that generates:
  - Simulated amyloid and/or tau load at each region.
- The simulated pathology pattern can then be compared against **empirical PET SUVR maps**.

This allows you to explore questions such as:

- How does network structure constrain where pathology accumulates?
- Can simple spreading rules reproduce observed amyloid/tau patterns?
- How do model parameters (e.g. propagation rate, clearance, seeding pattern) affect the match to empirical data?

---

## Data structure

All data for Project J live in this folder:

```text
SpreadingDynamics/
  data/
    DTI/
    PET AMYLOID/
    PET TAU/
    aal_selected_atlas.xlsx
```

### AAL atlas (selected regions)

- **File:** `SpreadingDynamics/data/aal_selected_atlas.xlsx`
- **Content:**
  - A subset of AAL brain regions used in the project.
  - Region identifiers, names and (optionally) additional annotations.
- **Role:**
  - Defines the parcellation for both structural and PET data.
  - Provides labels you can use when plotting or reporting results.

### Structural connectivity (DTI)

- **Folder:** `SpreadingDynamics/data/DTI/`
- **Content:**
  - One or more structural connectivity matrices (e.g. group-averaged or subject-level).
  - Rows and columns correspond to the selected AAL regions in `aal_selected_atlas.xlsx`.
- **Interpretation:**
  - Matrix entries represent the connection strength between pairs of regions.
  - You can treat these as weights in a spreading model (e.g. coupling strengths in a diffusion or infection process on the graph).

### Amyloid PET (SUVR)

- **Folder:** `SpreadingDynamics/data/PET AMYLOID/`
- **Content:**
  - Regional amyloid PET values (SUVR) for the same atlas regions as the structural network.
  - Files may be organised by subject or by diagnostic group (e.g. CN, MCI, AD).
- **Role:**
  - Provides empirical **amyloid pathology patterns** that your model should aim to reproduce.
  - Can be used as:
    - A **target map** for fitting the spreading model.
    - A **source of seeds** (e.g. early amyloid regions) when defining initial conditions.

### Tau PET (SUVR)

- **Folder:** `SpreadingDynamics/data/PET TAU/`
- **Content:**
  - Regional tau PET values (SUVR) for the same atlas regions.
  - Files may be organised by subject or diagnostic group.
- **Role:**
  - Provides empirical **tau pathology patterns**, typically more closely linked to neurodegeneration and clinical symptoms.
  - Can be modelled separately or jointly with amyloid (e.g. tau spreading conditioned on amyloid presence).

---

## Units and scaling

Here we summarise the unit conventions used in the provided data.

### Structural connectivity (DTI)

In the `.xlsx` (or similar) files in the `DTI` folder, the values in the structural network are typically **unitless** and bounded between **0** and **1** (e.g. normalised connection strengths).

- You can interpret each entry as a **relative coupling strength** between two regions.
- In spreading models, larger values usually correspond to **faster or more likely propagation** along that edge.

If you choose to re-scale or threshold the matrix (e.g. binarise, normalise rows), document your choices clearly in your report.

### PET pathology (amyloid and tau)

In the `PET AMYLOID` and `PET TAU` folders, the values are **SUVR (standardized uptake value ratio)**:

- SUVR is a **dimensionless** quantity that compares tracer uptake in each region to a reference region.
- Higher SUVR values indicate **higher tracer binding**, interpreted as **higher amyloid or tau burden**.

You may choose to:

- Work directly with SUVR values.
- Apply transformations (e.g. z-scoring across regions, thresholding) to define “pathology present/absent”.
- Aggregate subjects into group-level mean maps (e.g. CN vs MCI vs AD), depending on the project design.

---

## Typical workflow

A typical modelling workflow for this project could be:

1. **Define the network and atlas**
   - Load the structural connectivity matrix from `data/DTI/`.
   - Load the AAL atlas from `aal_selected_atlas.xlsx` and ensure indices align with the network.

2. **Prepare empirical pathology maps**
   - Load amyloid and/or tau SUVR data from `PET AMYLOID/` and `PET TAU/`.
   - Optionally:
     - Average maps within diagnostic groups (e.g. CN, MCI, AD).
     - Normalise or threshold SUVR values to define “early/late” pathology.

3. **Choose a spreading model**
   - Define a simple model for how pathology spreads over the network, for example:
     - Diffusion-like models (e.g. continuous-time diffusion on the graph Laplacian).
     - Epidemic / infection models (e.g. SI / SIR-type dynamics on the network).
     - Network-based branching or cascade models.
   - Decide how structural weights influence the propagation rate (e.g. proportional to edge weight).

4. **Define initial conditions (seeds)**
   - Choose one or more seed regions (e.g. known early-amyloid or early-tau regions).
   - Assign an initial pathology level to these regions (e.g. high SUVR, or a value of 1).

5. **Simulate spreading over time**
   - Evolve the model on the network for a range of time steps or parameter values.
   - Record the pathology level per region at each time point or at steady state.

6. **Compare model and empirical data**
   - Compare simulated pathology patterns to empirical PET SUVR maps, for example by:
     - Correlating simulated vs empirical regional pathology.
     - Comparing which regions are affected early vs late.
     - Evaluating model performance across diagnostic groups (e.g. does later time better match AD than CN?).
   - Optionally, tune model parameters (e.g. global spreading rate, clearance rate) to improve the match.

---

### Braak stage cut-offs and starting regions (optional)

To keep things simple, you do **not** need to invent your own Braak scheme from scratch.  
You can use published work as a guide:

- **Braak stage cut-offs**  
  If you want to classify subjects into Braak 0, I, I–IV, I–VI, etc., you can follow the PET-based Braak staging approach in:  
  *Biel D et al. “Tau-PET and in vivo Braak-staging as prognostic markers of future cognitive decline in cognitively normal to demented individuals”, Alzheimer’s Research & Therapy (2021), doi: 10.1186/s13195-021-00880-x.*  
  In practice, you can:
  - Choose a SUVR cut-off for each Braak stage (based on this paper), and  
  - Use that cut-off to decide whether a region or subject is Braak-positive or not.

- **Typical starting (seed) regions**  
  For picking “epicentre” regions where tau pathology starts (e.g. for your initial seeds), you can look at the regions that are involved in the earliest Braak stages in:  
  *Pelkmans W et al. “Tau-related grey matter network breakdown across the Alzheimer’s disease continuum”, Alzheimer’s Research & Therapy (2021), doi: 10.1186/s13195-021-00876-7 (see Supplementary Material).*  
  These papers show that early tau often starts in medial temporal regions (Braak I–II), and only later spreads to wider association and sensory cortices.

In your project, you can therefore:
- Pick a Braak stage cut-off (e.g. “include all regions up to Braak III–IV”), and  
- Use the earliest Braak regions as **seed ROIs** for your spreading model, then see how well the simulated pattern matches the PET data.

---

## Example project ideas

Using this dataset, students can:

- Investigate whether simple diffusion on the structural network can reproduce observed amyloid patterns.
- Compare different spreading mechanisms (diffusion vs epidemic-style models) on the same structural scaffold.
- Explore the relationship between amyloid and tau:
  - Does tau spreading require prior amyloid in the model to match empirical data?
- Study how network topology (e.g. hubs, rich-club nodes) influences the order in which regions become affected.
- Fit simple models:
  - Adjust global parameters (e.g. spreading rate, clearance) to maximise similarity between simulated and empirical pathology maps.
  - Compare model fit across different diagnostic groups.

The exact tasks, deliverables and evaluation criteria are defined in the course project instructions provided separately.

---

## Data usage and restrictions

The data in this folder are provided exclusively for use within:

> **FFR120 / FYM119 – Simulation of Complex Systems, lp2 HT25 (7.5 hp)**

Any use beyond this scope — including redistribution, publication, or use in other projects — is **not allowed**.

By using these data, you agree to these terms.
