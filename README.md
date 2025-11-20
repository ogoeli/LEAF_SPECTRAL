# 📘 Spectral Data Processing & Analysis Workflow
*A complete R pipeline for ASD spectral consolidation, cleaning, filtering & QC*

## 📅 Date
November 9, 2025  

## 
**Paul Arellano, PhD**  provided the script for converting ASD to CSV and for the Savitzky-Golay Filtering.

---

## 🚀 Overview

This repository contains a full, two-stage R workflow for processing field-collected ASD spectral reflectance data.  
It includes:

- Automated conversion of **ASD binary files → unified CSV**  
- Data cleaning, quality control, and water-band removal  
- Clipping to physical reflectance limits  
- Savitzky–Golay smoothing  
- Plotting at each stage for visual QA/QC  
- Export of cleaned, filtered spectral datasets  

The pipeline is optimized for high-volume leaf reflectance data collected during the NAU Tree Stress 2025 campaign.

---

## 🔧 Processing Workflow

### **Stage 1 — Cleaning & Visualization**
This stage loads raw reflectance data and prepares it for filtering.

**Key Steps:**

1. **Load spectral CSV** (Wavelength + sample columns)  
2. **Standardize x-axis** to 400–2500 nm  
3. **Remove major water absorption bands**:  
   - 1350–1460 nm (SWIR-1)  
   - 1790–1960 nm (SWIR-2)  
4. **Plot 1:** Raw data with absorption bands highlighted  
5. **Plot 2:** Cleaned (band-removed) data with breaks (NA insertion)  

**Output:**

- Side-by-side comparison plot  
- Cleaned dataset for Stage 2

---

### **Stage 2 — Filtering, QC, Export**

**Key Steps:**

1. **Clip reflectance values to [0, 1]** before filtering  
2. Apply **Savitzky–Golay smoothing** (`signal::sgolayfilt`)  
   - Frame length `m` (default: 11)  
   - Polynomial order `p` (default: 3)  
3. **Plot 3:** Fully filtered spectra  
4. Export **final cleaned + smoothed** dataset as CSV  

**Output:**

- Filtered subset plot  
- Final processed dataset with water-band removal + SG filtering  

---

## 📂 ASD → CSV Consolidation Module

Includes an automated conversion script to process raw ASD `.asd` files into a consolidated, wide-format CSV.

**Features:**

- Reads all ASD files from a directory using `spectrolab::read_spectra(path = ...)`  
- Extracts wavelengths and reflectance using package-safe methods  
- Produces wide CSV:  

