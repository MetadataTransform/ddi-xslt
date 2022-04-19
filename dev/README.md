# development

Create a new file `docker-compose.override.yml`

Set the enviroment parameters for the XSLT and XML to use in development

```yml
version: "3"
services:
  ddi-xslt-dev:
    environment:
      XSLT: /transformations/dcterms/from-ddi-3.2/ddi_3_2-dcterms.xslt
      XML: /examples/ddi-3.2/ZA4586_ddi-I_StudyDescription_3_2.xml
```

To use the [CESSDA CMV](https://cmv.cessda.eu) validator after transformation supply a profile XML:
```yml
version: "3"
services:
  ddi-xslt-dev:
    environment:
      XSLT: /transformations/cessda-eqb/from-ddi-2.5/ddi_2_5-cessda_eqb.xslt
      XML: /examples/ddi-2.5/2020-130.xml
      PROFILE: /profiles/eqb/ddi-2.5.xml
      GATE: BASIC
```
CESSDA CMV profiles in docker image:
```
/profiles/cdc/1.2.2.xml
/profiles/cdc/ddi-1.2.2-monolingual.xml
/profiles/cdc/ddi-2.5.xml
/profiles/cdc/ddi-2.5-monolingual.xml
/profiles/cdc/ddi-3.2.xml
/profiles/eqb/ddi-2.5.xml
/profiles/eqb/ddi-3.2.xml
```

Values for GATE using CESSDA CMV: `BASIC`, `BASICPLUS`, `EXTENDED`, `STANDARD`, `STRICT`



Note: In case of compilation error, change End Of Line sequence from CRLF to LF in `run.sh` script.