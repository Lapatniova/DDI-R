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


## Insert DDI universe metadata from Excel

### Description

This script automates the insertion of **DDI `<universe>` metadata** at the variable level in a DDI XML file
exported from **Nesstar** or **NADA**.

It is designed to avoid manually filling the *Universe / Filter* field in Nesstar or NADA by using
an external Excel mapping file.

---

### Input files

#### 1. DDI XML file
- Exported from Nesstar or NADA
- Must already contain `<var>` elements with a `name` attribute
- DDI Codebook format (DDI 2.x)

#### 2. Excel mapping file
The Excel file must contain exactly two columns:

| Column name | Description |
|------------|-------------|
| `variable` | Variable name (must exactly match the XML) |
| `universe` | Universe / filter text to insert |

---

### What the script does

For each variable listed in the Excel file, the script:

1. Checks if the variable exists in the XML
2. Locates the corresponding `<var>` node
3. Creates a `<universe>` tag if it does not exist
4. Updates the `<universe>` content if it already exists
5. Leaves all other metadata unchanged

Variables not found in the XML are ignored.

---

### Output

The script produces a new DDI XML file containing populated `<universe>` tags at the variable level.

This XML file can be safely re-imported into Nesstar or NADA.



