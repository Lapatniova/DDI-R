# DDI-R

R scripts to automate DDI documentation.

---

## Scripts

This repository will contain multiple R scripts to automate the import of variable metadata into DDI XML files.

# inject_categories.R

`inject_categories.R` is an R script to inject variable categories from an Excel file into a DDI XML file.  
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

Excel file with the categories:

Column 1: variable name (nom_variable)

Column 2: category code (code_categorie)

Column 3: label for each category (libelle_categorie)
(e.g., data/categories.xlsx)

XML file with the variable names (output from Nada or Nesstar)
(e.g., data/input.xml)

## **Loading the function**

The function inject_categories is defined inside the script.
Before running it, you need to source the script in your R session:
```r
source("inject_categories.R")
```

Now you can call the function by specifying the file paths:
```r
inject_categories(
  xml_path = "data/input.xml",
  excel_path = "data/categories.xlsx",
  output_xml_path = "data/output.xml"
)
```

## **Arguments**

xml_path: path to the input XML file (data/input.xml)

excel_path: path to the Excel file containing the categories (data/categories.xlsx)

output_xml_path: path to the output XML file (data/output.xml)


This will inject the categories from the Excel file into the XML file and generate the updated XML.

## **Zenodo DOI**

This script is archived and citable via Zenodo:

## **Citation**

Alena Lapatniova. (2025). inject_categories (Version v1.1) [Computer software]. Zenodo. https://doi.org/10.5281/zenodo.17752420


