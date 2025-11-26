![BRAPH 2](braph2banner.png)

# BRAPH 2 Simulation

The **BRAPH 2 Simulation** distribution provides empirical brain data prepared for **numerical simulations**.  
It is designed as a teaching resource for:

> **FFR120 / FYM119 – Simulation of Complex Systems, lp2 HT25 (7.5 hp)**  
> Project work supervised by TA **Yu-Wei Chang**

This distribution reuses the core analytical infrastructure of the standard BRAPH 2 framework.  
For a general introduction to BRAPH 2, please refer to the main BRAPH 2 repository and tutorials.

---

## Overview of projects

The distribution is organised into two main project folders, each corresponding to one course project.

### Project J – Spreading Dynamics in Brain Networks

**Folder:** `SpreadingDynamics/`

Project J focuses on modelling how pathological protein aggregates spread over brain networks.

Within `SpreadingDynamics/`, the following data are provided:

- **Structural brain networks**  
  - Derived from **diffusion tensor imaging (DTI)**  
  - Folder: `SpreadingDynamics/data/DTI`

- **Amyloid and tau pathology (SUVR maps)**  
  - Derived from **positron emission tomography (PET)**  
  - Amyloid data: `SpreadingDynamics/data/PET AMYLOID`  
  - Tau data: `SpreadingDynamics/data/PET TAU`

- **Brain atlas for network and PET data**  
  - AAL-based parcellation (subset of regions)  
  - File: `SpreadingDynamics/data/aal_selected_atlas.xlsx`

A more detailed description of the data structure, file formats, and suggested loading routines can be found in the project-specific documentation:

- `SpreadingDynamics/README.md`

---

### Project T – Brain Network Modelling

**Folder:** `NetworkModelling/`

Project T focuses on brain network modelling using both structural connectivity and functional time series.

Within `NetworkModelling/`, the following data are provided:

- **Structural brain networks**  
  - Derived from **diffusion tensor imaging (DTI)**  
  - Folder: `NetworkModelling/data/DTI`

- **Functional time series**  
  - Derived from **functional magnetic resonance imaging (fMRI)**  
  - Folder: `NetworkModelling/data/fMRI`

- **Brain atlas for network and fMRI data**  
  - BNA-based parcellation  
  - File: `NetworkModelling/data/bna_atlas.xlsx`

A more detailed description of the data structure, file formats, and suggested loading routines can be found in the project-specific documentation:

- `NetworkModelling/README.md`

---

## Usage in the course

Students in **FFR120 / FYM119** can use these data to:

- Build and explore **network-based models** of brain dynamics.
- Implement **spreading models** of pathology (Project J).
- Implement and analyse **network models driven by empirical time series** (Project T).

The precise simulation tasks, model assumptions, and evaluation criteria are defined in the **project instructions** provided separately by the course and TA.
