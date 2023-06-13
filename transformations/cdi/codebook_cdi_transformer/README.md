# DDI-C to DDI-CDI Transformer

Created for transforming DDI-Codebook 2.5 to DDI-CDI 1.0 but can also be used for transformations with other XSLT files.  
Development work was part of DDI Hackathon 2023 by Markus Tuominen, Thomas Gilders and Alizera Davoudian.

## XML Validation

With xmllint:

- curl -o DDI-CDI_1-0.xsd https://ddi-alliance.bitbucket.io/DDI-CDI/DDI-CDI_2022-10-06/encoding/xsd/DDI-CDI_1-0.xsd
- xmllint --noout --schema DDI-CDI_1-0.xsd /path/to/cdi.xml
