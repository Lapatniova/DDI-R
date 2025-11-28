# DDI-R

R scripts to automate DDI documentation.

---

## Scripts

This repository will contain multiple R scripts to automate the import of variable metadata into DDI XML files.

# inject_modalities.R

`inject_modalities.R` is an R script to inject variable modalities from an Excel file into a DDI XML file.  
It processes multiple variables, harmonizes variable names in lowercase, and creates the corresponding tags in the XML.

---

## Dependencies
- `xml2`  
- `tidyverse`  
- `openxlsx`

Make sure these packages are installed before running the script:

```r
install.packages(c("xml2", "tidyverse", "openxlsx"))
```
## **Required files**

To run the script, you need two files:

Excel file with the modalities:

Column 1: variable name (nom_variable)

Column 2: modality code (code_modalite)

Column 3: label for each modality (libelle_modalite)
(e.g., data/modalities.xlsx)

XML file with the variable names (output from Nada or Nesstar)
(e.g., data/input.xml)

## **Loading the function**

The function inject_modalities is defined inside the script.
Before running it, you need to source the script in your R session:
```r
source("inject_modalities.R")
```

Now you can call the function by specifying the file paths:
```r
inject_modalities(
  xml_path = "data/input.xml",
  excel_path = "data/modalities.xlsx",
  output_xml_path = "data/output.xml"
)
```

## **Arguments**

xml_path: path to the input XML file (data/input.xml)

excel_path: path to the Excel file containing the modalities (data/modalities.xlsx)

output_xml_path: path to the output XML file (data/output.xml)


This will inject the modalities from the Excel file into the XML file and generate the updated XML.

## **Zenodo DOI**

This script is archived and citable via Zenodo:

## **Citation**

Alena Lapatniova. (2025). inject_modalities (Version v1.1) [Computer software]. Zenodo. https://doi.org/10.5281/zenodo.17752420


